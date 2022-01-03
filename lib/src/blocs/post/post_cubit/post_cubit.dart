import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:sellout_team/src/blocs/post/post_states/post_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/cart_model.dart';
import 'package:sellout_team/src/models/category_model.dart';
import 'package:sellout_team/src/models/offer_model.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/post_services/post_services.dart';
import 'package:sellout_team/src/services/user_services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  PostServices _postServices = PostServices();

  List<File> pickedMedia = [];
  List<String> extensions = [];

  deletePickedMedia(int mediaIndex) {
    pickedMedia.removeAt(mediaIndex);
    extensions.removeAt(mediaIndex);
    emit(PostDeleteMediaSuccessState());
  }

  pickMedia() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
          allowMultiple: true);

      result?.files.forEach((element) {
        File mediaFile = File(element.path!);
        pickedMedia.add(mediaFile);
      });
      result?.files.forEach((element) {
        extensions.add(element.extension!);
      });
      print(pickedMedia.length);
      print(extensions.length);
      emit(PostPickMediaSuccessState());
    } catch (error) {
      emit(PostPickMediaErrorState(error.toString()));
    }
  }

  List<String> uploadedMedia = [];
  List<String> uploadedExtensions = [];
  final String today = ('${DateTime.now().month}-${DateTime.now().day}');
  final DateTime dateNow = DateTime.now();
  final postId = DateTime.now().millisecondsSinceEpoch;

  uploadMedia(
      {required String content,
      required String description,
      required String category,
      required GeoPoint location,
      required String price,
      required String quantity,
      required bool isNew,
      required bool isCollection,
      required bool isOffer}) async {
    //emit(PostAddPostLoadingState());

    //emit(PostUploadMediaLoadingState());
    try {
      if (pickedMedia.isNotEmpty) {
        print('picked media ${pickedMedia.length}');
        print('extensions ${extensions.length}');

        var url = baseURL + kCreatePost;

        String username = 'kamleshRahul';
        String password = 'paramSoft@123';

        try {
          
          http.MultipartRequest request = new http.MultipartRequest('POST', Uri.parse(url));


          request.fields['content'] =content;
          request.fields['country'] = (userCountry == null ? '' : userCountry)!;
          request.fields['description'] = description;
          request.fields['locality'] = (userLocality == null ? '' : userLocality)!;
          request.fields['price'] = price;
          request.fields['quantity'] = quantity;
          request.fields['categoryId'] = category;
          request.fields['userId'] = kUserModel!.id.toString();
          request.fields['isCollection'] = isCollection == false ? "0" : "1";
          request.fields['isNew'] = isNew == false ? "0" : "1";
          request.fields['isOffer'] =isOffer == false ? "0" : "1";
          request.fields['postDate'] = "";

          String basicAuth =
              'Basic ' + base64Encode(utf8.encode('$username:$password'));

          Map<String, String> headers = {'authorization': basicAuth,
            'Accept': 'application/json',
            "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
            "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"};

          request.headers.addAll(headers);

          List<http.MultipartFile> newList = [];
          for (var img in pickedMedia) {
              var multipartFile = await http.MultipartFile.fromPath(
                'images[]',
                img.path,
                filename: img.path.split('/').last,
              );
              newList.add(multipartFile);
          }
          request.files.addAll(newList);

          var response = await request.send();

          if (response.statusCode == 200) {
            emit(PostAddPostSuccessState());
          } else {
            emit(PostAddPostErrorState("Something went wrong"));
          }

        } catch (error) {
          emit(PostAddPostErrorState(error.toString()));
        }
      }
    } catch (error) {
      print('$error');
      emit(PostUploadMediaErrorState(error.toString()));
    }
  }

  Position? userPosition;
  String? userCountry;
  String? userLocality;

  Future getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(PostPickUserLocationErrorState('Location permissions are denied'));
      }
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(PostPickUserLocationErrorState('Location services are disabled.'));
      }
      userPosition = await Geolocator.getCurrentPosition();
      if (userPosition?.latitude != null) {
        List<Placemark> placeMark = await placemarkFromCoordinates(
            userPosition!.latitude, userPosition!.longitude);

        userLocality = '${placeMark.first.locality}';
        userCountry = '${placeMark.first.country}';
        print('$userLocality , $userCountry');
        if (userLocality != null && userCountry != null) {
          emit(PostPickUserLocationSuccessState());
        }
      }
    } catch (error) {
      print(error.toString());
      emit(PostPickUserLocationErrorState('Location services are disabled.'));
    }
  }

  Future addPost(PostModel postModel, String postId) async {
    emit(PostAddPostLoadingState());

    try {
      await _postServices.addPostService(postModel, postId);
      emit(PostAddPostSuccessState());
    } catch (error) {
      emit(PostAddPostErrorState(error.toString()));
    }
  }

  PostModel? postModel;
  List<PostModel>? posts = [];
  List<UserInfoModel> blockedUsersList = [];

  getPosts() async {
    emit(PostGetPostsLoadingState());
    try {
      var url = baseURL + kGetPosts;

      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {"userId": kUserModel!.id.toString()}, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        throw HttpException(responseData["message"]);
      } else {
        PostModelMain postModelmain = PostModelMain.fromJson(responseData);

        posts = postModelmain.data;

        // if (postModel.data!.length !=0) {
        //   posts = [];
        //   blockedUsersList = [];
        //   isMakeOffer = [];
        //   pickedMedia = [];
        //   //  uploadedMedia = [];
        //
        //   extensions = [];
        //   quantityList = [];
        //   priceList = [];
        //   allPosts.docs.forEach((element) async {
        //     blockedUsers.docs.forEach((block) {
        //       blockedUsersList.add(UserInfoModel.fromJson(block.data()));
        //       if (block.data()['id'] != element.data()['userId']) {
        //         hiddenUsers.docs.forEach((hidden) {
        //           if (hidden.data()['id'] != element.data()['userId']){
        //             postModel = PostModel.fromJson(element.data());
        //
        //             posts.add(postModel!);
        //             isMakeOffer.add(false);
        //             quantityList.add(int.parse('${postModel?.quantity}'));
        //
        //             if (postModel!.price!.isEmpty) {
        //               priceList.add(0);
        //             } else {
        //               priceList.add(int.parse('${postModel?.price}'));
        //             }
        //           }
        //         });
        //
        //
        //       }
        //     });
        //
        //     emit(PostGetPostsSuccessState());
        //
        //     if (blockedUsers.docs.isEmpty && hiddenUsers.docs.isEmpty) {
        //       print('is empty');
        //       postModel = PostModel.fromJson(element.data());
        //       posts.add(postModel!);
        //       isMakeOffer.add(false);
        //       quantityList.add(int.parse('${postModel?.quantity}'));
        //
        //       if (postModel!.price!.isEmpty) {
        //         priceList.add(0);
        //       } else {
        //         priceList.add(int.parse('${postModel?.price}'));
        //       }
        //       emit(PostGetPostsSuccessState());
        //     }
        //   });
        //   print('posts ${posts.length}');

        emit(PostGetPostsSuccessState());
      }

      // QuerySnapshot<Map<String, dynamic>> allPosts =
      //     await _postServices.getPostsService();
      // QuerySnapshot<Map<String, dynamic>> blockedUsers =
      //     await _postServices.getBlockService(kUid!);
      // QuerySnapshot<Map<String, dynamic>> hiddenUsers =
      //     await _postServices.getHideService(kUid!);

    } catch (error) {
      print(error);
      emit(PostGetPostsErrorState(error.toString()));
    }
  }

  getHide() async {
    try {
      await getPosts();
      QuerySnapshot<Map<String, dynamic>> hiddenUsers =
          await _postServices.getHideService(kUid!);
      if (hiddenUsers.docs.isNotEmpty) {
        hiddenUsers.docs.forEach((element) {
          // posts.forEach((post) {
          //   if (element.data()['id'] == post.userId) {
          //     posts.remove(post);
          //   }
          // });
        });
        emit(PostGetHiddenUsersSuccessState());
      }
    } on FirebaseException catch (error) {
      emit(PostGetHiddenUsersErrorState(error.toString()));
    }
  }

  List<CategoryModel> categories = [];

  getCategory() async {
    if (categories.isEmpty) {

      var url = baseURL + kCategories;

      try {
        String username = 'kamleshRahul';
        String password = 'paramSoft@123';

        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));
        final response = await http.get(Uri.parse(url), headers: {
          'authorization': basicAuth,
          'Accept': 'application/json',
          "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
          "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
        });
        final responseData = json.decode(response.body);

        if (responseData["status"] == false) {
          throw HttpException(responseData["message"]);
        } else {
          CategoryModelMain categoryModelMain = CategoryModelMain.fromJson(json.decode(response.body));

          categoryModelMain.data!.forEach((element) {
            categories.add(element);
          });

          debugPrint(categories.length.toString());

          emit(PostGeCategoriesSuccessState());
        }
      } catch (error) {
        emit(PostGeCategoriesErrorState(error.toString()));
      }

      // await FirebaseFirestore.instance
      //     .collection('category')
      //     .get()
      //     .then((value) {
      //   value.docs.forEach((element) {
      //     categories.add(CategoryData.fromJson(element.data()));
      //   });
      //   emit(UserGetCategoriesSuccessState());
      // }).catchError((error) {
      //   emit(UserGetCategoriesErrorState(error.toString()));
      // });
    }
    // await FirebaseFirestore.instance.collection('category').get().then((value) {
    //   value.docs.forEach((element) {
    //     categories.add(CategoryModel.fromJson(element.data()));
    //   });
    //   emit(PostGeCategoriesSuccessState());
    // }).catchError((error) {
    //   emit(PostGeCategoriesErrorState(error.toString()));
    // });
  }

  bool isLast = false;

  isLastMedia() {
    isLast = true;
    emit(PostIsLastMediaState());
  }

  int currentMedia = 0;
  sliderIndex(value) {
    currentMedia = value;
    emit(PostCurrentMediaChangedState());
  }

  List<bool> isMakeOffer = [];

  makeOfferPressed(index) {
    // if (isMakeOffer.length < posts.length) {
    //   isMakeOffer.add(false);
    // }
    isMakeOffer[index] = true;
    emit(PostMakeOfferState());
  }

  List<int> quantityList = [];

  increaseQuantity(index) {
    quantityList[index]++;
    emit(PostQuantityIncrementState());
  }

  decrementQuantity(index) {
    if (quantityList[index] != 0) {
      quantityList[index]--;
      emit(PostQuantityDecrementState());
    }
  }

  List<int> priceList = [];

  increasePrice(index) {
    priceList[index]++;
    emit(PostPriceIncrementState());
  }

  decrementPrice(index) {
    if (priceList[index] != 0) {
      priceList[index]--;
      emit(PostPriceDecrementState());
    }
  }

  bool isOfferAdded = false;

  addOffer({required OfferModel offerModel}) async {
    emit(PostAddOfferLoadingState());
    try {
      await _postServices.addOfferService(
          postUserId: offerModel.postUserId!,
          postId: offerModel.postId!,
          map: offerModel.toMap());
      isOfferAdded = true;
      emit(PostAddOfferSuccessState());
    } catch (error) {
      emit(PostAddOfferErrorState(error.toString()));
    }
  }

  int pageIndex = 0;

  changePageIndex(int index) {
    pageIndex = index;
    emit(PostChangePageIndexSuccessState());
  }

  // final String cartId = DateTime.now().microsecondsSinceEpoch.toString();

  addToCart({
    required String postUserId,
    required String postId,
    required String content,
    required String price,
    required Timestamp date,
    required String maxQuantity,
    required String quantity,
    required List<String> media,
    required List<String> extensions,
  }) async {
    CartModel cartModel = CartModel(
        cartId: '$postId' + '$postUserId',
        postUserId: postUserId,
        postId: postId,
        content: content,
        price: price,
        date: date,
        maxQuantity: maxQuantity,
        quantity: quantity,
        media: media,
        extensions: extensions);

    try {
      emit(PostAddToCartLoadingState());
      await UserServices().addToCartService(
          '$kUid', '$postId' + '$postUserId', cartModel.toMap());
      emit(PostAddToCartSuccessState());
    } catch (error) {
      emit(PostAddToCartErrorState(error.toString()));
    }
  }

  hideUser({required UserModel userHider, required UserModel userHiden}) async {
    try {
      await UserServices()
          .hideUserService(userHider: userHider, userHiden: userHiden);
      await getPosts();
      emit(PostHideUserSuccessState());
    } on FirebaseException catch (error) {
      emit(PostHideUserErrorState(error.message.toString()));
    }
  }
}
