import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_states/user_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:sellout_team/src/views/widgets/post/labeled_radio.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var nameController = TextEditingController();

  var userNameController = TextEditingController();

  var bioController = TextEditingController();

  var categoryController = TextEditingController();

  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    bioController.dispose();
    categoryController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = '${UserCubit.get(context).userInfoModel?.data!.name}';
    userNameController.text =
        UserCubit.get(context).userInfoModel!.data!.username!;
    bioController.text = UserCubit.get(context).userInfoModel!.data!.biography!;
    categoryController.text =
        UserCubit.get(context).userInfoModel!.data!.category!;
    phoneController.text = UserCubit.get(context).userInfoModel!.data!.phone!;
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserChangeUserPhotoErrorState) {
          Components.kSnackBar(context, state.error);
        }

        if (state is UserUpdateUserInfoSuccessState ||
            state is UserAddUserInfoSuccessState) {
          Components.kSnackBar(context, 'your data has been updated!',
              isSuccess: true);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: kPrimaryColor),
            title: Text(
              'Edit Profile',
              style: Components.kHeadLineSix(context)
                  ?.copyWith(color: kPrimaryColor),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Container(
                    height: Components.kHeight(context) * 0.2,
                    child: photoSection(cubit, context),
                  ),
                  Container(
                    height: Components.kHeight(context) * 0.55,
                    margin: const EdgeInsets.all(8),
                    child: fieldsSection(context, cubit),
                  ),
                  Container(
                    height: Components.kHeight(context) * 0.05,
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: state is UserUpdateUserInfoLoadingState
                        ? CircularIndicator()
                        : saveButton(context, cubit),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget saveButton(BuildContext context, UserCubit cubit) {
    return MaterialButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          try {
            await cubit.updateUserInfo(
                name: nameController.text,
                userName: userNameController.text,
                bio: bioController.text,
                category: categoryController.text,
                phone: phoneController.text);
          } catch (error) {
            print('$error');
          }
        }
      },
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        'Save',
        style: Components.kBodyOne(context)?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget fieldsSection(BuildContext context, UserCubit cubit) {
    return ListView(
      children: [
        editField(context: context, text: 'Name', controller: nameController),
        editField(
            context: context,
            text: 'Username',
            controller: userNameController,
            hint: cubit.userInfoModel!.data!.username!.isEmpty
                ? ' username'
                : ''),
        editField(
            context: context,
            text: 'Bio',
            controller: bioController,
            hint:
                cubit.userInfoModel!.data!.biography!.isEmpty ? 'Bio....' : ''),
        editField(
            context: context,
            text: 'Category',
            controller: categoryController,
            hint: cubit.userInfoModel!.data!.category!.isEmpty
                ? 'Shopping....'
                : ''),
        editField(
            context: context,
            text: 'Phone Number',
            controller: phoneController,
            hint: cubit.userInfoModel!.data!.phone!.isEmpty ? '00000000' : ''),
        Container(
          height: Components.kHeight(context) * 0.1,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          decoration: Components.kElevatedContainer,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Profile Display',
                style: Components.kBodyOne(context),
              )),
              Expanded(
                  child: LabeledRadio(
                      label: 'Public',
                      padding: const EdgeInsets.all(2),
                      groupValue: cubit.isPublic,
                      value: true,
                      onChanged: (value) {
                        cubit.onPrivacyChanged(value);
                      })),
              Expanded(
                  child: LabeledRadio(
                      label: 'Private',
                      padding: const EdgeInsets.all(2),
                      groupValue: cubit.isPublic,
                      value: false,
                      onChanged: (value) {
                        cubit.onPrivacyChanged(value);
                      }))
            ],
          ),
        ),
      ],
    );
  }

  Widget photoSection(UserCubit cubit, BuildContext context) {
    return Column(
      children: [
        cubit.photo != null
            ? CircleAvatar(
                backgroundImage: FileImage(cubit.photo!),
                radius: 50,
              )
            : CircleAvatar(
                backgroundImage:
                    NetworkImage('${cubit.userInfoModel?.data!.userimg}'),
                radius: 50,
              ),
        const SizedBox(
          height: 4,
        ),
        InkWell(
          onTap: () {
            cubit.changeProfilePhoto();
          },
          child: Text(
            'Change profile photo',
            style: Components.kCaption(context)
                ?.copyWith(decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  Widget editField(
      {required BuildContext context,
      required String text,
      String hint = '',
      required TextEditingController controller}) {
    return Container(
      height: Components.kHeight(context) * 0.08,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(10),
      decoration: Components.kElevatedContainer,
      child: Row(
        children: [
          Expanded(
              child: Text(
            '$text',
            style: Components.kBodyOne(context),
          )),
          Expanded(
              child: TextFormField(
            style: Components.kBodyOne(context)
                ?.copyWith(fontWeight: FontWeight.normal),
            controller: controller,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: '$hint'),
          ))
        ],
      ),
    );
  }
}
