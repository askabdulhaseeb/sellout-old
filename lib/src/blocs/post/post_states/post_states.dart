class PostStates {}

class PostInitialState extends PostStates {}

class PostAddPostLoadingState extends PostStates {}

class PostAddPostSuccessState extends PostStates {}

class PostAddPostErrorState extends PostStates {
  final String error;
  PostAddPostErrorState(this.error);
}

class PostGetPostsLoadingState extends PostStates {}

class PostGetPostsSuccessState extends PostStates {}

class PostGetPostsErrorState extends PostStates {
  final String error;
  PostGetPostsErrorState(this.error);
}

class PostGeCategoriesSuccessState extends PostStates {}

class PostChangePageIndexSuccessState extends PostStates {}

class PostGeCategoriesErrorState extends PostStates {
  final String error;
  PostGeCategoriesErrorState(this.error);
}

class PostPickMediaSuccessState extends PostStates {}

class PostPickMediaErrorState extends PostStates {
  final String error;
  PostPickMediaErrorState(this.error);
}

class PostUploadMediaLoadingState extends PostStates {}

class PostUploadMediaSuccessState extends PostStates {}

class PostUploadPostSuccessState extends PostStates {}

class PostUploadMediaErrorState extends PostStates {
  final String error;
  PostUploadMediaErrorState(this.error);
}

class PostPickUserLocationSuccessState extends PostStates {}

class PostPickUserLocationErrorState extends PostStates {
  final String error;
  PostPickUserLocationErrorState(this.error);
}

class PostAddOfferLoadingState extends PostStates {}

class PostAddOfferSuccessState extends PostStates {}

class PostAddOfferErrorState extends PostStates {
  final String error;
  PostAddOfferErrorState(this.error);
}

class PostDeleteMediaSuccessState extends PostStates {}

class PostCurrentMediaChangedState extends PostStates {}

class PostIsLastMediaState extends PostStates {}

class PostMakeOfferState extends PostStates {}

class PostQuantityIncrementState extends PostStates {}

class PostQuantityDecrementState extends PostStates {}

class PostPriceIncrementState extends PostStates {}

class PostPriceDecrementState extends PostStates {}

class PostAddToCartLoadingState extends PostStates {}

class PostAddToCartSuccessState extends PostStates {}

class PostAddToCartErrorState extends PostStates {
  final String error;
  PostAddToCartErrorState(this.error);
}

class PostHideUserSuccessState extends PostStates {}

class PostHideUserErrorState extends PostStates {
  final String error;
  PostHideUserErrorState(this.error);
}

class PostGetHiddenUsersSuccessState extends PostStates {}

class PostGetHiddenUsersErrorState extends PostStates {
  final String error;
  PostGetHiddenUsersErrorState(this.error);
}

class PostIsUserBlockedState extends PostStates {}
