
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import  'package:http/http.dart' as http;

class StripePayment {

  Map<String, dynamic>? paymentIntent;

  void makeStripePayment(packageId, finalPrice) async{

    try {
      paymentIntent = await createPaymentIntent(finalPrice);
      log('Stripe Payment Intent : $paymentIntent');

      // GPay payment sheet
      var gPay = const PaymentSheetGooglePay(
        merchantCountryCode: 'US',
        currencyCode: 'USD',
        buttonType: PlatformButtonType.pay,
        testEnv: true,
      );

      // Stripe init Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Tuhin', // TODO: Change this for original client merchant name
          googlePay: gPay,
        ),
      );

      // Display Stripe Payment Sheet
      displayPaymentSheet(packageId, finalPrice);

    }catch (e) {
      log('Stripe payment Error : $e');
    }
  }

  // Stripe display payment sheet
  void displayPaymentSheet(packageId, finalPrice) async {
    try {
      int uId = 1; // TODO: Change original user id

      await Stripe.instance.presentPaymentSheet();

      var url = Uri.parse("https://main.assalam.app/api/directPayment/$uId/$packageId/$finalPrice"); // TODO: Change original payment api
      var response = await http.post(url);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Payment successful");
        print("Payment successful ${response.body} and rest");
        // Update UI or notify user

         //  Get.off(BottomNaveBarPage());
          Fluttertoast.showToast(
            msg: 'Payment Successfull',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

      } else {
        Fluttertoast.showToast(msg: "Payment Failed");
        print("Payment Failed");
      }

    }catch (e) {
      if(e is StripeException) {
        // Handle Stripe-specific errors
        Fluttertoast.showToast(msg: "Payment failed: ${e.error.localizedMessage}");
        print("Error from Stripe: ${e.error.localizedMessage}");
      }else {
        // Handle other types of errors
        Fluttertoast.showToast(msg: "Payment failed: $e");
        print("Unforeseen error: $e");
      }
    }

  }

  // Create Payment Intent Function
  Future<Map<String, dynamic>> createPaymentIntent(finalPrice) async {
    try {
      // Body
      Map<String, dynamic> body = {
        'amount': calculateStripeAmount(finalPrice), // TODO: Change original price
        'currency': 'USD',
      };
      // Url
      String url = 'https://api.stripe.com/v1/payment_intents';

      var response = await http.post(Uri.parse(url), body: body, headers: {
        'Authorization': 'Bearer sk_test_51OtkZLP6GxdPVDvjHtsAzp3i4ZnkeUnltfhJYOKvsPXpaY6MZKn0LjZiYFvfZKzfRVOpSFh4aGpXkU4Pw62VjLYJ00M2qCElSw', // TODO: Need Change when app live
        'Content-Type': 'application/x-www-form-urlencoded',
      });

      if(response.statusCode == 200) {
        log('Api Process is on progress ${response.body}');
        return json.decode(response.body);
      }else {
        log('Failed to create payment  : ${response.statusCode} - ${response.body}');
        return {};
      }

    }catch (e) {
      log('Error in Creating Payment Intent : $e');
      return {};
    }
  }

  // Calculate Amount Function
  String calculateStripeAmount(double amount) {
    return (amount * 100).toInt().toString();
  }

}