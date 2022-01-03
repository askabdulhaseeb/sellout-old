import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/components/user_components/user_components.dart';
import 'package:sellout_team/src/views/splash/splash.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserSignOutSuccessState) {
          Components.navigateAndRemoveUntil(context, Splash());
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(onSelected: (value) async {
                  if (value == 'Log out') {
                    ChatCubit.get(context).stories = [];
                    ChatCubit.get(context).searchList = [];
                    ChatCubit.get(context).groupSearchList = [];

                    await cubit.signOut();
                  }
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text(
                        'Log out',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      value: 'Log out',
                    ),
                  ];
                }),
              ],
            ),
            body: cubit.userInfoModel?.data!.name == null ||
                    state is UserSignOutLoadingState
                ? CircularIndicator()
                : Container(
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          height: Components.kHeight(context) * 0.15,
                          child: UserComponents.userInfoSection(cubit, context),
                        ),
                        Container(
                          height: Components.kHeight(context) * 0.12,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: UserComponents.interactivitySection(
                              context, cubit),
                        ),
                        Container(
                            height: Components.kHeight(context) * 0.08,
                            child: UserComponents.tabBars(context, cubit)),
                        Container(
                            height: Components.kHeight(context) * 0.6,
                            child:
                                UserComponents.buildTabBarView(cubit.tabIndex))
                      ],
                    ),
                  ));
      },
    );
  }
}
