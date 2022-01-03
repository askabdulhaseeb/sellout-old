import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/last_group_chat_message_model.dart';
import 'package:sellout_team/src/models/last_message_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/chat_details_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/group_chat/group_chat_details.dart';
import 'package:sellout_team/src/views/navBar/chat/stories/story.dart';
import 'package:sellout_team/src/views/navBar/chat/tabs/calls.dart';
import 'package:sellout_team/src/views/navBar/chat/tabs/groups_chat.dart';
import 'package:sellout_team/src/views/navBar/chat/tabs/single_chat.dart';
import 'package:sellout_team/src/views/widgets/chats/last_chats/chat_bar_row_widget.dart';
import 'package:sellout_team/src/views/widgets/images/chat_circle_image_widget.dart';

class MainChatComponents {
  static Widget tabBars(BuildContext context, ChatCubit cubit) {
    return Container(
        height: Components.kHeight(context) * 0.07,
        child: DefaultTabController(
          length: Components.kTabs.length,
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
                tabs: Components.kTabs,
                onTap: (value) {
                  cubit.onIndexChange(value);
                },
              ),
            ),
          ),
          initialIndex: cubit.tabIndex,
        ));
  }

  static Widget searchBody(
      {required BuildContext context,
      required ChatCubit cubit,
      required TextEditingController searchController}) {
    return Container(
        height: Components.kHeight(context) * 0.56,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (cubit.groupSearchList.isNotEmpty) {
                LastGroupChatMessage groupChats = cubit.groupSearchList[index];
                return InkWell(
                  onTap: () {
                    Components.navigateTo(
                        context,
                        GroupChatDetailsScreen(
                            name: groupChats.name!,
                            id: groupChats.id!,
                            usersId: groupChats.usersId));
                    searchController.text = '';
                    cubit.emptyList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: searchChatBody(
                        user: groupChats, context: context, isGroup: true),
                  ),
                );
              }

              LastMessagesModel chats = cubit.searchList[index];
              UserModel user = UserModel(
                  name: chats.userName,
                  id: chats.userId,
                  email: chats.userEmail,
                  image: chats.userImage);
              return InkWell(
                onTap: () {
                  //  print('${user.name}');
                  Components.navigateTo(context, ChatDetailsScreen(user));
                  searchController.text = '';
                  cubit.emptyList();
                },
                child: searchChatBody(
                    user: user, context: context, currentChats: chats),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: cubit.groupSearchList.isNotEmpty
                ? cubit.groupSearchList.length
                : cubit.searchList.length));
  }

  static Widget searchChatBody(
      {required user,
      required BuildContext context,
      LastMessagesModel? currentChats,
      bool isGroup = false}) {
    return ChatBarRowWidget(
      imageWidget: isGroup
          ? Icon(
              Icons.group,
              size: 30,
            )
          : ChatCircleImageWidget(
              image: '${user.image}',
              width: Components.kWidth(context) * 0.16,
            ),
      name: isGroup ? user.name : '${user.name}',
      captionWidget: Container(
        width: Components.kWidth(context) * 0.5,
        child: Text(
          content(
              isGroup ? user.lastMessage : currentChats?.lastMessageContent),
          overflow: TextOverflow.ellipsis,
          style: Components.kCaption(context)?.copyWith(color: Colors.grey),
        ),
      ),
      endWidget: Text(
        isGroup
            ? '${DateFormat.jm().format(user.date.toDate())}'
            : '${DateFormat.jm().format(currentChats!.lastMessageDate!.toDate())}',
        style: Components.kCaption(context)?.copyWith(color: Colors.grey),
      ),
    );
  }

  static String content(String? content) {
    if (content!.contains('images')) {
      return 'Photo';
    }
    if (content.contains('video')) {
      return 'Video';
    }
    if (content.contains('docs')) {
      return 'Document';
    }

    return content;
  }

  static Widget buildTabBarView(int index) {
    if (index == 0) {
      return SingleChat();
    }
    if (index == 1) {
      return GroupsChat();
    }

    return CallsSection();
  }

  static Widget buildStorySection(
      {required BuildContext context, required ChatCubit cubit}) {
    return Container(
        width: Components.kWidth(context) * 0.68,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return const SizedBox(width: 12);
            },
            itemCount: cubit.stories!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Components.navigateTo(context, Story(cubit.stories![index]));
                },
                child:
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage('${cubit.stories![index].userImage}'),
                    //   radius: 40,
                    // )
                    ChatCircleImageWidget(
                  // radius: 15,
                  image: '${cubit.stories![index].userImage}',
                  width: Components.kWidth(context) * 0.2,
                ),
              );
            }));
  }

  static Widget searchField(
      {required BuildContext context,
      required ChatCubit cubit,
      required TextEditingController searchController}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: Components.kHeight(context) * 0.05,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5, color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: searchController,
                onFieldSubmitted: (value) async {
                  //  cubit.onSearchChanged(value);
                  await cubit.searchChats(searchController.text);
                  // print('${searchController.text}');
                  // print('${cubit.searchList.length}');
                  // print('${cubit.groupSearchList.length}');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  fillColor: Colors.grey.withOpacity(0.15),
                  filled: true,
                  hintStyle: Components.kBodyOne(context)
                      ?.copyWith(color: Colors.grey.withOpacity(0.8)),
                  contentPadding: const EdgeInsets.all(2),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(Icons.border_color)
        ],
      ),
    );
  }
}
