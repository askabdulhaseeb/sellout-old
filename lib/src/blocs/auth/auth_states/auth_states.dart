class AuthStates {}

class AuthIntiailState extends AuthStates {}

class AuthOnSeenChangedState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterVerificationSentState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {}

class AuthRegisterErrorState extends AuthStates {
  final String error;
  AuthRegisterErrorState(this.error);
}

class AuthLoginErrorState extends AuthStates {
  final String error;
  AuthLoginErrorState(this.error);
}

class AuthLoginLoadingState extends AuthStates {}

class AuthLoginSuccessState extends AuthStates {
  final String uid;
  AuthLoginSuccessState(this.uid);
}

class AuthGetCurrentUserErrorState extends AuthStates {
  final String error;
  AuthGetCurrentUserErrorState(this.error);
}

class AuthGetCurrentUserLoadingState extends AuthStates {}

class AuthGetCurrentUserSuccessState extends AuthStates {

}

class AuthForgotPasswordErrorState extends AuthStates {
  final String error;
  AuthForgotPasswordErrorState(this.error);
}

class AuthForgotPasswordLoadingState extends AuthStates {}

class AuthForgotPasswordSuccessState extends AuthStates {}

class AuthForgotPasswordOTPSuccessState extends AuthStates {
  final String message;
  final String id;
  AuthForgotPasswordOTPSuccessState(this.message, this.id
      );
}

class AuthLoginWithGoogleErrorState extends AuthStates {
  final String error;
  AuthLoginWithGoogleErrorState(this.error);
}

class AuthLoginWithGoogleLoadingState extends AuthStates {}

class AuthLoginWithGoogleSuccessState extends AuthStates {
  final String uid;
  AuthLoginWithGoogleSuccessState(this.uid);
}

class AuthLoginWithFacebookErrorState extends AuthStates {
  final String error;
  AuthLoginWithFacebookErrorState(this.error);
}

class AuthLoginWithFacebookLoadingState extends AuthStates {}

class AuthLoginWithFacebookSuccessState extends AuthStates {
  final String uid;
  AuthLoginWithFacebookSuccessState(this.uid);
}
