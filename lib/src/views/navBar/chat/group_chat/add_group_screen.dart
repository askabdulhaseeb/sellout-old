import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/group_chat/group_chat_details.dart';

class AddGroupScreen extends StatefulWidget {
  late final List<UserModel> users;
  late final UserModel currentUser;

  AddGroupScreen(this.users, this.currentUser);
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final groupNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<bool>? selected;
  List<UserModel> groupUsers = [];
  List<String> usersId = [];
  String groupId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void initState() {
    selected = List.filled(widget.users.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: IconThemeData(color: kPrimaryColor),
            title: Text(
              'Add Group',
              style: Components.kHeadLineSix(context)
                  ?.copyWith(color: kPrimaryColor),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            child: state is ChatAddGroupChatLoadingState
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit
                    .addGroupChat(groupId, groupNameController.text, groupUsers)
                    .then((value) {
                  Components.navigateTo(
                      context,
                      GroupChatDetailsScreen(
                        name: groupNameController.text,
                        id: groupId,
                        usersId: usersId,
                      ));
                });
              }
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Group Name : ',
                          style: Components.kBodyOne(context)
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please type a name';
                                }
                              },
                              controller: groupNameController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(2)),
                            ))
                      ],
                    ),
                    Components.kDivider,
                    usersList(context)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget usersList(BuildContext context) {
    return Container(
      height: Components.kHeight(context) * 0.7,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.75),
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('${widget.users[index].image}'),
                ),
                Text('${widget.users[index].name}'),
                Checkbox(
                    fillColor: MaterialStateProperty.all<Color>(
                        selected![index] ? Colors.green : Colors.grey),
                    value: selected![index],
                    onChanged: (value) {
                      setState(() {
                        selected![index] = value!;
                        if (selected![index] == true) {
                          if (!groupUsers.contains(widget.users[index])) {
                            groupUsers.add(widget.users[index]);
                            usersId.add(widget.users[index].id!);
                          }
                          if (!groupUsers.contains(widget.currentUser)) {
                            groupUsers.add(widget.currentUser);
                            usersId.add(kUid!);
                          }
                          print(groupUsers.length);
                        }
                        if (selected![index] == false &&
                            groupUsers.contains(widget.users[index])) {
                          groupUsers.remove(widget.users[index]);
                          usersId.remove(widget.users[index].id!);
                          print(groupUsers.length);
                        }
                      });
                    }),
              ],
            );
          }),
    );
  }
}
