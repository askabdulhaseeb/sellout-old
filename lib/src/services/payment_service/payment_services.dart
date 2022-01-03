import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sellout_team/src/services/configs/payment_configs.dart';
import 'package:http/http.dart' as http;
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/liveBid/liveBidScreen.dart';
import 'package:sellout_team/src/views/navBar/cart/paymentSuccess.dart';

class PaymentServices {
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentApiUrl = apiURL + '/payment_intents';

  static Map<String, String> headers = {
    'Authorization':
        'Bearer sk_test_51JbRDzKw3lWksVUwwRX6KjTd6kVp9ZTH2nFSNEChvusbsqU0NP3Gb6MxWXdITtuJt1WNkWfbelE2brVFo3vUi0uO002rFDAQzA',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(paymentApiUrl), //api url
          body: {
            'amount':
                amount, // amount charged will be specified when the method is called
            'currency': currency, // the currency
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

      await Stripe.instance.presentPaymentSheet();

      //Components.navigateTo(context, PaymentSuccess());

      //debugPrint(jsonResponse); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  Future<void> checkout(BuildContext context) async {
    await createPaymentIntent("100", "USD", context);

    /// retrieve data from the backend
    //createPaymentIntent("100", "USD");
  }
}
