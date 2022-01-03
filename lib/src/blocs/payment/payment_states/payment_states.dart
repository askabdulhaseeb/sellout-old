class PaymentStates {}

class PaymentIntiailState extends PaymentStates {}

class PaymentSuccessState extends PaymentStates {
  final String transactionID;
  final  String payedBy;
  final  String amount;
  final  String date;
  PaymentSuccessState(this.transactionID, this.payedBy, this.amount, this.date);
}

class PaymentFailure extends PaymentStates {
  final String error;
  PaymentFailure(this.error);
}

class PaymentLoadingState extends PaymentStates {}

