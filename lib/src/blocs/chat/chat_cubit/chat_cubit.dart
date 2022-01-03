import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/group_chat_model.dart';
import 'package:sellout_team/src/models/last_group_chat_message_model.dart';
import 'package:sellout_team/src/models/last_message_model.dart';
import 'package:sellout_team/src/models/message_model.dart';
import 'package:sellout_team/src/models/stories_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:sellout_team/src/services/post_services/post_services.dart';
import 'package:sellout_team/src/services/storage_services/storage_services.dart';
import 'package:sellout_team/src/services/user_services/user_services.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  FirestoreServices _firestoreServices = FirestoreServices();
  StorageServices _storageServices = StorageServices();

  int tabIndex = 0;

  // when user taps on the different tab bars we have in the main chat screen.

  onIndexChange(int value) {
    tabIndex = value;
    emit(ChatTabBarIndexChanged());
  }

  List<LastMessagesModel> searchList = [];
  List<LastGroupChatMessage> groupSearchList = [];

// deleting the search lists so it won't be duplicated.
  emptyList() {
    searchList = [];
    groupSearchList = [];
    emit(ChatSearchValueDeleteState());
  }

  // the search method (single chats and group chats) by the name of the chat.

  searchChats(String value) async {
    await _firestoreServices
        .chatsSearchService('${kUserModel?.id}', value)
        .then((event) {
      if (event.docs.isNotEmpty) {
        searchList = [];
        event.docs.forEach((element) {
          searchList.add(LastMessagesModel.fromJson(element.data()));
        });
        emit(ChatGetSearchSuccessState());
      }
    }).catchError((error) {
      print(error);
    });
    await _firestoreServices
        .groupSearchService('${kUserModel?.id}', value)
        .then((value) {
      if (value.docs.isNotEmpty) {
        groupSearchList = [];
        value.docs.forEach((element) {
          groupSearchList.add(LastGroupChatMessage.fromJson(element.data()));
        });
        emit(ChatGetSearchSuccessState());
      }
    }).catchError((error) {
      print(error);
    });
  }

  // get all the users to add to group chat.

  List<UserModel> users = [];

  getAllUsers() async {
    users = [];
    await _firestoreServices.getAllUsersService().then((value) {
      value.docs.forEach((user) {
        if (user.id != kUid) {
          users.add(UserModel.fromFirebase(user.data()));
        }
        emit(ChatGetUsersSuccessState());
      });
    }).catchError((error) {
      emit(ChatGetUsersErrorState(error.toString()));
    });
  }

  // delete the chat for only one user (the current user).

  deleteChatForCurrentUser(String userId, String otherUserId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(otherUserId)
        .collection('messages')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
        await _firestoreServices
            .deleteChatService(userId, otherUserId)
            .then((value) {
          emit(ChatDeleteChatSuccessState());
        }).catchError((error) {
          emit(ChatDeleteChatErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(ChatDeleteChatErrorState(error.toString()));
    });
  }

  // sending messages and store the last messages to be displayed in the main chat screen.

  sendMessage(
      {required MessageModel? messageModel,
      required UserModel? recieverModel}) async {
    emit(ChatSendMessageLoadingState());

    LastMessagesModel model = LastMessagesModel(
        userId: recieverModel?.id,
        userName: recieverModel?.name,
        userEmail: recieverModel?.email,
        userImage: recieverModel?.image,
        lastMessageContent: messageModel?.messageContent,
        lastMessageDate: messageModel?.date);

    await _firestoreServices
        .storeMessageForCurrentUser(
            receiverId: '${messageModel?.receiverId}',
            messageModel: messageModel?.toMap())
        .then((value) async {
      await _firestoreServices
          .storeMessageForReceiverUser(
              receiverId: '${recieverModel?.id}',
              messageModel: messageModel?.toMap())
          .then((value) async {
        await _firestoreServices
            .storeLastMessageForCurrentUserService(
                userId: kUserModel?.id,
                recieverId: recieverModel?.id,
                lastMessageModel: model.toMap())
            .then((value) async {
          LastMessagesModel lastMessageModel = LastMessagesModel(
              userId: kUserModel?.id,
              userName: kUserModel?.name,
              userEmail: kUserModel?.email,
              userImage: kUserModel?.image,
              lastMessageContent: messageModel?.messageContent,
              lastMessageDate: messageModel?.date);
          await _firestoreServices
              .storeLastMessageForReciever(
                  recieverId: recieverModel?.id,
                  userId: kUserModel?.id,
                  lastMessageModel: lastMessageModel.toMap())
              .then((value) {
            emit(ChatSendMessageSuccessState());
          }).catchError((error) {
            emit(ChatSendMessageErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(ChatSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(ChatSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(ChatSendMessageErrorState(error.toString()));
    });
  }

  File? pickedVideo;
  String? videoUrl;
  File? pickedFile;
  String? fileUrl;
  bool isLoading = false;

  // pick documents and upload them to the storage then send them in a message to a single user or in a group chat.

  pickADoc(
      {UserModel? recieverModel,
      bool isGroup = false,
      String? groupId,
      String? groupName,
      List<String>? usersId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx', 'doc']);

      print('${result?.files.single.extension}');
      if (result != null) {
        String? path = result.files.single.path;
        pickedFile = File(path!);
        try {
          String? url = await _storageServices.uploadDocs(doc: pickedFile!);
          fileUrl = url;
          isLoading = true;

          if (isGroup) {
            GroupChatMessageModel groupModel = groupModelReuse(
                message: fileUrl!, geoPoint: GeoPoint(0.0, 0.0), isDoc: true);
            await sendMessageToGroupChat(
                groupId!, groupName!, usersId!, groupModel);
          } else {
            MessageModel messageModel = messageImageModel(
                isDoc: true, recieverModel: recieverModel!, url: fileUrl);
            await sendMessage(
                messageModel: messageModel, recieverModel: recieverModel);
          }

          isLoading = false;
          emit(ChatPickAdocSuccessState());
        } catch (error) {
          emit(ChatPickAdocErrorState(error.toString()));
        }
      } else {
        emit(ChatPickAdocErrorState('Pick a File'));
      }
    } catch (error) {
      emit(ChatPickAdocErrorState(error.toString()));
    }
  }

  // pick a single video and upload it to the storage then send it in a message to the single user or in a group chat.

  pickAVideo(
      {UserModel? recieverModel,
      bool isGroup = false,
      String? groupId,
      String? groupName,
      List<String>? usersId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.video);

      if (result != null) {
        String? path = result.files.single.path;

        pickedVideo = File(path!);
        try {
          String? url = await _storageServices.uploadVideo(video: pickedVideo!);
          videoUrl = url;
          isLoading = true;

          if (isGroup) {
            GroupChatMessageModel groupModel = groupModelReuse(
                message: videoUrl!,
                geoPoint: GeoPoint(0.0, 0.0),
                isVideo: true);

            await sendMessageToGroupChat(
                groupId!, groupName!, usersId!, groupModel);
          } else {
            MessageModel messageModel = messageImageModel(
                isVideo: true, recieverModel: recieverModel!, url: videoUrl);
            await sendMessage(
                messageModel: messageModel, recieverModel: recieverModel);
          }

          isLoading = false;
          emit(ChatPickFileSuccessState());
        } catch (error) {
          emit(ChatPickFileErrorState(error.toString()));
        }
      } else {
        emit(ChatPickFileErrorState('Pick a File'));
      }
    } catch (error) {
      emit(ChatPickFileErrorState(error.toString()));
    }
  }

  GroupChatMessageModel groupModelReuse(
      {required String message,
      bool isPhoto = false,
      bool isVideo = false,
      bool isDoc = false,
      required GeoPoint geoPoint}) {
    return GroupChatMessageModel(
        message: message,
        date: Timestamp.now(),
        userId: kUid,
        userName: kUserModel?.name,
        userImage: kUserModel?.image,
        isPhoto: isPhoto,
        isVideo: isVideo,
        isDoc: isDoc,
        geoPoint: geoPoint);
  }

  // pick an image from the gallery or the camera and upload it to the storage then send it to a single user or in a group chat.

  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  String? imageUrl;

  pickAnImage(
      {required ImageSource imageSource,
      UserModel? recieverModel,
      bool isGroup = false,
      String? groupId,
      String? groupName,
      List<String>? usersId}) async {
    try {
      final XFile? image = await _picker.pickImage(source: imageSource);
      if (image != null) {
        pickedImage = File(image.path);
        print('${pickedImage!.path}');
        try {
          String? url =
              await _storageServices.uploadImages(image: pickedImage!);
          if (url != null) {
            imageUrl = url;
            isLoading = true;
            print('image urllllllllll $imageUrl');

            if (isGroup) {
              GroupChatMessageModel groupModel = groupModelReuse(
                  message: imageUrl!,
                  geoPoint: GeoPoint(0.0, 0.0),
                  isPhoto: true);

              await sendMessageToGroupChat(
                  '$groupId', '$groupName', usersId!, groupModel);
            } else {
              MessageModel messageModel = messageImageModel(
                  isPhoto: true, recieverModel: recieverModel!, url: imageUrl);
              await sendMessage(
                  messageModel: messageModel, recieverModel: recieverModel);
            }

            isLoading = false;
            emit(ChatPickImageSuccessState());
          } else {
            print('Something went wrong');
            emit(ChatPickImageErrorState('Something went wrong'));
          }
        } catch (error) {
          print(error.toString());
          emit(ChatPickImageErrorState(error.toString()));
        }
      } else {
        emit(ChatPickImageErrorState('No Image was picked'));
      }
    } catch (error) {
      emit(ChatPickImageErrorState(error.toString()));
    }
  }

  MessageModel messageImageModel(
      {required String? url,
      bool isPhoto = false,
      bool isVideo = false,
      bool isDoc = false,
      required UserModel recieverModel}) {
    return MessageModel(
        isVideo: isVideo,
        isDoc: isDoc,
        userId: kUserModel?.id,
        receiverId: recieverModel.id,
        receiverName: recieverModel.name,
        geoPoint: GeoPoint(0, 0),
        receiverImage: recieverModel.image,
        messageContent: url,
        isPhoto: isPhoto,
        date: Timestamp.now());
  }

  // get the user current location.

  Position? userPosition;

  Future<Position?> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(ChatPickUserLocationErrorState('Location permissions are denied'));
      }
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(ChatPickUserLocationErrorState('Location services are disabled.'));
      }
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      print(error.toString());
      emit(ChatPickUserLocationErrorState('Location services are disabled.'));
    }
  }

  // send the user location we got to a single user or in a group chat.

  sendUserLocation(
      {UserModel? recieverModel,
      bool isGroup = false,
      String? groupId,
      String? groupName,
      List<String>? usersId}) async {
    try {
      await getUserLocation().then((value) async {
        if (value != null) {
          if (isGroup) {
            GroupChatMessageModel groupModel = groupModelReuse(
                message: '',
                geoPoint: GeoPoint(value.latitude, value.longitude));
            await sendMessageToGroupChat(
                groupId!, groupName!, usersId!, groupModel);
          } else {
            MessageModel messageModel = MessageModel(
                isDoc: false,
                isVideo: false,
                userId: kUserModel?.id,
                receiverId: recieverModel?.id,
                receiverName: recieverModel?.name,
                receiverImage: recieverModel?.image,
                messageContent: '',
                isPhoto: false,
                geoPoint: GeoPoint(value.latitude, value.longitude),
                date: Timestamp.now());
            await sendMessage(
                messageModel: messageModel, recieverModel: recieverModel);
          }

          emit(ChatSendUserLocationSuccessState());
        } else {
          print('No position');
          emit(ChatSendUserLocationErrorState('No position'));
        }
      });
    } catch (error) {
      print(error.toString());
      emit(ChatSendUserLocationErrorState(error.toString()));
    }
  }

  // add stories(images and videos).

  List<File> pickedStories = [];
  List<String> storiesUrls = [];
  List<String> extensions = [];

  addStories() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
          allowMultiple: true);

      result?.files.forEach((element) {
        File stories = File(element.path!);
        pickedStories.add(stories);
      });
      result?.files.forEach((element) {
        extensions.add(element.extension!);
      });
      if (pickedStories.isNotEmpty) {
        final String today = ('${DateTime.now().month}-${DateTime.now().day}');
        final DateTime dateNow = DateTime.now();
        try {
          pickedStories.forEach((story) async {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref()
                .child('stories')
                .child(today)
                .child('${dateNow.toString()}')
                .putFile(story);

            TaskSnapshot taskSnapshot =
                await uploadTask.whenComplete(() {}).catchError((error) {
              emit(ChatPickStoriesErrorState(error.toString()));
            });
            await taskSnapshot.ref.getDownloadURL().then((url) async {
              storiesUrls.add(url);

              print('${storiesUrls.length}');

              StoriesModel storiesModel = StoriesModel(
                  userId: kUserModel?.id,
                  userName: kUserModel?.name,
                  userImage: kUserModel?.image,
                  stories: storiesUrls,
                  date: Timestamp.now(),
                  extensions: extensions);

              if (storiesUrls.length == extensions.length) {
                await _firestoreServices.addStoriesService(
                    userId: kUserModel?.id, storiesMap: storiesModel.toMap());
                await getStories();
                emit(ChatPickStoriesSuccessState());
              }
            }).catchError((error) {
              emit(ChatPickStoriesErrorState(error.toString()));
            });
          });
        } catch (error) {
          emit(ChatPickStoriesErrorState(error.toString()));
        }
      } else {
        emit(ChatPickStoriesErrorState('No stories was picked'));
      }
    } catch (error) {
      emit(ChatPickStoriesErrorState(error.toString()));
    }
  }

  List<StoriesModel>? stories = [];

  getStories() async {
    if (stories!.isNotEmpty) {
      print('already there');
    }
    emit(ChatGetStoriesLoadingState());

    await _firestoreServices.getAllUsersService().then((value) async {
      stories = [];
      value.docs.forEach((element) async {
        await _firestoreServices.getStoriesService(element.id).then((value) {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((story) {
              stories?.add(StoriesModel.fromJson(story.data()));
            });
            print('${stories?.length}');
            stories?.forEach((element) {
              print('stories length ${element.stories.length}');
              print('extensions length ${element.extensions.length}');
            });
            emit(ChatGetStoriesSuccessState());
          }
        }).catchError((error) {
          emit(ChatGetStoriesErrorState(error.toString()));
        });
      });
    });
  }

  // add group chat and store the users in the group to be displayed in the main chat screen.

  Future addGroupChat(
      String id, String name, List<UserModel> usersModel) async {
    emit(ChatAddGroupChatLoadingState());
    try {
      await _firestoreServices
          .addGroupChatService(id, name)
          .then((value) async {
        usersModel.forEach((element) async {
          await _firestoreServices.addGroupUsersService(
              id, '${element.id}', element.toMap());
        });
        emit(ChatAddGroupChatSuccessState());
      });
    } catch (error) {
      emit(ChatAddGroupChatErrorState(error.toString()));
    }
  }

  // send messages in a group chat and store the last messages to be displayed in the main chat screen.

  sendMessageToGroupChat(String id, String name, List<String> usersId,
      GroupChatMessageModel groupModel) async {
    try {
      await _firestoreServices.sendMessageToGroupService(
          id, groupModel.toMap());

      LastGroupChatMessage model = LastGroupChatMessage(
          lastUserId: groupModel.userId,
          id: id,
          name: name,
          date: groupModel.date,
          lastMessage: groupModel.message,
          usersId: usersId);

      await _firestoreServices.sendLastGroupMessageService(id, model.toMap());
      emit(ChatSendMessageToGroupChatSuccessState());
    } catch (error) {
      emit(ChatSendMessageToGroupChatErrorState(error.toString()));
    }
  }

  bool isUserBlocked = false;

  isBlocked(String otherUserId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> block =
          await PostServices().getBlockService(kUid!);
      if (block.docs.isNotEmpty) {
        block.docs.forEach((element) {
          if (otherUserId == element.data()['id']) {
            isUserBlocked = true;
            print(isUserBlocked);
          }
        });

        emit(ChatIsUserBlockedState());
      }
      QuerySnapshot<Map<String, dynamic>> blocked =
          await PostServices().getBlockService(otherUserId);
      if (blocked.docs.isNotEmpty) {
        blocked.docs.forEach((element) {
          if (kUid == element.data()['id']) {
            isUserBlocked = true;
            print(isUserBlocked);
          }
        });
        emit(ChatIsUserBlockedState());
      }
    } on FirebaseException catch (error) {
      print(error.message.toString());
    }
  }
}
