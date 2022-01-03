import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/views/auth/forgotpasswordUpdatePassword.dart';
import 'package:sellout_team/src/views/auth/login_screen.dart';
import 'package:sellout_team/src/views/components/auth_components/forgot_password_components/forgot_password_components.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/auth/auth_text.dart';

class ForgotPasswordOTP extends StatefulWidget {

  String emailAddress;

  ForgotPasswordOTP({Key? key, required this.emailAddress}) : super(key: key);

  @override
  _ForgotPasswordOTPState createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {

  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthForgotPasswordErrorState) {
          print(state.error);
          Components.kSnackBar(context, '${state.error}');
        }
        if (state is AuthForgotPasswordOTPSuccessState) {
          Components.kSnackBar(
              context, state.message);
          Components.navigateTo(context, ForgotPasswordUpdatePassword(id: state.id));
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: Components.kHeight(context) * 0.3,
                      child: ForgotPasswordComponents.logo(context)),
                  Container(
                      height: Components.kHeight(context) * 0.45,
                      child: ForgotPasswordComponents.confirmOTP(
                        context: context,
                        cubit: cubit,
                        otpController: otpController,
                        formKey: formKey,
                        emailAddress: widget.emailAddress
                      )),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
