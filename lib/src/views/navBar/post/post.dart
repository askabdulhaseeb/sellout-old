import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/blocs/post/post_states/post_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/category_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/components/post_components/add_post_components.dart';
import 'package:sellout_team/src/views/navBar/nav_bar.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:sellout_team/src/views/widgets/post/labeled_radio.dart';
import 'package:sellout_team/src/views/widgets/post/post_text_form_field.dart';

class AddPost extends StatefulWidget {
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  int currentIndex = 0;
  int quantityIndex = 0;
  String dropDownValue = '';
  bool isItemNew = false;
  bool isAcceptOffers = false;
  bool isCollection = false;
  final descriptionController = TextEditingController();
  final contentController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) async {
        if (state is PostPickUserLocationErrorState) {
          Components.kSnackBar(context, state.error);
        }
        if (state is PostPickUserLocationSuccessState) {
          Components.kSnackBar(context, 'Got location successfully!',
              isSuccess: true);
        }
        if (state is PostAddPostSuccessState) {
          Components.kSnackBar(context, 'Post added!', isSuccess: true);
          await PostCubit.get(context).getPosts();
          Components.navigateAndRemoveUntil(context, NavBar());
        }
      },
      builder: (context, state) {
        var cubit = PostCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(
              'Add Post',
              style: Components.kHeadLineSix(context)
                  ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  height: Components.kHeight(context) * 0.68,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.5),
                    //     blurRadius: 2.0,
                    //     spreadRadius: 0.0,
                    //     offset: Offset(
                    //         2.0, 2.0), // shadow direction: bottom right
                    //   )
                    // ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity:
                              state is PostUploadMediaLoadingState ? 0.5 : 1,
                          child: ListView(
                            children: [
                              AddPostComponents.userPhotoAndPostSection(
                                  context: context,
                                  contentController: contentController),
                              Components.kDivider,
                              AddPostComponents.addMediaSection(
                                  context: context, cubit: cubit),
                              Components.kDivider,
                              Text(
                                "Select the condition of your item : "
                                    .toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              itemConditionSection(),
                              Text(
                                "Description".toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              Components.kDivider,
                              PostTextFormField(descriptionController),
                              Components.kDivider,
                              Text(
                                "Category :".toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              Components.kDivider,
                              categorySection(cubit.categories),
                              Components.kDivider,
                              Text(
                                "Price".toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              Components.kDivider,
                              PostTextFormField(
                                priceController,
                                isOptional: isAcceptOffers ? true : false,
                                isNumber: true,
                              ),
                              Components.kDivider,
                              Text(
                                "Location :".toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              Components.kDivider,
                              InkWell(
                                onTap: () {
                                  cubit.getUserLocation();
                                },
                                child: PostTextFormField(
                                  locationController,
                                  isEnabled: false,
                                  isOptional: true,
                                  text: cubit.userCountry != null
                                      ? '${cubit.userLocality} ,${cubit.userCountry}'
                                      : '',
                                ),
                              ),
                              Components.kDivider,
                              offersSection(),
                              Components.kDivider,
                              Text(
                                "Quantity : ".toUpperCase(),
                                style: Components.kBodyOne(context),
                              ),
                              Components.kDivider,
                              qunatityCounter(),
                              Components.kDivider,
                              collectionAndDeliverySection(),
                              Components.kDivider,
                              Components.kDivider,
                              DefaultButtonWidget(
                                  text: 'post',
                                  function: () {
                                    AddPostComponents.addPostMethod(
                                        cubit: cubit,
                                        context: context,
                                        formKey: formKey,
                                        category: dropDownValue.isEmpty
                                            ? cubit.categories[0].id!
                                            : dropDownValue,
                                        contentController: contentController,
                                        descriptionController:
                                            descriptionController,
                                        quantity: quantityIndex,
                                        priceController: priceController,
                                        isItemNew: isItemNew,
                                        isAcceptOffers: isAcceptOffers,
                                        isCollection: isCollection);
                                  },
                                  color: kPrimaryColor),
                            ],
                          ),
                        ),
                        if (state is PostUploadMediaLoadingState)
                          Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget categorySection(List<CategoryModel> categories) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: DropdownButton(
          value: dropDownValue.isEmpty
              ? '${categories[0].categoryName}'
              : '$dropDownValue',
          items: categories.map((e) {
            return DropdownMenuItem(
              child: Text('${e.categoryName}'),
              value: '${e.categoryName}',
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              dropDownValue = value!;
            });
          },
        ),
      ),
    );
  }

  Widget qunatityCounter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (quantityIndex > 0) {
                    quantityIndex--;
                  }
                });
              },
              icon: Icon(
                Icons.remove_circle,
              )),
          Components.kVerticalDivider,
          Text(
            '$quantityIndex',
            style: Components.kHeadLineSix(context),
          ),
          Components.kVerticalDivider,
          IconButton(
              onPressed: () {
                setState(() {
                  quantityIndex++;
                });
              },
              icon: Icon(
                Icons.add_circle,
                color: kPrimaryColor,
              )),
        ],
      ),
    );
  }

  Widget collectionAndDeliverySection() {
    return Row(
      children: [
        LabeledRadio(
          label: 'Collections',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: true,
          groupValue: isCollection,
          onChanged: (bool newValue) {
            setState(() {
              isCollection = newValue;
            });
          },
        ),
        LabeledRadio(
          label: 'Delivery',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: false,
          groupValue: isCollection,
          onChanged: (bool newValue) {
            setState(() {
              isCollection = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget offersSection() {
    return Row(
      children: [
        Text(
          "Accept Offers".toUpperCase(),
          style: Components.kBodyOne(context),
        ),
        LabeledRadio(
          label: 'Yes',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: true,
          groupValue: isAcceptOffers,
          onChanged: (bool newValue) {
            setState(() {
              isAcceptOffers = newValue;
            });
          },
        ),
        LabeledRadio(
          label: 'No',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: false,
          groupValue: isAcceptOffers,
          onChanged: (bool newValue) {
            setState(() {
              isAcceptOffers = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget itemConditionSection() {
    return Row(
      children: [
        LabeledRadio(
          label: 'New',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: true,
          groupValue: isItemNew,
          onChanged: (bool newValue) {
            setState(() {
              isItemNew = newValue;
            });
          },
        ),
        LabeledRadio(
          label: 'Used',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          value: false,
          groupValue: isItemNew,
          onChanged: (bool newValue) {
            setState(() {
              isItemNew = newValue;
            });
          },
        ),
      ],
    );
  }
}
