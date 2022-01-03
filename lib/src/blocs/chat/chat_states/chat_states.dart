class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatTabBarIndexChanged extends ChatStates {}

class ChatSearchValueState extends ChatStates {}

class ChatSearchValueDeleteState extends ChatStates {}

class ChatGetSearchSuccessState extends ChatStates {}

class ChatGetUsersSuccessState extends ChatStates {}

class ChatGetUsersErrorState extends ChatStates {
  final String error;
  ChatGetUsersErrorState(this.error);
}

class ChatGetCurrentUserDataSuccessState extends ChatStates {}

class ChatGetCurrentUserDataErrorState extends ChatStates {
  final String error;
  ChatGetCurrentUserDataErrorState(this.error);
}

class ChatSendMessageLoadingState extends ChatStates {}

class ChatSendMessageSuccessState extends ChatStates {}

class ChatSendMessageErrorState extends ChatStates {
  final String error;
  ChatSendMessageErrorState(this.error);
}

class ChatGetMessagesLoadingState extends ChatStates {}

class ChatGetMessagesSuccessState extends ChatStates {}

class ChatCurrentUserChatsLoadingState extends ChatStates {}

class ChatCurrentUserChatsSuccessState extends ChatStates {}

class ChatCurrentUserChatsErrorState extends ChatStates {
  final String error;
  ChatCurrentUserChatsErrorState(this.error);
}

class ChatPickImageSuccessState extends ChatStates {}

class ChatPickImageErrorState extends ChatStates {
  final String error;
  ChatPickImageErrorState(this.error);
}

class ChatPickFileSuccessState extends ChatStates {}

class ChatPickFileErrorState extends ChatStates {
  final String error;
  ChatPickFileErrorState(this.error);
}

class ChatPickAdocSuccessState extends ChatStates {}

class ChatPickAdocErrorState extends ChatStates {
  final String error;
  ChatPickAdocErrorState(this.error);
}

class ChatPickUserLocationSuccessState extends ChatStates {}

class ChatPickUserLocationErrorState extends ChatStates {
  final String error;
  ChatPickUserLocationErrorState(this.error);
}

class ChatSendUserLocationSuccessState extends ChatStates {}

class ChatSendUserLocationErrorState extends ChatStates {
  final String error;
  ChatSendUserLocationErrorState(this.error);
}

class ChatCancelStreamState extends ChatStates {}

class ChatChooseStoriesSuccessState extends ChatStates {}

class ChatPickStoriesSuccessState extends ChatStates {}

class ChatPickStoriesErrorState extends ChatStates {
  final String error;
  ChatPickStoriesErrorState(this.error);
}

class ChatGetStoriesLoadingState extends ChatStates {}

class ChatGetStoriesSuccessState extends ChatStates {}

class ChatGetStoriesErrorState extends ChatStates {
  final String error;
  ChatGetStoriesErrorState(this.error);
}

class ChatAddGroupChatLoadingState extends ChatStates {}

class ChatAddGroupChatSuccessState extends ChatStates {}

class ChatAddGroupChatErrorState extends ChatStates {
  final String error;
  ChatAddGroupChatErrorState(this.error);
}

class ChatSendMessageToGroupChatSuccessState extends ChatStates {}

class ChatSendMessageToGroupChatErrorState extends ChatStates {
  final String error;
  ChatSendMessageToGroupChatErrorState(this.error);
}

class ChatDeleteChatSuccessState extends ChatStates {}

class ChatDeleteChatErrorState extends ChatStates {
  final String error;
  ChatDeleteChatErrorState(this.error);
}

class ChatIsUserBlockedState extends ChatStates {}
