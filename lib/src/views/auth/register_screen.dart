import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/views/auth/login_screen.dart';
import 'package:sellout_team/src/views/components/auth_components/register_components/register_components.dart';
import 'package:sellout_team/src/views/components/components.dart';

class Register extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Register({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthRegisterErrorState) {
          print(state.error);
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthRegisterSuccessState) {
          Components.navigateAndRemoveUntil(context, Login());
        }
        if (state is AuthRegisterVerificationSentState) {
          Components.kSnackBar(context, 'please verifiy your account');
          Components.navigateAndRemoveUntil(context, Login());
        }
        if (state is AuthLoginWithGoogleErrorState) {
          print(state.error);
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthLoginWithGoogleSuccessState) {
          CacheHelper.setString(key: 'uid', value: state.uid).then((value) {
            Components.navigateAndRemoveUntil(context, Login());
          });
        }
        if (state is AuthLoginWithFacebookErrorState) {
          print(state.error);
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthLoginWithFacebookSuccessState) {
          CacheHelper.setString(key: 'uid', value: state.uid).then((value) {
            Components.navigateAndRemoveUntil(context, Login());
          });
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: Components.kHeight(context),
                width: Components.kWidth(context) * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          height: Components.kHeight(context) * 0.2,
                          child: RegisterComponents.logoSection(context),
                        ),
                      ),
                      SizedBox(
                        height: Components.kHeight(context) * 0.52,
                        child: RegisterComponents.registerSection(
                          context: context,
                          cubit: cubit,
                          formKey: formKey,
                          emailController: emailController,
                          nameController: nameController,
                          passwordController: passwordController,
                          usernameController: usernameController,
                          phoneController: phoneController,
                          state: state,
                        ),
                      ),
                      SizedBox(
                        height: Components.kHeight(context) * 0.2,
                        child: RegisterComponents.lastSection(
                          context: context,
                          cubit: cubit,
                          state: state,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
