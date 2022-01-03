import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/cart_model.dart';
import 'package:sellout_team/src/models/category_model.dart';
import 'package:sellout_team/src/models/getProfileModel.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/supporterModel.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:sellout_team/src/services/post_services/post_services.dart';
import 'package:sellout_team/src/services/storage_services/storage_services.dart';
import 'package:sellout_team/src/services/user_services/user_services.dart';
import 'package:http/http.dart' as http;

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  UserServices _userServices = UserServices();
  List<Post>? userPosts = [];
  List<Post>? userPostsCategories = [];
  int userSupportings = 0;
  int userSupporters = 0;
  // get single user data.

  UserModel? userModel;
  UserInfoModel? userInfoModel;

  Future getUserData() async {
    var url = baseURL + kGetUserProfile;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "userID": kUid
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        throw HttpException(responseData["message"]);
      } else {
        userInfoModel = UserInfoModel.fromJson(json.decode(response.body));

        GetProfileModel getProfileModel =
            GetProfileModel.fromJson(responseData);

        userPosts = getProfileModel.post;

        userPostsCategories = getProfileModel.post;

        userSupportings = getProfileModel.supporting!;
        userSupporters = getProfileModel.supporter!;

        kUserMap = {
          'id': userInfoModel!.data!.id,
          'email': userInfoModel!.data!.email,
          'image': userInfoModel!.data!.userimg,
          'name': userInfoModel!.data!.name,
        };
        String userEncode = json.encode(kUserMap);

        await CacheHelper.setString(key: 'user', value: userEncode);
        await CacheHelper.setString(
            key: 'fullUserData', value: responseData.toString());
        await getCategories();

        emit(UserGetCategoriesSuccessState());
      }
    } catch (error) {
      emit(UserGetCategoriesErrorState(error.toString()));
    }

    // await FirestoreServices()
    //     .getCurrentUserDataService(kUid!)
    //     .then((value) async {
    //   try {
    //     userModel = UserModel.fromFirebase(value.data());
    //     Map<String, dynamic> userMap = {
    //       'id': userModel?.id,
    //       'email': userModel?.email,
    //       'image': userModel?.image,
    //       'name': userModel?.name,
    //     };
    //     CacheHelper.setString(key: 'user', value: json.encode(userMap));
    //     print('current user id ${userModel?.id}');
    //     DocumentSnapshot<Map<String, dynamic>> data =
    //         await UserServices().getUserInfoService(kUid!);
    //     userInfoModel = UserInfoModel.fromJson(data.data());
    //     await getCategories();
    //     emit(UserGetCurrentUserSuccessState());
    //   } catch (error) {
    //     emit(UserGetCurrentUserErrorState(error.toString()));
    //   }
    // }).catchError((error) {
    //   emit(UserGetCurrentUserErrorState(error.toString()));
    // });
  }

  File? photo;

  changeProfilePhoto() async {
    ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        photo = File(image.path);
        print('${photo!.path}');
        emit(UserChangeUserPhotoSuccessState());
      }
    } catch (error) {
      emit(UserChangeUserPhotoErrorState(error.toString()));
    }
  }

  bool isPublic = true;

  onPrivacyChanged(bool value) {
    isPublic = value;
    emit(UserprivacyChangedState());
  }

  String? photoUrl;

  updateUserInfo({
    required String name,
    required String userName,
    required String bio,
    required String category,
    required String phone,
  }) async {
    emit(UserUpdateUserInfoLoadingState());

    try {
      var url = baseURL + kUpdateProfile;

      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      try {
        http.MultipartRequest request =
            new http.MultipartRequest('POST', Uri.parse(url));

        request.fields['biography'] = bio;
        request.fields['phone'] = phone;
        request.fields['name'] = name;
        request.fields['username'] = userName;
        request.fields['userID'] = kUid!;

        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));

        Map<String, String> headers = {
          'authorization': basicAuth,
          'Accept': 'application/json',
          "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
          "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
        };

        request.headers.addAll(headers);

        if (photo != null) {
          var multipartFile = await http.MultipartFile.fromPath(
            'image',
            photo!.path,
            filename: photo!.path.split('/').last,
          );

          request.files.add(multipartFile);
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          emit(UserAddUserInfoSuccessState());
        } else {}
      } catch (error) {
        emit(UserAddUserInfoErrorState(error.toString()));
      }
    } catch (error) {
      print('$error');
      emit(UserAddUserInfoErrorState(error.toString()));
    }
  }

// get posts for current user

  getPostsForCurrentUser(String id) async {
    emit(UserGetPostsForCurrentUserLoadingState());

    try {
      var url = baseURL + kGetUserProfile;

      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "userID": kUid
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        throw HttpException(responseData["message"]);
      } else {
        GetProfileModel getProfileModel =
            GetProfileModel.fromJson(responseData);

        userPosts = getProfileModel.post;

        userSupportings = getProfileModel.supporting!;
        userSupporters = getProfileModel.supporter!;

        emit(UserGetPostsForCurrentUserSuccessState());
      }
    } catch (error) {
      print(error);
      emit(UserGetPostsForCurrentUserErrorState(error.toString()));
    }

    // try {
    //   userPosts = [];
    //   selectedCategory = '';
    //   QuerySnapshot<Map<String, dynamic>> posts =
    //       await _userServices.getPostsForCurrentUserService(id);
    //
    //   posts.docs.forEach((element) {
    //     userPosts.add(PostModel.fromJson(element.data()));
    //   });
    //   emit(UserGetPostsForCurrentUserSuccessState());
    // } on FirebaseException catch (error) {
    //   print('${error.message}');
    //   emit(UserGetPostsForCurrentUserErrorState(error.message.toString()));
    // }
  }

  List<Post> postsByCategory = [];

  getPostsByCategory(String userId) async {
    emit(UserGetPostsByCategoryLoadingState());
    postsByCategory = [];
    try {
      userPostsCategories!.forEach((element) {
        if (element.categoryId == catID) {
          postsByCategory.add(element);
        }
      });
      // QuerySnapshot<Map<String, dynamic>> data = await _userServices
      //     .getPostsByCategoryService(userId, selectedCategory);
      // if (data.docs.isNotEmpty) {
      //   data.docs.forEach((element) {
      //     postsByCategory.add(PostModel.fromJson(element.data()));
      //   });
      //   emit(UserGetPostsByCategorySuccessState());
      // }
    } catch (error) {
      emit(UserGetPostsByCategoryErrorState(error.toString()));
    }
  }

  PostModel? postById;

  Future getPostById(String postId) async {
    emit(UserGetPostByIdLoadingState());
    try {
      DocumentSnapshot<Map<String, dynamic>> post =
          await _userServices.getPostByIdService(postId);

      if (post.exists) {
        // postById = PostModel.fromJson(post.data());
        postByIdQuantity = int.parse(postById!.quantity!);
        postByIdPrice = int.parse(postById!.price!);
        emit(UserGetPostByIdSuccessState());
      }
    } on FirebaseException catch (error) {
      emit(UserGetPostByIdErrorState(error.message.toString()));
    }
  }

  int tabIndex = 0;

  onIndexChange(int value) {
    tabIndex = value;
    emit(UserTabBarIndexChanged());
  }

  int pageIndex = 0;

  changePageIndex(int index) {
    pageIndex = index;
    emit(UserChangePageIndexSuccessState());
  }

  List<CategoryModel> categories = [];

  getCategories() async {
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
          CategoryModelMain categoryModelMain =
              CategoryModelMain.fromJson(json.decode(response.body));

          categoryModelMain.data!.forEach((element) {
            categories.add(element);
          });

          emit(UserGetCategoriesSuccessState());
        }
      } catch (error) {
        emit(UserGetCategoriesErrorState(error.toString()));
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
  }

  UserInfoModel? otherUserModel;

  Future getOtherUserData(String userId) async {
    var url = baseURL + kGetUserProfile;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "userID": userId
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        throw HttpException(responseData["message"]);
      } else {
        otherUserModel = UserInfoModel.fromJson(json.decode(response.body));
        //
        // GetProfileModel getProfileModel = GetProfileModel.fromJson(responseData);
        //
        // userPosts = getProfileModel.post;
        //
        // userPostsCategories = getProfileModel.post;
        //
        // kUserMap = {
        //   'id': otherUserModel!.data!.id,
        //   'email': otherUserModel!.data!.email,
        //   'image': otherUserModel!.data!.userimg,
        //   'name': otherUserModel!.data!.name,
        // };
        // String userEncode = json.encode(kUserMap);
        //
        // await CacheHelper.setString(key: 'user', value: userEncode);
        // await CacheHelper.setString(key: 'fullUserData', value: responseData.toString());
        // await getCategories();

        emit(UserGetCategoriesSuccessState());
      }
    } catch (error) {
      emit(UserGetCategoriesErrorState(error.toString()));
    }
    // try {
    //   DocumentSnapshot<Map<String, dynamic>> data =
    //       await _userServices.getUserInfoService(userId);
    //   otherUserModel = UserInfoModel.fromJson(data.data());
    //   emit(UserGetOtherUserDataSuccessState());
    // } catch (error) {
    //   emit(UserGetOtherUserDataErrorState(error.toString()));
    // }
  }

  String selectedCategory = '';
  String catID = '';

  onCategorySelected(String value, String id) {
    selectedCategory = value;
    catID = id;
    emit(UserCategorySelectedState());
  }

  signOut() async {
    try {
      emit(UserSignOutLoadingState());
      cartList = [];
      postsByCategory = [];
      userPosts = [];
      supportersList = [];
      supportingsList = [];
      CacheHelper.signOut();
      CacheHelper.deleteModel();
      await FirebaseAuth.instance.signOut();
      emit(UserSignOutSuccessState());
    } on FirebaseAuthException catch (error) {
      emit(UserSignOutErrorState(error.message.toString()));
    }
  }

  CartModel? cartModel;
  List<CartModel> cartList = [];

  getCart() async {
    emit(UserGetCartLoadingState());
    cartList = [];
    cartQuantity = [];
    try {
      QuerySnapshot<Map<String, dynamic>> data =
          await _userServices.getCartService('${userModel?.id}');
      if (data.docs.isNotEmpty) {
        data.docs.forEach((element) {
          cartModel = CartModel.fromJson(element.data());
          cartList.add(cartModel!);
          cartQuantity.add(int.parse(cartModel!.quantity!));
        });
        emit(UserGetCartSuccessState());
      }
      // print('No Data');
      // emit(UserGetCartErrorState('No data'));
    } on FirebaseException catch (error) {
      emit(UserGetCartErrorState(error.message.toString()));
    }
  }

  deleteCartProduct(String cartId) async {
    try {
      emit(UserDeleteCartItemLoadingState());
      await _userServices.deleteCartItemService('${userModel?.id}', cartId);
      await getCart();
      emit(UserDeleteCartItemSuccessState());
    } on FirebaseException catch (error) {
      emit(UserDeleteCartItemErrorState(error.message.toString()));
    }
  }

  updateCart(CartModel cartModel) async {
    try {
      emit(UserUpdateCartItemLoadingState());
      await _userServices.updateCartService('${userModel?.id}', cartModel);
      await getCart();
      emit(UserUpdateCartItemSuccessState());
    } on FirebaseException catch (error) {
      emit(UserUpdateCartItemErrorState(error.message.toString()));
    }
  }

  List<int> cartQuantity = [];

  increment(int maxQuantity, int index) {
    if (maxQuantity > cartQuantity[index]) {
      cartQuantity[index]++;
      emit(UserCartQuantityIncrementSuccessState());
    }
  }

  decrement(int maxQuantity, int index) {
    if (cartQuantity[index] <= maxQuantity && cartQuantity[index] > 1) {
      cartQuantity[index]--;
      emit(UserCartQuantitydecrementSuccessState());
    }
  }

  int postByIdQuantity = 0;

  quantityIncrement() {
    // if (maxQuantity > postByIdQuantity) {
    postByIdQuantity++;
    emit(UserPostByIdQuantityIncrementSuccessState());
    // }
  }

  quantityDecrement() {
    //  if (postByIdQuantity <= maxQuantity && postByIdQuantity > 1) {
    postByIdQuantity--;
    emit(UserPostByIdQuantityDecrementSuccessState());
  }

  int postByIdPrice = 0;

  priceIncrement() {
    // if (maxPrice > postByIdPrice) {
    postByIdPrice++;
    emit(UserPostByIdPriceIncrementSuccessState());
    //  }
  }

  priceDecrement() {
    //  if (postByIdPrice <= maxPrice && postByIdPrice > 1) {
    postByIdPrice--;
    emit(UserPostByIdPriceDecrementSuccessState());
    //  }
  }

  bool isOfferPressed = false;

  isOffer() {
    isOfferPressed = true;
    emit(UserOfferPressedState());
  }

  addSupport({
    required UserInfoModel otherUserModel,
  }) async {
    try {
      emit(UserAddSupportLoadingState());
      // await _userServices.addSupport(
      //     otherUserModel: otherUserModel,
      //     currentUserId: '${userModel?.id}',
      //     currentUserModel: userInfoModel!);

      try {
        var url = baseURL + kAddSupport;

        String username = 'kamleshRahul';
        String password = 'paramSoft@123';

        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));
        final response = await http.post(Uri.parse(url), body: {
          "UserId": kUserModel!.id.toString(),
          "SupportUserid": otherUserModel.data!.id.toString()
        }, headers: {
          'authorization': basicAuth,
          'Accept': 'application/json',
          "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
          "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
        });
        final responseData = json.decode(response.body);

        debugPrint(responseData.toString());

        if (responseData["status"] == false) {
          emit(UserAddSupportErrorState(responseData["message"]));
          throw HttpException(responseData["message"]);
        } else {
          emit(UserAddSupportSuccessState());
        }
      } catch (error) {
        print(error);
      }
    } catch (error) {
      emit(UserAddSupportErrorState(error.toString()));
    }
  }

  List<SupportUserData> supportingsList = [];
  List<SupportUserData> supportersList = [];

  getSupports(String id) async {
    emit(UserGetSupportLoadingState());
    supportingsList = [];
    supportersList = [];
    userSupportings = 0;
    userSupporters = 0;
    try {
      try {
        var url = baseURL + kGetSupporting;
        var url2 = baseURL + kGetSupporters;

        String username = 'kamleshRahul';
        String password = 'paramSoft@123';

        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));

        final response = await http.post(Uri.parse(url), body: {
          "UserId": id,
        }, headers: {
          'authorization': basicAuth,
          'Accept': 'application/json',
          "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
          "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
        });
        final responseData = json.decode(response.body);

        if (responseData["status"] == false) {
          emit(UserGetSupportErrorState(responseData["message"]));
          throw HttpException(responseData["message"]);
        } else {
          emit(UserGetSupportSuccessState());
          SupporterModel supporterModel =
              new SupporterModel.fromJson(responseData);
          supportingsList = supporterModel.data!;
        }

        final response2 = await http.post(Uri.parse(url2), body: {
          "UserId": id,
        }, headers: {
          'authorization': basicAuth,
          'Accept': 'application/json',
          "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
          "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
        });
        final responseData2 = json.decode(response2.body);

        if (responseData2["status"] == false) {
          emit(UserGetSupportErrorState(responseData2["message"]));
          throw HttpException(responseData2["message"]);
        } else {
          emit(UserGetSupportSuccessState());
          SupporterModel supporterModel =
              new SupporterModel.fromJson(responseData2);
          supportersList = supporterModel.data!;
        }
      } catch (error) {
        print(error);
      }
      // QuerySnapshot<Map<String, dynamic>> supporting =
      //     await _userServices.getSupportingService(id);
      //
      // supporting.docs.forEach((element) {
      //   supportingsList.add(UserInfoModel.fromJson(element.data()));
      //   userSupportings = supporting.docs.length;
      // });
      //
      // QuerySnapshot<Map<String, dynamic>> supporters =
      //     await _userServices.getSupportersService(id);
      // supporters.docs.forEach((element) {
      //   supportersList.add(UserInfoModel.fromJson(element.data()));
      //   userSupporters = supporters.docs.length;
      //   if (element.data()['id'] == userModel?.id) {
      //     isUserSupport = true;
      //   }
      // });

    } on FirebaseException catch (error) {
      emit(UserGetSupportErrorState(error.message.toString()));
    }
  }

  bool isUserSupport = false;

  deleteSupport(String otherUserId) async {
    emit(UserDeleteSupportLoadingState());
    try {
      await _userServices.deleteSupport(otherUserId, '${userModel?.id}');
      await getSupports(otherUserId);
      isUserSupport = false;
      emit(UserDeleteSupportSuccessState());
    } on FirebaseException catch (error) {
      emit(UserDeleteSupportErrorState(error.message.toString()));
    }
  }

  sendReport(UserInfoModel userInfoModel) async {
    try {
      await _userServices.sendReportService(userInfoModel);
      emit(UserSendReportSuccessState());
    } on FirebaseException catch (error) {
      emit(UserSendReportErrorState(error.message.toString()));
    }
  }

  bool isBlockSuccess = false;

  blockUser(
      {required UserModel userBlocker, required UserModel userBlocked}) async {
    try {
      isBlockSuccess = false;
      await _userServices
          .blockUser(userBlocker: userBlocker, userBlocked: userBlocked)
          .then((value) {
        isBlockSuccess = true;
        emit(UserBlockUserSuccessState());
      });
    } on FirebaseException catch (error) {
      emit(UserBlockUserErrorState(error.message.toString()));
    }
  }
}
