import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/post/post_states/post_states.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/cart_model.dart';
import 'package:sellout_team/src/models/offer_model.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/payment_service/payment_services.dart';
import 'package:sellout_team/src/services/paypal_services/makePayment.dart';
import 'package:sellout_team/src/services/paypal_services/paypalPayment.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/cart/checkout.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/chat_details_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/video_view.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/view_image.dart';
import 'package:sellout_team/src/views/navBar/user/other_user_profile/other_user_profile.dart';
import 'package:sellout_team/src/views/navBar/user/user_screen.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:sellout_team/src/views/widgets/post/arrows_indicators/arrows_indicators.dart';
import 'package:sellout_team/src/views/widgets/post/counter/product_counter.dart';
import 'package:sellout_team/src/views/widgets/post/images/post_image_widget.dart';
import 'package:sellout_team/src/views/widgets/rectangle_border_button.dart';
import 'package:sellout_team/src/views/widgets/video/video_widget.dart';
import 'package:timeago/timeago.dart' as time;

class HomeComponents {
  static Widget buildPostCard(
      {required BuildContext context,
      required PostModel post,
      required PostCubit cubit,
      required int index,
      required PostStates state,
      required bool isOffer,
      required PageController pageController}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userSection(context: context, post: post, cubit: cubit),
            const SizedBox(
              height: 10,
            ),
            imagesSection(
                context: context,
                cubit: cubit,
                post: post,
                pageController: pageController),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isOffer == true && state is! PostAddOfferSuccessState
                    ? makeOfferBody(
                        context: context,
                        post: post,
                        index: index,
                        cubit: cubit,
                        state: state)
                    : descriptionSection(context: context, post: post),
                const SizedBox(
                  height: 10,
                ),
                RectangleBorderButttonWidget(
                    text: 'Buy Now',
                    function: () async {
                      Components.navigateTo(
                          context,
                          CheckOut(
                            postModel: post,
                          ));
                    }),
                // state is PostAddToCartLoadingState
                //     ? CircularIndicator()
                //     : RectangleBorderButttonWidget(
                //         text: 'Add to Basket',
                //         function: () async {
                //           if (post.userId != kUid) {
                //             if (UserCubit.get(context).cartList.isEmpty) {
                //               // await cubit.addToCart(
                //               //     postUserId: post.userId!,
                //               //     postId: post.id!,
                //               //     content: post.content!,
                //               //     price: post.price!,
                //               //     date: post.date!,
                //               //     maxQuantity: post.quantity!,
                //               //     quantity: '1',
                //               //     media: post.media,
                //               //     extensions: post.extensions);
                //             }
                //             if (UserCubit.get(context).cartList.isNotEmpty) {
                //               // UserCubit.get(context)
                //               //     .cartList
                //               //     .forEach((element) async {
                //               //   if (post.postId == element.postId &&
                //               //       post.content == element.content) {
                //               //     Components.kSnackBar(
                //               //         context, 'Already in Cart!');
                //               //   }
                //               // });
                //               // await cubit.addToCart(
                //               //     postUserId: post.userId!,
                //               //     postId: post.postId!,
                //               //     content: post.content!,
                //               //     price: post.price!,
                //               //     date: post.date!,
                //               //     maxQuantity: post.quantity!,
                //               //     quantity: '1',
                //               //     media: post.media,
                //               //     extensions: post.extensions);
                //             }
                //           }
                //         },
                //       ),
                state is PostAddOfferLoadingState
                    ? CircularIndicator()
                    : RectangleBorderButttonWidget(
                        text: 'Make Offer',
                        isDisabled: /* post.isOffer! ? false :*/ true,
                        function: () {
                          // if (post.isOffer!) {
                          //   cubit.makeOfferPressed(index);
                          //   print(cubit.isMakeOffer[index]);
                          // }
                          // if (int.parse(post.quantity!) !=
                          //         cubit.quantityList[index] ||
                          //     int.parse(post.price!) !=
                          //         cubit.priceList[index]) {
                          //   OfferModel offerModel = OfferModel(
                          //       postId: post.postId,
                          //       postUserId: post.userId,
                          //       userId: kUserModel?.id,
                          //       userName: kUserModel?.name,
                          //       quantity: cubit.quantityList[index],
                          //       price: cubit.priceList[index]);
                          //   cubit.addOffer(offerModel: offerModel);
                          // }
                        },
                      ),
              ],
            ),
            RectangleBorderButttonWidget(
              text: 'Message Seller',
              isNotPrimaryColor: true,
              function: () {
                if (kUid != post.userId) {
                  UserModel userModel = UserModel(
                      name: post.userName,
                      id: post.userId,
                      email: post.userEmail,
                      image: post.userImage);
                  Components.navigateTo(context, ChatDetailsScreen(userModel));
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Date',
              style: Components.kCaption(context),
            )
          ],
        ),
      ),
    );
  }

  static Widget descriptionSection(
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
              // Text(
              //   'London',
              //   style: Components.kCaption(context),
              // ),
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

  static Widget imagesSection(
      {required BuildContext context,
      required PostModel post,
      required PostCubit cubit,
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
                    //             context, VideoView(post.images![index].imageUrl.toString()));
                    //       },
                    //       child: VideoWidget(post.images![index].imageUrl.toString()));
                    // }
                    return InkWell(
                        onTap: () {
                          Components.navigateTo(
                              context,
                              ViewImage(imagebaseURL +
                                  post.images![index].imageUrl.toString()));
                        },
                        child: PostImageWidget(
                            imagebaseURL + '${post.images![index].imageUrl}'));
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
        // ArrowsIndicators(
        //   controller: pageController,
        //   currentMedia: cubit.pageIndex,
        //   isLast: cubit.isLast,
        // )
      ],
    );
  }

  static Widget userSection(
      {required BuildContext context,
      required PostModel post,
      required PostCubit cubit}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () async {
          try {
            await UserCubit.get(context).getOtherUserData(post.userId!);
            await UserCubit.get(context).getPostsForCurrentUser(post.userId!);
            await UserCubit.get(context).getSupports(post.userId!);
            Components.navigateTo(context, OtherUserProfile());
          } catch (error) {
            print(error.toString());
          }
        },
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  post.userImage.toString(),
                  fit: BoxFit.fill,
                  width: 55,
                  height: 55,
                )),
            const SizedBox(
              width: 10,
            ),
            Text(
              post.userName.toString(),
              style: Components.kBodyOne(context),
            ),
            Spacer(),
            PopupMenuButton(onSelected: (value) async {
              if (value == 'Hide') {
                // await UserCubit.get(context).getOtherUserData(post.userId!);
                // UserModel otherUserModel = UserModel(
                //     name: post.userName,
                //     id: post.userId,
                //     email: post.userEmail,
                //     image: post.userImage);
                // await cubit.hideUser(
                //     userHider: kUserModel!, userHiden: otherUserModel);
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Hide'),
                  value: 'Hide',
                ),
              ];
            }),
          ],
        ),
      ),
    );
  }

  static Widget makeOfferBody(
      {required context,
      required PostModel post,
      required int index,
      required PostCubit cubit,
      required PostStates state}) {
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
                text: '${cubit.quantityList[index]}',
                increment: () {
                  cubit.increaseQuantity(index);
                },
                decrement: () {
                  cubit.decrementQuantity(index);
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
                  text: '${cubit.priceList[index]}',
                  increment: () {
                    cubit.increasePrice(index);
                  },
                  decrement: () {
                    cubit.decrementPrice(index);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
