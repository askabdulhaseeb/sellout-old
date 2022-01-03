import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/blocs/payment/payment_states/payment_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/helper/cache_helper.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:http/http.dart' as http;

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentIntiailState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  bool isObsecure = true;

  onChanged() {
    isObsecure = !isObsecure;

  }

  checkOut(
      {
        required String userId,
      required String address,
      required String name,
       required String phone,
        required PostModel postModel
      }) async {
    emit(PaymentLoadingState());

     String apiURL = 'https://api.stripe.com/v1';
     String paymentApiUrl = apiURL + '/payment_intents';

     Map<String, String> headers = {
      'Authorization':
      'Bearer sk_test_51JbRDzKw3lWksVUwwRX6KjTd6kVp9ZTH2nFSNEChvusbsqU0NP3Gb6MxWXdITtuJt1WNkWfbelE2brVFo3vUi0uO002rFDAQzA',
      'Content-Type': 'application/x-www-form-urlencoded'
    };


      try {
        var response = await http.post(Uri.parse(paymentApiUrl), //api url
            body: {
              'amount':
              postModel.price, // amount charged will be specified when the method is called
              'currency': "USD", // the currency
            }, //request body
            headers: headers //headers of the request specified in the base class
        );


        Map<String, dynamic> map = json.decode(response.body);

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              testEnv: true,
              merchantCountryCode: 'DE',
              merchantDisplayName: 'SAIN ENTERPRISES',
              paymentIntentClientSecret: map['client_secret'],
              //customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
            ));

        try {
          // 3. display the payment sheet.
          await Stripe.instance.presentPaymentSheet();
          paymentCheckOut(userId, address, name, phone, postModel,  map['id']);

        } on Exception catch (e) {
          if (e is StripeException) {
            emit(PaymentFailure('Error from Stripe: ${e.error.localizedMessage}'));
          } else {
            emit(PaymentFailure('Unforeseen error: ${e}'));
          }

      }

      } catch (error) {
        print('Error occured : ${error.toString()}');
      }

  }

  paymentCheckOut( String userId,
   String address,
   String name,
   String phone,
   PostModel postModel, String transactionId) async {
    var url = baseURL + kPayments;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy hh:mm:aa');
      String transactionDate = formatter.format(now);

      final response = await http.post(Uri.parse(url), body: {
        "postId": postModel.id,
        "postOwnerId": postModel.userId,
        "userId": userId,
        "address": address,
        "name": name,
        "phone":phone,
        "transactionId": transactionId,
        "paymentStatus": "1",
        "transactionDate": transactionDate,
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(PaymentFailure(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        emit(PaymentSuccessState(transactionId, name,  postModel.price.toString(),transactionDate));
      }
    } catch (error) {
      throw (error);
    }
  }


}
