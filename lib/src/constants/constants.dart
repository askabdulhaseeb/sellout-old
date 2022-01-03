import 'package:flutter/material.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/models/user_model.dart';

// Color palette

const kPrimaryColor = Color(0xFFD32F2F);
const kFacebookColor = Color(0xFF4267B2);
const kInstagramColor = Color(0xFFC13584);
const kWeChatColor = Color(0xFF7BB32E);
const kSecondaryColor = Color(0xFF7C4DFF);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kDefaultPadding = 20.0;

String? kUid;

Map<String, dynamic>? kUserMap;

UserModel? kUserModel;
UserInfoModel? kUserInfoModel;

String K_LOGO = 'assets/images/sellout_logo/sellout.png';

//String K_SPLASH_LOGO = 'assets/images/logo.png';

String K_SPLASH = 'assets/images/splash_redesign.png';
String K_PAYPAL = 'assets/images/paypal.png';
String K_STRIPE = 'assets/images/stripe.png';

const List<BottomNavigationBarItem> kNavBarItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
  BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add Post"),
  BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Chat"),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
];

String baseURL = "https://dev.paramsoft.com/";
String imagebaseURL = "https://dev.paramsoft.com/sellout/";
String userImageBaseURL = "https://dev.paramsoft.com/sellout/user_images/";

const String kLogin = "sellout/index.php/api/authentication/login";
const String kRgister = "sellout/index.php/api/authentication/registration";
const String kCategories = "sellout/index.php/api/authentication/categories";
const String kCreatePost = "sellout/index.php/api/authentication/createPost";
const String kGetPosts = "sellout/index.php/api/authentication/getPosts";
const String kGetUserProfile = "sellout/index.php/api/authentication/getuserProfile";
const String kUpdateProfile = "sellout/index.php/api/authentication/updateprofile";
const String kAddSupport = "sellout/index.php/api/authentication/addSupport";
const String kGetSupporting= "sellout/index.php/api/authentication/getSupportings";
const String kGetSupporters = "sellout/index.php/api/authentication/getSupporters";
const String kPayments = "sellout/index.php/api/authentication/payments";
const String kSendOTP = "sellout/index.php/api/authentication/sendotp";
const String kCheckOTP = "sellout/index.php/api/authentication/checkotp";
const String kUpdatePassword = "sellout/index.php/api/authentication/updatepassword";
const String kCreateLiveBid = "sellout/index.php/api/authentication/createLiveBid";
const String kUpdateLiveBidStatus = "sellout/index.php/api/authentication/updateLiveBidStatus";
const String kGetLiveBids = "sellout/index.php/api/authentication/getLiveBids";
