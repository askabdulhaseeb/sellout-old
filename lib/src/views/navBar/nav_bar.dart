import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/liveBid/pages/home_page.dart';

import 'package:sellout_team/src/views/navBar/cart/cart_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/main_screen/chat_screen.dart';
import 'package:sellout_team/src/views/navBar/home/home.dart';
import 'package:sellout_team/src/views/navBar/post/post.dart';
import 'package:sellout_team/src/views/navBar/user/user_screen.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  List<Widget> childern = [
    Home(),
    CartScreen(),
    AddPost(),
    ChatScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: kNavBarItems,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
          if (currentIndex == 4) {
            UserCubit.get(context)
              ..getPostsForCurrentUser('${kUserModel?.id}')
              ..getCart()
              ..getSupports('${kUserModel?.id}');
          }
          if (currentIndex == 3) {
            ChatCubit.get(context)..getStories();
          }
        },
      ),
      //body: kUserModel == null ? CircularIndicator() : childern[currentIndex],
      body: childern[currentIndex],
    );
  }
}
