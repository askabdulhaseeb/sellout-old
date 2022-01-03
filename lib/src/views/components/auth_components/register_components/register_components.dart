import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/auth/login_screen.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/auth/auth_text.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:sellout_team/src/views/widgets/auth/elevated_container.dart';
import 'package:sellout_team/src/views/widgets/auth/field_label.dart';
import 'package:sellout_team/src/views/widgets/auth/text_form_field_widget.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterComponents {
  static Widget logoSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        'assets/images/sellout_logo/sellout_logo.png',
        width: 120,
        height: 120,
      ),
    );
  }

  static Widget registerSection({
    required BuildContext context,
    required AuthCubit cubit,
    required AuthStates state,
    required formKey,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController dobController,
    required TextEditingController genderController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
    required TextEditingController phoneController,
  }) {
    return Form(
      key: formKey,
      child: ElevatedContainer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(text: 'Name'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: nameController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Username'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: usernameController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Date of Birth'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: dobController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Gender'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: genderController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Mobile Number'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: phoneController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Email address'),
                const SizedBox(height: 6),
                TextFormFieldWidget(controller: emailController),
                const SizedBox(height: 6),
                FieldLabel(text: 'Password'),
                const SizedBox(height: 6),
                SizedBox(
                  height: Components.kHeight(context) * 0.05,
                  child: TextFormFieldWidget(
                    controller: passwordController,
                    isPassword: cubit.isObsecure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.isObsecure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        cubit.onChanged();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                state is AuthRegisterLoadingState
                    ? CircularIndicator()
                    : DefaultButtonWidget(
                        text: 'Register',
                        isSmallerHeight: true,
                        isTextWeightThick: false,
                        function: () {
                          if (formKey.currentState!.validate()) {
                            cubit.register(
                              name: nameController.text,
                              username: usernameController.text,
                              phoneNumber: phoneController.text,
                              email: emailController.text,
                              passwords: passwordController.text,
                              type: "form",
                              userImg: "",
                            );
                          }
                        },
                        color: kPrimaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  static Widget lastSection(
      {required BuildContext context,
      required AuthCubit cubit,
      required AuthStates state}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthText(
            sentence: 'Already have a user?',
            text: 'Sign in',
            function: () {
              Components.navigateTo(context, const Login());
            }),
        Components.kDivider,
        GestureDetector(
          onTap: () {
            String url =
                "https://app.termly.io/document/terms-of-use-for-ios-app/0ba486f6-86c7-48c7-a116-f8c5aa4017cc";
            _launchURL(url);
          },
          child: const Text(
              'By registrating you accept Customer Agreement conditions and Privacy Policy and accept all risks inherent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                // decoration: TextDecoration.underline,
              )),
        )
      ],
    );
  }
}
