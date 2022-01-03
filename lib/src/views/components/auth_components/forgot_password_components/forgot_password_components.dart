import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:sellout_team/src/views/widgets/auth/elevated_container.dart';
import 'package:sellout_team/src/views/widgets/auth/field_label.dart';
import 'package:sellout_team/src/views/widgets/auth/text_form_field_widget.dart';

class ForgotPasswordComponents {
  static Widget logo(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        K_LOGO,
        width: 100,
        height: 100,
      ),
    );
  }

  static Widget resetPasswordField(
      {required BuildContext context,
      required AuthCubit cubit,
      required formKey,
      required TextEditingController emailController}) {
    return Form(
      key: formKey,
      child: ElevatedContainer(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(text: 'Email address'),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                // hint: 'Email',
                // icon: Icons.phone,
                controller: emailController,
                isPassword: false,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Please enter your email address to reset your password",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DefaultButtonWidget(
                text: 'Reset Password',
                isSmallerHeight: true,
                isTextWeightThick: false,
                function: () {
                  if (formKey.currentState!.validate()) {
                    cubit.forgotPassword(email: emailController.text);
                  }
                },
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget confirmOTP(
      {required BuildContext context,
        required AuthCubit cubit,
        required formKey,
        required TextEditingController otpController, required String emailAddress}) {
    return Form(
      key: formKey,
      child: ElevatedContainer(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(text: 'One Time Password'),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                // hint: 'Email',
                // icon: Icons.phone,
                controller: otpController,
                isPassword: false,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Please enter your OTP",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DefaultButtonWidget(
                text: 'Confirm OTP',
                isSmallerHeight: true,
                isTextWeightThick: false,
                function: () {
                  if (formKey.currentState!.validate()) {
                    cubit.confirmOTP(email: emailAddress, OTP: otpController.text.toString());
                  }
                },
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget updatePassword(
      {required BuildContext context,
        required AuthCubit cubit,
        required formKey,
        required TextEditingController passwordController,
        required TextEditingController confirmPasswordController,
        required String id}) {
    return Form(
      key: formKey,
      child: ElevatedContainer(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(text: 'New Password'),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                // hint: 'Email',
                // icon: Icons.phone,
                controller: passwordController,
                isPassword: false,
              ),
              const SizedBox(
                height: 15,
              ),
              FieldLabel(text: 'Confirm Password'),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                // hint: 'Email',
                // icon: Icons.phone,
                controller: confirmPasswordController,
                isPassword: false,
              ),
              const SizedBox(
                height: 15,
              ),

              const SizedBox(
                height: 20,
              ),
              DefaultButtonWidget(
                text: 'Submit',
                isSmallerHeight: true,
                isTextWeightThick: false,
                function: () {
                  if(passwordController.text.toString()!=confirmPasswordController.text.toString()){
                  }else{
                    debugPrint(id);
                    if (formKey.currentState!.validate()) {
                      cubit.resetPassword(id: id, passwords: passwordController.text.toString());
                    }
                  }

                },
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
