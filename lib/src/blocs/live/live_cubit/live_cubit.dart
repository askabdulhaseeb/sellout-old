import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/blocs/live/live_states/live_states.dart';
import 'package:sellout_team/src/blocs/payment/payment_states/payment_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:http/http.dart' as http;

class LiveCubit extends Cubit<LiveStates> {
  LiveCubit() : super(LiveIntiailState());

  static LiveCubit get(context) => BlocProvider.of(context);

  bool isObsecure = true;

  onChanged() {
    isObsecure = !isObsecure;

  }


  createLiveBid(String description,
   String name,
   String startingPrice,
   String privacy,
   ) async {
    var url = baseURL + kCreateLiveBid;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(Uri.parse(url), body: {
        "userId": kUserModel!.id.toString(),
        "itemDescription": description,
        "name": name,
        "startingPrice": startingPrice,
        "privacy": privacy,
        "channelName": "channel_"+name.toLowerCase().replaceAll(" ", "_"),
        "status": "1",

      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        emit(LiveFailure(responseData["message"]));
        throw HttpException(responseData["message"]);
      } else {
        emit(LiveSuccessState(responseData["data"].toString(), responseData["message"], "channel_"+name.toLowerCase().replaceAll(" ", "_")));
      }
    } catch (error) {
      throw (error);
    }
  }
}
