import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/offer_model.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/chat_details_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/video_view.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/view_image.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:sellout_team/src/views/widgets/post/counter/product_counter.dart';
import 'package:sellout_team/src/views/widgets/post/images/post_image_widget.dart';
import 'package:sellout_team/src/views/widgets/rectangle_border_button.dart';
import 'package:sellout_team/src/views/widgets/video/video_widget.dart';
import 'package:timeago/timeago.dart' as time;

class PostDetails extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Post',
              style: Components.kHeadLineSix(context)
                  ?.copyWith(color: kPrimaryColor),
            ),
          ),
          body: cubit.postById == null
              ? CircularIndicator()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userSection(context: context, post: cubit.postById!),
                          const SizedBox(
                            height: 10,
                          ),
                          imagesSection(
                              context: context,
                              post: cubit.postById!,
                              cubit: cubit,
                              pageController: pageController),
                          const SizedBox(
                            height: 10,
                          ),
                          cubit.isOfferPressed == true
                              ? makeOfferBody(
                                  context: context,
                                  cubit: cubit,
                                  post: cubit.postById!,
                                  index: 0,
                                )
                              : descriptionSection(
                                  context: context, post: cubit.postById!),
                          const SizedBox(
                            height: 10,
                          ),
                          RectangleBorderButttonWidget(
                            text: 'Buy Now',
                            function: () async {
                              if (cubit.userModel?.id !=
                                  cubit.postById?.userId) {
                                if (cubit.cartList.isEmpty) {
                                  // await PostCubit.get(context).addToCart(
                                  //     postUserId: cubit.postById!.userId!,
                                  //     postId: cubit.postById!.postId!,
                                  //     content: cubit.postById!.content!,
                                  //     price: cubit.postById!.price!,
                                  //     date: cubit.postById!.date!,
                                  //     maxQuantity: cubit.postById!.quantity!,
                                  //     quantity: '1',
                                  //     media: cubit.postById!.media,
                                  //     extensions: cubit.postById!.extensions);
                                }
                                cubit.cartList.forEach((element) async {
                                  if (cubit.postById!.id ==
                                      element.postId) {
                                    Components.kSnackBar(
                                        context, 'Already in Cart!');
                                  } else {
                                    // await PostCubit.get(context).addToCart(
                                    //     postUserId: cubit.postById!.userId!,
                                    //     postId: cubit.postById!.postId!,
                                    //     content: cubit.postById!.content!,
                                    //     price: cubit.postById!.price!,
                                    //     date: cubit.postById!.date!,
                                    //     maxQuantity: cubit.postById!.quantity!,
                                    //     quantity: '1',
                                    //     media: cubit.postById!.media,
                                    //     extensions: cubit.postById!.extensions);
                                  }
                                });
                              }
                            },
                          ),
                          RectangleBorderButttonWidget(
                            text: 'Make Offer',
                            function: () async {
                              if (cubit.userModel?.id !=
                                  cubit.postById!.userId) {
                                // if (cubit.postById!.isOffer!) {
                                //   cubit.isOffer();
                                //   print(PostCubit.get(context).isMakeOffer[0]);
                                // }
                                if (int.parse(cubit.postById!.quantity!) !=
                                        cubit.postByIdQuantity ||
                                    int.parse(cubit.postById!.price!) !=
                                        cubit.postByIdPrice) {
                                  OfferModel offerModel = OfferModel(
                                      postId: cubit.postById!.id,
                                      postUserId: cubit.postById!.userId,
                                      userId: kUserModel?.id,
                                      userName: kUserModel?.name,
                                      quantity: cubit.postByIdQuantity,
                                      price: cubit.postByIdPrice);
                                  await PostCubit.get(context)
                                      .addOffer(offerModel: offerModel);
                                  Components.kSnackBar(
                                      context, 'Offer has been sent!');
                                }
                              }
                            },
                            isDisabled: /*cubit.postById!.isOffer! ? false :*/ true,
                          ),
                          RectangleBorderButttonWidget(
                            text: 'Message Seller',
                            isNotPrimaryColor: true,
                            function: () {
                              if (kUid != cubit.postById!.userId) {
                                // UserModel userModel = UserModel(
                                //     name: cubit.postById!.userName,
                                //     id: cubit.postById!.userId,
                                //     email: cubit.postById!.userEmail,
                                //     image: cubit.postById!.userImage);
                                // Components.navigateTo(
                                //     context, ChatDetailsScreen(userModel));
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            // '${time.format(cubit.postById!.date!.toDate())}',
                            'Date',
                            style: Components.kCaption(context),
                          )
                        ],
                      ),
                    ),
                  )),
        );
      },
    );
  }

  Widget makeOfferBody({
    required context,
    required UserCubit cubit,
    required PostModel post,
    required int index,
  }) {
    return Container(
      height: Components.kHeight(context) * 0.2,
      width: Components.kWidth(context),
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: Components.kElevatedContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity',
                style: Components.kBodyOne(context),
              ),
              ProductCounter(
                text: '${cubit.postByIdQuantity}',
                increment: () {
                  cubit.quantityIncrement();
                },
                decrement: () {
                  cubit.quantityDecrement();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: Components.kBodyOne(context),
              ),
              ProductCounter(
                  text: '${cubit.postByIdPrice}',
                  increment: () {
                    cubit.priceIncrement();
                  },
                  decrement: () {
                    cubit.priceDecrement();
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget descriptionSection(
      {required BuildContext context, required PostModel post}) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${post.content}',
                style: Components.kHeadLineSix(context)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                post.price!.isNotEmpty ? '${post.price}\$' : '',
                style: Components.kHeadLineSix(context)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              if (post.locality!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '${post.locality}, ${post.country}',
                        style: Components.kCaption(context),
                      )
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${post.description}',
                  style: Components.kBodyOne(context)
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget userSection({required BuildContext context, required PostModel post}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      height: Components.kHeight(context) * 0.05,
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(image: NetworkImage('https://media.istockphoto.com/photos/englishman-picture-id181062211?b=1&k=20&m=181062211&s=170667a&w=0&h=kQ8CethuhbrhhP3-SMeXh2vD1Zhog9feZ5jfwqmUNZk='))),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Rahul Jangid',
            style: Components.kBodyOne(context),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget imagesSection(
      {required BuildContext context,
      required PostModel post,
      required UserCubit cubit,
      required PageController pageController}) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Container(
          height: Components.kHeight(context) * 0.44,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              PageView.builder(
                  onPageChanged: (index) {
                    cubit.changePageIndex(index);
                  },
                  controller: pageController,
                  itemCount: post.images!.length,
                  itemBuilder: (context, index) {
                    // if (post.extensions[index] == 'video/mp4') {
                    //   return InkWell(
                    //       onTap: () {
                    //         Components.navigateTo(
                    //             context, VideoView(post.media[index]));
                    //       },
                    //       child: VideoWidget(post.media[index]));
                    // }
                    return InkWell(
                        onTap: () {
                          Components.navigateTo(
                              context, ViewImage(post.images![index].imageUrl.toString()));
                        },
                        child: PostImageWidget('${post.images![index].imageUrl}'));
                  }),
              if (post.images!.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: post.images!.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => pageController.animateToPage(entry.key,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.bounceIn),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cubit.pageIndex == entry.key
                                  ? kPrimaryColor
                                  : Colors.white70),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
