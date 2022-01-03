import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/auth/login_screen.dart';
import 'package:sellout_team/src/views/auth/register_screen.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(K_SPLASH),
            fit: BoxFit.fill,
            onError: (child, StackTrace? track) {
              const Icon(Icons.broken_image);
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 40,
              ),
              DefaultButtonWidget(
                text: 'Log in',
                color: Colors.white,
                function: () {
                  Components.navigateAndRemoveUntil(context, Login());
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DefaultButtonWidget(
                text: 'Register',
                color: kPrimaryColor,
                hasBorder: true,
                function: () {
                  Components.navigateAndRemoveUntil(context, Register());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
