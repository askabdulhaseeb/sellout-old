import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/chat_components/main_chat_components/main_chat_components.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/chats/stories/add_story_widget.dart';

class ChatScreen extends StatelessWidget {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {
        if (state is ChatPickStoriesErrorState) {
          Components.kSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(
              'Chats',
              style: Components.kHeadLineFive(context)
                  ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
            child: ListView(
              children: [
                // Container(
                //   height: Components.kHeight(context) * 0.1,
                //   child: Row(
                //     children: [
                //       InkWell(
                //           onTap: () {
                //             cubit.addStories();
                //           },
                //           child: Padding(
                //             padding: EdgeInsets.only(left: 8),
                //             child: AddStoryWidget(),
                //           )),
                //       const SizedBox(
                //         width: 6,
                //       ),
                //       cubit.stories!.isEmpty
                //           ? const SizedBox()
                //           : MainChatComponents.buildStorySection(
                //               context: context, cubit: cubit)
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 8,
                ),
                MainChatComponents.searchField(
                    context: context,
                    cubit: cubit,
                    searchController: searchController),
                searchController.text.isNotEmpty
                    ? MainChatComponents.searchBody(
                        context: context,
                        cubit: cubit,
                        searchController: searchController)
                    : Column(
                        children: [
                          MainChatComponents.tabBars(context, cubit),
                          Container(
                              height: Components.kHeight(context) * 0.47,
                              child: MainChatComponents.buildTabBarView(
                                  cubit.tabIndex))
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
