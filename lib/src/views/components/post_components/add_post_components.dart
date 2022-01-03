import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/view_image.dart';
import 'package:sellout_team/src/views/navBar/post/video_file/post_video_file.dart';
import 'package:sellout_team/src/views/widgets/images/chat_circle_image_widget.dart';
import 'package:sellout_team/src/views/widgets/post/add_media_container_widget.dart';
import 'package:sellout_team/src/views/widgets/post/remove_media_widget.dart';

class AddPostComponents {
  static Widget userPhotoAndPostSection(
      {required BuildContext context,
      required TextEditingController contentController}) {
    return Container(
      height: Components.kHeight(context) * 0.1,
      width: Components.kWidth(context) * 0.95,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor),
                shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('${kUserModel?.image}'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: Components.kWidth(context) * 0.65,
            height: Components.kHeight(context) * 0.05,
            child: TextFormField(
              maxLines: 2,
              controller: contentController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'field must not be empty!';
                }
              },
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                isDense: true,
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                hintText: "What are you selling....?",
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget addMediaSection(
      {required PostCubit cubit, required BuildContext context}) {
    return Container(
      height: Components.kHeight(context) * 0.34,
      //width: Components.kWidth(context),
      child: Column(
        children: [
          Container(
            height: Components.kHeight(context) * 0.2,
            // width: Components.kWidth(context),
            // decoration: BoxDecoration(
            //     border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: cubit.pickedMedia.isNotEmpty
                ? Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      InkWell(
                          onTap: () {
                            //onMediaTapped(0, cubit);
                          },
                          child: mediaContent(cubit)),
                      RemoveMediaWidget(function: () {
                        cubit.deletePickedMedia(0);
                      }),
                    ],
                  )
                : InkWell(
                    onTap: () {
                      cubit.pickMedia();
                    },
                    child: AddMediaContainerWidget(),
                  ),
          ),
          Components.kDivider,
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                scrollDirection: Axis.horizontal,
                itemCount: cubit.pickedMedia.isNotEmpty
                    ? cubit.pickedMedia.length - 1
                    : 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      //  onMediaTapped(index + 1, cubit);
                    },
                    child: Container(
                      width: Components.kWidth(context) * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: cubit.pickedMedia.isNotEmpty
                          ? Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                contentMediaList(
                                    context: context,
                                    extension: cubit.extensions[index + 1],
                                    pickedMedia: cubit.pickedMedia[index + 1]),
                                RemoveMediaWidget(function: () {
                                  cubit.deletePickedMedia(index);
                                }),
                              ],
                            )
                          : SizedBox(),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  static addPostMethod({
    required PostCubit cubit,
    required BuildContext context,
    required formKey,
    required String category,
    required TextEditingController contentController,
    required TextEditingController descriptionController,
    required int quantity,
    required TextEditingController priceController,
    required bool isItemNew,
    required bool isAcceptOffers,
    required bool isCollection,
  }) async {
    if (cubit.pickedMedia.isEmpty) {
      Components.kSnackBar(context, 'Pick some photos!');
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (cubit.pickedMedia.isNotEmpty) {
        await cubit.uploadMedia(
          category: category,
          content: contentController.text,
          description: descriptionController.text,
          quantity: quantity.toString(),
          location: cubit.userPosition?.latitude != null
              ? GeoPoint(
                  cubit.userPosition!.latitude, cubit.userPosition!.longitude)
              : GeoPoint(0, 0),
          price: priceController.text,
          isNew: isItemNew,
          isOffer: isAcceptOffers,
          isCollection: isCollection,
        );
      }
    }
  }

  static Widget mediaContent(PostCubit cubit) {
    if (cubit.extensions[0] == 'mp4') {
      return Container(
        child: Center(
          child: Icon(
            Icons.play_circle,
            size: 40,
            color: kPrimaryColor,
          ),
        ),
      );

      // VideoWidget(
      //   '',
      //   isFile: true,
      //   videoFile: cubit.pickedMedia[0],
      // );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image(
        image: FileImage(cubit.pickedMedia[0]),
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget contentMediaList(
      {required File pickedMedia,
      required String extension,
      required BuildContext context}) {
    if (extension == 'mp4') {
      return Container(
        child: Center(
          child: Icon(
            Icons.play_circle,
            size: 40,
            color: kPrimaryColor,
          ),
        ),
      );

      //  VideoWidget(
      //   '',
      //   isFile: true,
      //   videoFile: pickedMedia,
      // );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image(
        width: Components.kWidth(context) * 0.25,
        image: FileImage(pickedMedia),
        fit: BoxFit.fill,
      ),
    );
  }

  static void onMediaTapped(
      {required int index,
      required PostCubit cubit,
      required BuildContext context}) {
    if (cubit.extensions[index] == 'mp4') {
      Components.navigateTo(
          context,
          PostVideoFile(
            cubit.pickedMedia[index],
          ));
    }
    Components.navigateTo(
        context,
        ViewImage(
          '',
          isFile: true,
          imageFile: cubit.pickedMedia[index],
        ));
  }
}
