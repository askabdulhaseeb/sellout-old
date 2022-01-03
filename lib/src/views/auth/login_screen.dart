import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/views/components/auth_components/login_components/login_components.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/nav_bar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoginErrorState) {
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthLoginSuccessState) {
          CacheHelper.setString(key: 'uid', value: state.uid).then(
            (value) async {
              kUid = state.uid;
              print('id is $kUid');
              //String uid = CacheHelper.getString('id');
              if (kUserMap == null && CacheHelper.getString('user') != null) {
                //kUserMap = json.decode(CacheHelper.getString('user'));
                //kUserModel = UserModel.fromFirebase(kUserMap);
              }
              Components.navigateAndRemoveUntil(context, NavBar());
            },
          );
        }
        if (state is AuthLoginWithGoogleErrorState) {
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthLoginWithGoogleSuccessState) {
          CacheHelper.setString(key: 'uid', value: state.uid).then((value) {
            kUid = state.uid;
            Components.navigateAndRemoveUntil(context, NavBar());
          });
        }
        if (state is AuthLoginWithFacebookErrorState) {
          Components.kSnackBar(context, state.error);
        }
        if (state is AuthLoginWithFacebookSuccessState) {
          CacheHelper.setString(key: 'uid', value: state.uid).then((value) {
            kUid = state.uid;
            Components.navigateAndRemoveUntil(context, NavBar());
          });
        }
        if (state is AuthRegisterErrorState) {
          Components.kSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Components.kWidth(context) * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Components.kHeight(context) * 0.32,
                      child: LoginComponents.logo(context),
                    ),
                    SizedBox(
                      height: Components.kHeight(context) * 0.38,
                      child: LoginComponents.loginField(
                        context: context,
                        cubit: cubit,
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey,
                        state: state,
                      ),
                    ),
                    SizedBox(
                      height: Components.kHeight(context) * 0.25,
                      child: LoginComponents.buttonsSection(
                        context,
                        cubit,
                        state,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
