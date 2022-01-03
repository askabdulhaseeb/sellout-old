import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/post/post_states/post_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/components/home_components/home_components.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) async {
        if (state is PostAddOfferSuccessState) {
          Components.kSnackBar(context, 'Your offer had been sent',
              isSuccess: true);
          await PostCubit.get(context).getPosts();
        }
        if (state is PostHideUserSuccessState) {
          Components.kSnackBar(context, 'User hide successfully!',
              isSuccess: true);
        }

        if (state is PostAddToCartSuccessState) {
          Components.kSnackBar(context, 'Added to Cart!', isSuccess: true);
        }
      },
      builder: (context, state) {
        var cubit = PostCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'SellOut',
              style: Components.kHeadLineFive(context)
                  ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          body: cubit.posts!.length == 0
              ? Center(
                  child: Text(
                    'No posts',
                    style: Components.kBodyOne(context),
                  ),
                )

              //  Center(
              //     child: Text(
              //       'No Posts',
              //       style: Components.kBodyOne(context),
              //     ),
              //   )
              : RefreshIndicator(
                  onRefresh: () async {
                    return await cubit.getPosts();
                  },
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: cubit.posts!.length,
                      itemBuilder: (context, index) {
                        return HomeComponents.buildPostCard(
                            context: context,
                            post: cubit.posts![index],
                            cubit: cubit,
                            index: index,
                            state: state,
                            isOffer: false,
                            pageController: pageController);
                      }),
                ),
        );
      },
    );
  }
}
