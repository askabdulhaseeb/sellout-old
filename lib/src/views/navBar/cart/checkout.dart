import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sellout_team/src/blocs/payment/payment_cubit/payment_cubit.dart';
import 'package:sellout_team/src/blocs/payment/payment_states/payment_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/services/payment_service/payment_services.dart';
import 'package:sellout_team/src/services/paypal_services/paypalPayment.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/cart/paymentSuccess.dart';
import 'package:sellout_team/src/views/widgets/auth/text_form_field_widget.dart';
import 'package:http/http.dart' as http;

import '../nav_bar.dart';

class CheckOut extends StatefulWidget {
  PostModel postModel;
   CheckOut({Key? key, required this.postModel}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final phoneNameController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentStates>(listener: (context, state) {
      if (state is PaymentLoadingState) {

      }
      if (state is PaymentSuccessState) {

        Components.navigateTo(context, PaymentSuccess(
            amount: state.amount,
            transactionId: state.transactionID,
            payedBy: state.payedBy,
            transactionDate: state.date));
        //Components.navigateAndRemoveUntil(context, NavBar());
      }
      if (state is PaymentFailure) {
        print(state.error);
        Components.kSnackBar(context, '${state.error}');
      }

    }, builder: (context, state) {
    var cubit = PaymentCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      imagebaseURL+widget.postModel.images![0].imageUrl.toString(),
                      height: 200,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        widget.postModel.content.toString(),
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "\$"+ widget.postModel.price.toString(),
                        style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Contact Information",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "PHONE",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(

                controller: phoneNameController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "ADDRESS",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                controller: addressController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "NAME",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormFieldWidget(
                controller: nameController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "SELECT A PAYMENT METHOD",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PaypalPayment(
                                    price: "300",
                                    onFinish: (number) async {
                                      // payment done
                                      print('order id: ' + number);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    K_PAYPAL,
                                    width: 100,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'PAYPAL',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        GestureDetector(
                            onTap: () async {
                              cubit.checkOut(userId: kUserModel!.id.toString(),
                                  address: addressController.text.toString(),
                                  name: nameController.text.toString(), phone: phoneNameController.text.toString(),
                                  postModel: widget.postModel);
                             //await createPaymentIntent(widget.postModel.price.toString(), "USD", context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    K_STRIPE,
                                    width: 100,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'STRIPE',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    });
  }
}
