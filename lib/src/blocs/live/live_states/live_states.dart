class LiveStates {}

class LiveIntiailState extends LiveStates {}

class LiveSuccessState extends LiveStates {
  final String id;
  final  String message;
  final String channelName;
  LiveSuccessState(this.id, this.message, this.channelName);
}

class LiveFailure extends LiveStates {
  final String error;
  LiveFailure(this.error);
}

class LiveLoadingState extends LiveStates {}

