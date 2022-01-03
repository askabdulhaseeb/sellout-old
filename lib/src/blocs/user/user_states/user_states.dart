class UserStates {}

class UserInitialState extends UserStates {}

class UserGetCurrentUserSuccessState extends UserStates {}

class UserGetCurrentUserErrorState extends UserStates {
  final String error;
  UserGetCurrentUserErrorState(this.error);
}

class UserChangeUserPhotoSuccessState extends UserStates {}

class UserChangeUserPhotoErrorState extends UserStates {
  final String error;
  UserChangeUserPhotoErrorState(this.error);
}

class UserprivacyChangedState extends UserStates {}

class UserUpdateUserInfoLoadingState extends UserStates {}

class UserAddUserInfoSuccessState extends UserStates {}

class UserAddUserInfoErrorState extends UserStates {
  final String error;
  UserAddUserInfoErrorState(this.error);
}

class UserUpdateUserInfoSuccessState extends UserStates {}

class UserUpdateUserInfoErrorState extends UserStates {
  final String error;
  UserUpdateUserInfoErrorState(this.error);
}

class UserGetUserInfoLoadingState extends UserStates {}

class UserGetUserInfoSuccessState extends UserStates {}

class UserGetUserInfoErrorState extends UserStates {
  final String error;
  UserGetUserInfoErrorState(this.error);
}

class UserGetPostsForCurrentUserLoadingState extends UserStates {}

class UserGetPostsForCurrentUserSuccessState extends UserStates {}

class UserGetPostsForCurrentUserErrorState extends UserStates {
  final String error;
  UserGetPostsForCurrentUserErrorState(this.error);
}

class UserGetPostByIdLoadingState extends UserStates {}

class UserGetPostByIdSuccessState extends UserStates {}

class UserGetPostByIdErrorState extends UserStates {
  final String error;
  UserGetPostByIdErrorState(this.error);
}

class UserChangePageIndexSuccessState extends UserStates {}

class UserTabBarIndexChanged extends UserStates {}

class UserGetCategoriesSuccessState extends UserStates {}

class UserGetCategoriesErrorState extends UserStates {
  final String error;
  UserGetCategoriesErrorState(this.error);
}

class UserCategorySelectedState extends UserStates {}

class UserGetPostsByCategoryLoadingState extends UserStates {}

class UserGetPostsByCategorySuccessState extends UserStates {}

class UserGetPostsByCategoryErrorState extends UserStates {
  final String error;
  UserGetPostsByCategoryErrorState(this.error);
}

class UserSignOutLoadingState extends UserStates {}

class UserSignOutSuccessState extends UserStates {}

class UserSignOutErrorState extends UserStates {
  final String error;
  UserSignOutErrorState(this.error);
}

class UserGetOtherUserDataSuccessState extends UserStates {}

class UserGetOtherUserDataErrorState extends UserStates {
  final String error;
  UserGetOtherUserDataErrorState(this.error);
}

class UserGetCartLoadingState extends UserStates {}

class UserGetCartSuccessState extends UserStates {}

class UserGetCartErrorState extends UserStates {
  final String error;
  UserGetCartErrorState(this.error);
}

class UserDeleteCartItemLoadingState extends UserStates {}

class UserDeleteCartItemSuccessState extends UserStates {}

class UserDeleteCartItemErrorState extends UserStates {
  final String error;
  UserDeleteCartItemErrorState(this.error);
}

class UserUpdateCartItemLoadingState extends UserStates {}

class UserUpdateCartItemSuccessState extends UserStates {}

class UserUpdateCartItemErrorState extends UserStates {
  final String error;
  UserUpdateCartItemErrorState(this.error);
}

class UserCartQuantityIncrementSuccessState extends UserStates {}

class UserCartQuantitydecrementSuccessState extends UserStates {}

class UserPostByIdQuantityIncrementSuccessState extends UserStates {}

class UserPostByIdQuantityDecrementSuccessState extends UserStates {}

class UserPostByIdPriceIncrementSuccessState extends UserStates {}

class UserPostByIdPriceDecrementSuccessState extends UserStates {}

class UserOfferPressedState extends UserStates {}

class UserAddSupportLoadingState extends UserStates {}

class UserAddSupportSuccessState extends UserStates {}

class UserAddSupportErrorState extends UserStates {
  final String error;
  UserAddSupportErrorState(this.error);
}

class UserGetSupportLoadingState extends UserStates {}

class UserGetSupportSuccessState extends UserStates {}

class UserGetSupportErrorState extends UserStates {
  final String error;
  UserGetSupportErrorState(this.error);
}

class UserDeleteSupportLoadingState extends UserStates {}

class UserDeleteSupportSuccessState extends UserStates {}

class UserDeleteSupportErrorState extends UserStates {
  final String error;
  UserDeleteSupportErrorState(this.error);
}

class UserIsUserSupportingState extends UserStates {}

class UserSendReportSuccessState extends UserStates {}

class UserSendReportErrorState extends UserStates {
  final String error;
  UserSendReportErrorState(this.error);
}

class UserBlockUserSuccessState extends UserStates {}

class UserBlockUserErrorState extends UserStates {
  final String error;
  UserBlockUserErrorState(this.error);
}

