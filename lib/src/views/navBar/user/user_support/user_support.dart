import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/user/other_user_profile/other_user_profile.dart';

class UserSupport extends StatelessWidget {
  late final bool isSupporters;

  UserSupport({this.isSupporters = false});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(isSupporters ? 'Supporters' : 'Supporting',
                style: Components.kHeadLineSix(context)
                    ?.copyWith(color: kPrimaryColor)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      // try {
                      //   await cubit.getOtherUserData(isSupporters
                      //       ? cubit.supportersList[index].id!
                      //       : cubit.supportingsList[index].id!);
                      //   await cubit.getPostsForCurrentUser(isSupporters
                      //       ? cubit.supportersList[index].id!
                      //       : cubit.supportingsList[index].id!);
                      //   await cubit.getSupports(isSupporters
                      //       ? cubit.supportersList[index].id!
                      //       : cubit.supportingsList[index].id!);
                      //   Components.navigateTo(context, OtherUserProfile());
                      // } catch (error) {
                      //   print(error.toString());
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: Components.kElevatedContainer,
                      child: ListTile(
                        leading: Image(
                            image: NetworkImage(isSupporters
                                ? '${cubit.supportersList[index].userImage!}'
                                : '${cubit.supportingsList[index].userImage!}')),
                        title: Text(
                          isSupporters
                              ? '${cubit.supportersList[index].userName}'
                              : '${cubit.supportingsList[index].userName}',
                          style: Components.kBodyOne(context),
                        ),
                        subtitle: Text(
                          isSupporters
                              ? '${cubit.supportersList[index].biography}'
                              : '${cubit.supportingsList[index].biography}',
                          style: Components.kCaption(context),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: isSupporters
                    ? cubit.supportersList.length
                    : cubit.supportingsList.length),
          ),
        );
      },
    );
  }
}
