import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/live/live_cubit/live_cubit.dart';
import 'package:sellout_team/src/blocs/payment/payment_cubit/payment_cubit.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/bloc_observer.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/configs/payment_configs.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/pick_up/pick_up_layout.dart';
import 'package:sellout_team/src/views/navBar/nav_bar.dart';
import 'package:sellout_team/src/views/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  kUid = CacheHelper.getString('uid');
  if (CacheHelper.getString('user') != null) {
    debugPrint(CacheHelper.getString('user'));
    Map<String, dynamic> userMap = jsonDecode(CacheHelper.getString('user'));
    kUserModel = UserModel.fromFirebase(userMap);
  }

  Bloc.observer = MyBlocObserver();
  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey = apiKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit()
            ..getUserData()
            ..getCart(),
        ),
        BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
        BlocProvider<PaymentCubit>(create: (context) => PaymentCubit()),
        BlocProvider<LiveCubit>(create: (context) => LiveCubit()),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit()
            ..getPosts()
            ..getCategory(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: Components.kNavBarStyle,
          appBarTheme: Components.kAppBarTheme,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.grey,
        ),
        home: kUid != null ? PickUpLayout(NavBar()) : Splash(),
        //home: Splash(),
      ),
    );
  }
}
