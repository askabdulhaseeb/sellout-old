import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:sellout_team/src/services/user_services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:sellout_team/src/views/auth/login_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthIntiailState());
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isObsecure = true;

  onChanged() {
    isObsecure = !isObsecure;
    emit(AuthOnSeenChangedState());
  }

  FirestoreServices _firestoreService = FirestoreServices();

  register(
      {required String name,
      required String username,
      required String phoneNumber,
      required String email,
      required String passwords,
      required String type,
      required String userImg}) async {
    emit(AuthRegisterLoadingState());

    debugPrint(name);
    debugPrint(username);
    debugPrint(phoneNumber);
    debugPrint(email);
    debugPrint(passwords);
    debugPrint(type);
    debugPrint(userImg);

    var url = baseURL + kRgister;

    String fToken = "";

    await FirebaseMessaging.instance.getToken().then((tokenFid) {
      fToken = tokenFid.toString();
    });

    debugPrint(fToken);

    try {
      String username1 = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username1:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "username": username,
        "email": email,
        "password": passwords,
        "name": name,
        "phone": phoneNumber,
        "token": fToken,
        "type": type,
        "url": userImg
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(AuthRegisterErrorState(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        UserInfoModel userInfoModel =
            UserInfoModel.fromJson(json.decode(response.body));

        kUserMap = {
          'id': userInfoModel.data!.id,
          'email': userInfoModel.data!.email,
          'image': userInfoModel.data!.userimg,
          'name': userInfoModel.data!.name,
        };
        String userEncode = json.encode(kUserMap);

        await CacheHelper.setString(key: 'user', value: userEncode);
        await CacheHelper.setString(
            key: 'fullUserData', value: responseData.toString());

        emit(AuthRegisterSuccessState());
        emit(AuthLoginSuccessState(userInfoModel.data!.id.toString()));
      }
    } catch (error) {
      emit(AuthRegisterErrorState(error.toString()));
    }
    // try {
    //   UserCredential registerUser = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(email: email, password: password);
    //
    //   if (registerUser.user != null) {
    //     await registerUser.user!.sendEmailVerification();
    //     emit(AuthRegisterVerificationSentState());
    //
    //     bool? isSaved = await CacheHelper.setStringList(key: 'users', value: [
    //       '${registerUser.user?.uid}',
    //       '$name',
    //       '${registerUser.user?.email}',
    //     ]);
    //
    //     if (isSaved!) {
    //       emit(AuthRegisterSuccessState());
    //     } else {
    //       emit(AuthRegisterErrorState('Something went wrong'));
    //     }
    //   }
    // } on FirebaseAuthException catch (error) {
    //   emit(AuthRegisterErrorState(error.message.toString()));
    // }
  }

  login({required String email, required String passwords}) async {
    emit(AuthLoginLoadingState());

    var url = baseURL + kLogin;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "email": email,
        "password": passwords
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(AuthLoginErrorState(responseData["message"]));
        // throw HttpException(responseData["message"]);
      } else {
        UserInfoModel userInfoModel =
            UserInfoModel.fromJson(json.decode(response.body));
        kUserMap = {
          'id': userInfoModel.data!.id,
          'email': userInfoModel.data!.email,
          'image': userInfoModel.data!.userimg,
          'name': userInfoModel.data!.name,
        };
        String userEncode = json.encode(kUserMap);

        await CacheHelper.setString(key: 'user', value: userEncode);
        await CacheHelper.setString(
            key: 'fullUserData', value: responseData.toString());

        emit(AuthLoginSuccessState(userInfoModel.data!.id.toString()));
      }
    } catch (error) {
      //emit(AuthLoginErrorState(responseData["message"]));

      //throw (error);
    }

    // try {
    //   UserCredential loginUser = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: email, password: password);

    //   if (loginUser.user != null && !loginUser.user!.emailVerified) {
    //     emit(AuthLoginErrorState("Please try to check your email address \n"
    //         "and click on the verification link"));
    //   } else if (loginUser.user != null && loginUser.user!.emailVerified) {
    //     FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(loginUser.user?.uid)
    //         .get()
    //         .then((value) async {
    //       if (value.exists) {
    //         print('user exist');
    //         UserModel user = UserModel.fromFirebase(value.data());
    //         kUserMap = {
    //           'id': user.id,
    //           'email': user.email,
    //           'image': user.image,
    //           'name': user.name,
    //         };
    //         String userEncode = json.encode(kUserMap);
    //         await CacheHelper.setString(key: 'user', value: userEncode);

    //         emit(AuthLoginSuccessState(loginUser.user!.uid.toString()));
    //       } else {
    //         List<String> user = [];
    //         try {
    //           if (CacheHelper.getStringList('users') != null) {
    //             user = CacheHelper.getStringList('users');
    //             UserModel userModel = createUserModel(user[1], user[0], user[2],
    //                 'https://i.pinimg.com/474x/8c/70/8b/8c708b478e0e71f7599b75b9cc108ddf.jpg');
    //             await _firestoreService
    //                 .addUserToFirestore(
    //                     id: '${user.first}', map: userModel.toMap())
    //                 .then((value) async {
    //               String uid = user.first;

    //               try {
    //                 Map<String, dynamic> userMap = {
    //                   'id': userModel.id,
    //                   'email': userModel.email,
    //                   'image': userModel.image,
    //                   'name': userModel.name,
    //                 };
    //                 String userEncode = jsonEncode(userMap);
    //                 await CacheHelper.setString(key: 'user', value: userEncode);

    //                 UserInfoModel userInfoModel = UserInfoModel(
    //                     id: userModel.id,
    //                     name: userModel.name,
    //                     userName: '',
    //                     image: userModel.image,
    //                     email: userModel.email,
    //                     bio: '',
    //                     category: '',
    //                     phone: '',
    //                     isPublic: true);
    //                 await UserServices()
    //                     .addUserInfoService(uid, userInfoModel.toMap());

    //                 emit(AuthLoginSuccessState(uid));
    //               } catch (error) {
    //                 emit(AuthLoginErrorState(error.toString()));
    //               }
    //             }).catchError((error) {
    //               emit(AuthLoginErrorState(error.message.toString()));
    //             });
    //           } else {
    //             emit(AuthLoginErrorState('Please register first!'));
    //           }
    //         } on FirebaseAuthException catch (error) {
    //           emit(AuthLoginErrorState(error.message.toString()));
    //         }
    //       }
    //     });
    //   }
    // } on FirebaseAuthException catch (error) {
    //   emit(AuthLoginErrorState(error.message.toString()));
    // }
  }

  forgotPassword({
    required String email,
  }) async {
    emit(AuthForgotPasswordLoadingState());

    var url = baseURL + kSendOTP;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "email": email,
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(AuthLoginErrorState(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        emit(AuthForgotPasswordSuccessState());
      }
    } catch (error) {
      throw (error);
    }

    // try {
    //   await FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: email)
    //       .then((value) {
    //     emit(AuthForgotPasswordSuccessState());
    //   });
    // } on FirebaseAuthException catch (error) {
    //   emit(AuthForgotPasswordErrorState(error.message.toString()));
    // }
  }

  confirmOTP({required String email, required String OTP}) async {
    emit(AuthForgotPasswordLoadingState());

    var url = baseURL + kCheckOTP;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "email": email,
        "otp": OTP
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(AuthLoginErrorState(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        emit(AuthForgotPasswordOTPSuccessState(
            responseData["message"], responseData["data"]["id"]));
      }
    } catch (error) {
      throw (error);
    }

    // try {
    //   await FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: email)
    //       .then((value) {
    //     emit(AuthForgotPasswordSuccessState());
    //   });
    // } on FirebaseAuthException catch (error) {
    //   emit(AuthForgotPasswordErrorState(error.message.toString()));
    // }
  }

  resetPassword({required String id, required String passwords}) async {
    emit(AuthForgotPasswordLoadingState());

    var url = baseURL + kUpdatePassword;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "userID": id,
        "password": passwords
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(AuthForgotPasswordErrorState(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        emit(AuthForgotPasswordSuccessState());
      }
    } catch (error) {
      throw (error);
    }
  }

  loginWithGoogle() async {
    emit(AuthLoginWithGoogleLoadingState());

    try {
      GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth =
          await googleAccount!.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (userCredential.user != null && googleAccount.email != null) {
        User? user = userCredential.user;
        UserModel userModel = createUserModel(
            user?.displayName, user?.uid, googleAccount.email, user?.photoURL);

        register(
            name: googleAccount.displayName.toString(),
            username: googleAccount.displayName.toString().replaceAll(" ", ""),
            phoneNumber: userCredential.user!.phoneNumber.toString(),
            email: googleAccount.email.toString(),
            passwords: "googleLogin",
            type: "google",
            userImg: googleAccount.photoUrl.toString());

        // await _firestoreService
        //     .addUserToFirestore(id: '${user?.uid}', map: userModel.toMap())
        //     .then((value) async {
        //   kUid = user?.uid;

        //   emit(AuthLoginWithGoogleSuccessState(user!.uid));
        // }).catchError((error) {
        //   emit(AuthLoginWithGoogleErrorState(error.toString()));
        // });
      } else {
        emit(AuthLoginWithGoogleErrorState('Error'));
      }
    } on FirebaseAuthException catch (error) {
      emit(AuthLoginWithGoogleErrorState(error.message.toString()));
    }
  }

  loginWithFacebook() async {
    emit(AuthLoginWithFacebookLoadingState());

    LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      Map<String, dynamic> facebookAccount =
          await FacebookAuth.instance.getUserData();

      String email = facebookAccount['email'];
      String token = result.accessToken!.token;
      String picture = facebookAccount["picture"]["data"]["url"];

      try {
        AuthCredential authCredential = FacebookAuthProvider.credential(token);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        if (userCredential.user != null) {
          User? user = userCredential.user;

          UserModel userModel = createUserModel(
              user?.displayName, user?.uid, email, user?.photoURL);

          register(
              name: userCredential.user!.displayName.toString(),
              username: userCredential.user!.displayName
                  .toString()
                  .replaceAll(" ", ""),
              phoneNumber: userCredential.user!.phoneNumber.toString(),
              email: email,
              passwords: "faccebookLogin",
              type: "facebook",
              userImg: picture);

          // await _firestoreService
          //     .addUserToFirestore(id: '${user?.uid}', map: userModel.toMap())
          //     .then((value) async {
          //   kUid = user?.uid;

          //   emit(AuthLoginWithFacebookSuccessState(user!.uid));
          // }).catchError((error) {
          //   emit(AuthLoginWithFacebookErrorState(error.toString()));
          // });
        }
      } on FirebaseAuthException catch (error) {
        emit(AuthLoginWithFacebookErrorState(error.message.toString()));
      }
    } else if (result.status == LoginStatus.failed) {
      emit(AuthLoginWithFacebookErrorState(result.message.toString()));
    } else if (result.status == LoginStatus.cancelled) {
      emit(AuthLoginWithFacebookErrorState(result.message.toString()));
    }
  }

  loginWithApple() async {
    User? user = await signInWithApple();
    if (user != null) {
      // if (firebaseUser != null) {
      // register(
      //   name: user.displayName.toString(),
      //   username: user.displayName.toString().replaceAll(" ", ""),
      //   phoneNumber: "",
      //   email: user.email.toString(),
      //   passwords: "applelogin",
      // );
    } else {
      emit(AuthLoginErrorState("Something went wrong"));
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    OAuthProvider oAuthProvider = new OAuthProvider("apple.com");

    final AuthCredential authCredential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce);

    try {
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      final firebaseUser = authResult.user;

      await firebaseUser?.updateDisplayName(
          '${appleCredential.givenName} ${appleCredential.familyName}');
      await firebaseUser?.updateEmail('${appleCredential.email}');

      if (firebaseUser != null) {
        debugPrint(firebaseUser.displayName.toString());
        debugPrint(firebaseUser.email.toString());
        register(
            name: firebaseUser.displayName.toString(),
            username: firebaseUser.displayName.toString().replaceAll(" ", ""),
            phoneNumber: "",
            email: firebaseUser.email.toString(),
            passwords: "applelogin",
            type: "apple",
            userImg: "");
      } else {
        emit(AuthLoginErrorState("Something went wrong"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint("account-exists-with-different-credential" + e.toString());
      } else if (e.code == 'invalid-credential') {
        debugPrint("account-exists-with-different-credential" + e.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // Create an `OAuthCredential` from the credential returned by Apple.
    // final oauthCredential = OAuthProvider("apple.com").credential(
    //   idToken: appleCredential.identityToken,
    //   rawNonce: rawNonce,
    // );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.

    // final displayName =
    //     '${appleCredential.givenName} ${appleCredential.familyName}';
    // final userEmail = '${appleCredential.email}';

    //return firebaseUser;
  }

  UserModel createUserModel(name, id, email, image) {
    return UserModel(name: name, id: id, email: email, image: image);
  }
}
