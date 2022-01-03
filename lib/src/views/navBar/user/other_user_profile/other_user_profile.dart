import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/components/user_components/user_components.dart';
import 'package:sellout_team/src/views/navBar/nav_bar.dart';
import 'package:sellout_team/src/views/navBar/user/tab_views/user_posts.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';

class OtherUserProfile extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserDeleteSupportSuccessState) {
          Components.kSnackBar(context, 'Removed Successfully!',
              isSuccess: true);
        }
        if (state is UserAddSupportSuccessState) {
          Components.kSnackBar(context, 'Added Successfully!', isSuccess: true);
        }
        if (state is UserBlockUserSuccessState) {
          Components.kSnackBar(context, 'User Blocked Successfully!',
              isSuccess: true);
          Components.navigateAndRemoveUntil(context, NavBar());
        }
        if (state is UserSendReportSuccessState) {
          Components.kSnackBar(context, 'Your report has been sent!',
              isSuccess: true);
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(onSelected: (value) async {
                  if (value == 'Support') {
                    await cubit.addSupport(
                        otherUserModel: cubit.otherUserModel!);
                    //await cubit.getSupports(cubit.otherUserModel!.data!.id!);
                  }
                  if (value == 'Remove') {
                    await cubit.deleteSupport(cubit.otherUserModel!.data!.id!);
                  }
                  if (value == 'Block') {
                    UserModel otherUserModel = UserModel(
                        name: cubit.otherUserModel?.data!.name,
                        id: cubit.otherUserModel?.data!.id,
                        email: cubit.otherUserModel?.data!.email,
                        image: cubit.otherUserModel?.data!.userimg);
                    await cubit.blockUser(
                        userBlocker: kUserModel!, userBlocked: otherUserModel);
                    await PostCubit.get(context).getPosts();
                  }
                  if (value == 'Report') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              MaterialButton(
                                onPressed: () async {
                                  await cubit.sendReport(cubit.otherUserModel!);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            ],
                            content: Text(
                                'Are you sure you want to report this user?'),
                          );
                        });
                  }
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text(
                        cubit.isUserSupport ? 'Remove' : 'Support',
                        style: TextStyle(
                            color: cubit.isUserSupport
                                ? kPrimaryColor
                                : Colors.green),
                      ),
                      value: cubit.isUserSupport ? 'Remove' : 'Support',
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Block',
                      ),
                      value: 'Block',
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Report',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      value: 'Report',
                    ),
                  ];
                }),
              ],
            ),
            body: cubit.otherUserModel?.data!.name == null
                ? CircularIndicator()
                : Container(
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          height: Components.kHeight(context) * 0.15,
                          child: UserComponents.userInfoSection(cubit, context,
                              isOtherUser: true),
                        ),
                        Container(
                          height: Components.kHeight(context) * 0.12,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: UserComponents.interactivitySection(
                              context, cubit,
                              isOtherUser: true),
                        ),
                        Container(
                            height: Components.kHeight(context) * 0.08,
                            child: tabBars(context, cubit)),
                        Container(
                            height: Components.kHeight(context) * 0.6,
                            child: UserPosts())
                      ],
                    ),
                  ));
      },
    );
  }

  Widget tabBars(BuildContext context, UserCubit cubit) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.grey,
          bottom: TabBar(
            labelColor: kPrimaryColor,
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2))),
            tabs: [
              InkWell(
                onTap: () {
                  cubit.getPostsForCurrentUser(
                      '${cubit.otherUserModel?.data!.id}');
                },
                child: Icon(
                  Icons.storefront,
                  size: 30,
                ),
              ),
              PopupMenuButton(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cubit.selectedCategory.isEmpty
                              ? 'Category'
                              : cubit.selectedCategory,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Components.kBodyOne(context)?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  onSelected: (String? value) {
                    print('$value');
                    String catID = "";
                    cubit.categories.forEach((element) {
                      if(element.categoryName == value){
                        catID = element.id!;
                      }
                    });
                    cubit.onCategorySelected(value!, catID);
                    cubit.getPostsByCategory(
                        '${cubit.otherUserModel?.data!.id}');
                  },
                  itemBuilder: (context) {
                    return cubit.categories
                        .map(
                          (e) => PopupMenuItem(
                            child: Text('${e.categoryName}'),
                            value: '${e.categoryName}',
                          ),
                        )
                        .toList();
                  }),
            ],
            onTap: (value) {},
          ),
        ),
      ),
      initialIndex: 0,
    );
  }
}
