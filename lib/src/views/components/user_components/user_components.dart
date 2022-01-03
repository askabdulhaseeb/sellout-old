import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/category_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/user/edit_profile/edit_profile.dart';
import 'package:sellout_team/src/views/navBar/user/tab_views/user_cart.dart';
import 'package:sellout_team/src/views/navBar/user/tab_views/user_posts.dart';
import 'package:sellout_team/src/views/navBar/user/user_support/user_support.dart';

class UserComponents {
  static Widget interactivitySection(BuildContext context, UserCubit cubit,
      {bool isOtherUser = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isOtherUser
            ? const SizedBox()
            : interactivityContainer(
                context: context,
                isOtherUser: false,
                isIcon: true,
                icon: Icon(
                  Icons.account_balance,
                  color: kPrimaryColor,
                )),
        const SizedBox(
          width: 10,
        ),
        interactivityContainer(
            isOtherUser: isOtherUser,
            context: context,
            number: cubit.userPosts!.length,
            text: 'Posts'),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            Components.navigateTo(context, UserSupport());
          },
          child: interactivityContainer(
              isOtherUser: isOtherUser,
              context: context,
              number: cubit.userSupportings,
              text: 'Supporting'),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            Components.navigateTo(context, UserSupport(isSupporters: true));
          },
          child: interactivityContainer(
              isOtherUser: isOtherUser,
              context: context,
              number: cubit.userSupporters,
              text: 'Supporters'),
        ),
      ],
    );
  }

  static Widget interactivityContainer(
      {required BuildContext context,
      bool isIcon = false,
      Widget? icon,
      int? number,
      required bool isOtherUser,
      String? text}) {
    return Container(
      height: Components.kHeight(context) * 0.1,
      width: isOtherUser
          ? Components.kWidth(context) * 0.25
          : Components.kWidth(context) * 0.2,
      decoration: Components.kElevatedContainer,
      // padding: const EdgeInsets.only(left: 4, right: 4),
      child: isIcon
          ? icon
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$number',
                  style: Components.kHeadLineSix(context)
                      ?.copyWith(color: kPrimaryColor),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text('$text')
              ],
            ),
    );
  }

  static Widget userInfoSection(UserCubit cubit, BuildContext context,
      {bool isOtherUser = false}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(isOtherUser
              ? '${cubit.otherUserModel?.data!.userimg}'
              : '${cubit.userInfoModel?.data!.userimg}'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Components.kHeight(context) * 0.055,
              width: Components.kWidth(context) * 0.6,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isOtherUser
                          ? '${cubit.otherUserModel?.data!.name}'
                          : '${cubit.userInfoModel?.data!.name}',
                      style: Components.kHeadLineSix(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  isOtherUser
                      ? SizedBox()
                      : Expanded(
                          child: Container(
                            //  height: Components.kHeight(context) * 0.04,
                            child: MaterialButton(
                              onPressed: () {
                                Components.navigateTo(context, EditProfile());
                              },
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                'Edit Profile',
                                style: Components.kCaption(context)
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemPadding: EdgeInsets.symmetric(horizontal: 0.6),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: kPrimaryColor,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            isOtherUser
                ? Text(
                    cubit.otherUserModel!.data!.biography!.isNotEmpty
                        ? '${cubit.otherUserModel?.data!.biography}'
                        : 'Bio....',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
                : Text(
                    cubit.userInfoModel!.data!.biography!.isNotEmpty
                        ? '${cubit.userInfoModel?.data!.biography}'
                        : 'Bio....',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
          ],
        ),
      ],
    );
  }

  static Widget tabBars(BuildContext context, UserCubit cubit) {
    return DefaultTabController(
      length: 3,
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
              Icon(
                Icons.storefront,
                size: 30,
              ),
              PopupMenuButton(
                  child: Container(
                    margin: const EdgeInsets.all(4),
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
                    String catID = "";
                    cubit.categories.forEach((element) {
                      if(element.categoryName == value){
                        catID = element.id!;
                      }
                    });
                    cubit.onCategorySelected(value!, catID);
                    cubit.getPostsByCategory('${cubit.userModel?.id}');
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
              Icon(
                Icons.inventory_sharp,
                size: 30,
              )
            ],
            onTap: (value) async {
              cubit.onIndexChange(value);

              if (value == 0) {
                await cubit.getPostsForCurrentUser('${cubit.userModel?.id}');
              }
            },
          ),
        ),
      ),
      initialIndex: cubit.tabIndex,
    );
  }

  static Widget buildTabBarView(int index) {
    if (index == 0 || index == 1) {
      return UserPosts();
    }

    return UserCart();
  }
}
