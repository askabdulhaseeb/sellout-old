import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/user/tab_views/post_details.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';

class UserPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserGetPostByIdSuccessState) {
          Components.navigateTo(context, PostDetails());
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);

        // if (state is UserGetPostByIdLoadingState ||
        //     state is UserGetPostsByCategoryLoadingState) {
        //   return CircularIndicator();
        // }

        if (cubit.selectedCategory.isNotEmpty &&
            cubit.postsByCategory.isEmpty) {
          return Center(
            child: Text(
              'No posts',
              style: Components.kBodyOne(context),
            ),
          );
        }

        return GridView.builder(
            itemCount: cubit.selectedCategory.isNotEmpty 
                ? cubit.postsByCategory.length
                : cubit.userPosts!.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        await cubit.getPostById(
                            cubit.selectedCategory.isNotEmpty
                                ? cubit.postsByCategory[index].id!
                                : cubit.userPosts![index].id!);
                      } catch (error) {
                        print('$error');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Image(
                          image: NetworkImage(cubit.selectedCategory.isNotEmpty
                              ? imagebaseURL+'${cubit.postsByCategory[index].images!.first.imageUrl}'
                              : imagebaseURL+ '${cubit.userPosts![index].images!.first.imageUrl}')),
                    ),
                  ),
                  if (cubit.selectedCategory.isNotEmpty &&
                      cubit.postsByCategory[index].images!.length > 1)
                    Icon(
                      Icons.auto_awesome_motion,
                    ),
                  // if (cubit.selectedCategory.isEmpty &&
                  //     cubit.userPosts[index].images!.length > 1)
                  //   Icon(
                  //     Icons.auto_awesome_motion,
                  //   )
                ],
              );
            });
      },
    );
  }
}
