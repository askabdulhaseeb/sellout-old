import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/cart_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/user/tab_views/post_details.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:sellout_team/src/views/widgets/post/counter/product_counter.dart';

class UserCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserDeleteCartItemSuccessState) {
          Components.kSnackBar(context, 'Product got deleted!');
        }
        if (state is UserGetPostByIdSuccessState) {
          Components.navigateTo(context, PostDetails());
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // alignment: AlignmentDirectional.topCenter,
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: Components.kHeight(context) * 0.36,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (cubit.cartList.isEmpty) {
                        return Center(
                          child: Text('No data',
                              style: Components.kBodyOne(context)),
                        );
                      }
                      return Container(
                          height: Components.kHeight(context) * 0.15,
                          decoration: Components.kElevatedContainer,
                          child: cartContainer(
                            cubit: cubit,
                            state: state,
                            index: index,
                            cart: cubit.cartList[index],
                            context: context,
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: cubit.cartList.length),
              ),
              Container(
                  // bottom: Components.kHeight(context) * 0.15,
                  // left: Components.kWidth(context) * 0.35,
                  // top: Components.kHeight(context) * 0.36,
                  // height: Components.kHeight(context) * 0.1,
                  child: buyButton(context))
            ],
          ),
        );
      },
    );
  }

  Widget cartContainer(
      {required UserCubit cubit,
      required UserStates state,
      required CartModel cart,
      required int index,
      required BuildContext context}) {
    return Row(
      children: [
        Expanded(
            child: InkWell(
                onTap: () async {
                  await cubit.getPostById(cart.postId!);
                },
                child: Image(image: NetworkImage('${cart.media.first}')))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${cart.content}',
                style: Components.kBodyOne(context)
                    ?.copyWith(color: Colors.grey.withOpacity(0.8)),
              ),
              Text(
                '\$${cart.price}',
                style: Components.kBodyOne(context)?.copyWith(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              // state is UserDeleteCartItemLoadingState
              //     ? CircularIndicator()
              //     :

              MaterialButton(
                onPressed: () {
                  cubit.deleteCartProduct(cart.cartId!);
                },
                height: Components.kHeight(context) * 0.04,
                child: Text(
                  'Delete',
                  style: Components.kBodyOne(context)
                      ?.copyWith(color: kPrimaryColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: kPrimaryColor)),
              )
            ],
          ),
        )),
        cartCounter(
            context: context,
            quantity: cubit.cartQuantity[index],
            incrementColor:
                cubit.cartQuantity[index] == int.parse(cart.maxQuantity!)
                    ? Colors.grey
                    : kPrimaryColor,
            decrementColor:
                cubit.cartQuantity[index] == 1 ? Colors.grey : kPrimaryColor,
            increment: () {
              cubit.increment(int.parse(cart.maxQuantity!), index);
            },
            decrement: () {
              cubit.decrement(int.parse(cart.maxQuantity!), index);
            })
      ],
    );
  }

  Widget cartCounter(
      {required BuildContext context,
      required int quantity,
      required Color incrementColor,
      required Color decrementColor,
      required Function() increment,
      required Function() decrement}) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          height: Components.kHeight(context) * 0.04,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.4))),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: decrement,
                child: Icon(
                  Icons.remove_circle_outline,
                  color: decrementColor,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '$quantity',
                style: Components.kBodyOne(context),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: increment,
                child: Icon(
                  Icons.add_circle,
                  color: incrementColor,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }

  Widget buyButton(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        'Buy Now',
        style: Components.kBodyOne(context)?.copyWith(color: Colors.white),
      ),
    );
  }
}
