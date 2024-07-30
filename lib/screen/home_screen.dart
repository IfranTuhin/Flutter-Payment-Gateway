import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_payment_getway/service/stripe_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import  'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {


  StripePayment stripePayment = StripePayment();

  @override
  void initState() {
    super.initState();
     Stripe.publishableKey = "pk_test_51OtkZLP6GxdPVDvjcMC2ZIDtHaqfk8fOjn0ianG9MgcgVcz4OUQZ2xQF0afPofLSPPw6Neu7O88yI3JEMVW9V0o9005dNT7pOE"; // TODO: this have to be changed when live
  }
  //
  // Map<String, dynamic>? paymentIntent;
  //
  // void makeStripePayment(packageId, finalPrice) async{
  //
  //   try {
  //     paymentIntent = await createPaymentIntent(finalPrice);
  //     log('Stripe Payment Intent : $paymentIntent');
  //
  //     // GPay payment sheet
  //     var gPay = const PaymentSheetGooglePay(
  //       merchantCountryCode: 'US',
  //       currencyCode: 'USD',
  //       buttonType: PlatformButtonType.pay,
  //       testEnv: true,
  //     );
  //
  //     // Stripe init Payment Sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent!['client_secret'],
  //         merchantDisplayName: 'Tuhin', // TODO: Change this for original client merchant name
  //         googlePay: gPay,
  //       ),
  //     );
  //
  //     // Display Stripe Payment Sheet
  //     displayPaymentSheet(packageId, finalPrice);
  //
  //   }catch (e) {
  //     log('Stripe payment Error : $e');
  //   }
  // }
  //
  // // Stripe display payment sheet
  // void displayPaymentSheet(packageId, finalPrice) async {
  //   try {
  //     int uId = 1; // TODO: Change original user id
  //
  //     await Stripe.instance.presentPaymentSheet();
  //
  //     var url = Uri.parse("https://main.assalam.app/api/directPayment/$uId/$packageId/$finalPrice"); // TODO: Change original payment api
  //     var response = await http.post(url);
  //
  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(msg: "Payment successful");
  //       print("Payment successful ${response.body} and rest");
  //       // Update UI or notify user
  //
  //       //  Get.off(BottomNaveBarPage());
  //       Fluttertoast.showToast(
  //         msg: 'Payment Successfull',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //
  //     } else {
  //       Fluttertoast.showToast(msg: "Payment Failed");
  //       print("Payment Failed");
  //     }
  //
  //   }catch (e) {
  //     if(e is StripeException) {
  //       // Handle Stripe-specific errors
  //       Fluttertoast.showToast(msg: "Payment failed: ${e.error.localizedMessage}");
  //       print("Error from Stripe: ${e.error.localizedMessage}");
  //     }else {
  //       // Handle other types of errors
  //       Fluttertoast.showToast(msg: "Payment failed: $e");
  //       print("Unforeseen error: $e");
  //     }
  //   }
  //
  // }
  //
  // // Create Payment Intent Function
  // Future<Map<String, dynamic>> createPaymentIntent(finalPrice) async {
  //   try {
  //     // Body
  //     Map<String, dynamic> body = {
  //       'amount': calculateStripeAmount(finalPrice), // TODO: Change original price
  //       'currency': 'USD',
  //     };
  //     // Url
  //     String url = 'https://api.stripe.com/v1/payment_intents';
  //
  //     var response = await http.post(Uri.parse(url), body: body, headers: {
  //       'Authorization': 'Bearer sk_test_51OtkZLP6GxdPVDvjHtsAzp3i4ZnkeUnltfhJYOKvsPXpaY6MZKn0LjZiYFvfZKzfRVOpSFh4aGpXkU4Pw62VjLYJ00M2qCElSw', // TODO: Need Change when app live
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     });
  //
  //     if(response.statusCode == 200) {
  //       log('Api Process is on progress ${response.body}');
  //       return json.decode(response.body);
  //     }else {
  //       log('Failed to create payment  : ${response.statusCode} - ${response.body}');
  //       return {};
  //     }
  //
  //   }catch (e) {
  //     log('Error in Creating Payment Intent : $e');
  //     return {};
  //   }
  // }
  //
  // // Calculate Amount Function
  // String calculateStripeAmount(double amount) {
  //   return (amount * 100).toInt().toString();
  // }

  // --------> Stripe payment  Start <----------

  Map<String, dynamic>? paymentIntent;

  void makePayment(package_id, price_final) async {
    try {
      paymentIntent = await createPaymentIntent(price_final);
      print("the response of stripe: ${paymentIntent}");
      print("End of response");
      var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: false, // TODO: this have to be changed when live
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            merchantDisplayName: "Assalam",
            googlePay: gpay,
          ));

      displayPaymentSheet(package_id, price_final);

    } catch (e) {
      print(e);
    }
  }

  void displayPaymentSheet(package_id, price_final) async {
    try {

      int u_id = 20;
      await Stripe.instance.presentPaymentSheet();

        var url = Uri.parse("https://main.assalam.app/api/directPayment/${u_id}/${package_id}/${price_final}");
        var response = await http.post(url);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Payment successful");
          print("Payment successful ${response.body} and rest");
          // Update UI or notify user
          setState(() {
            //Get.off(BottomNaveBarPage());
            Fluttertoast.showToast(
              msg: 'Now you are Member',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          });
        } else {
          Fluttertoast.showToast(msg: "Payment Failed");
          print("Payment Failed");
        }

    } catch (e) {
      if (e is StripeException) {
        // Handle Stripe-specific errors
        Fluttertoast.showToast(msg: "Payment failed: ${e.error.localizedMessage}");
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        // Handle other types of errors
        Fluttertoast.showToast(msg: "Payment failed: $e");
        print("Unforeseen error: $e");
      }
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(price_final) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(price_final),
        'currency': 'USD',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          //'Authorization': 'Bearer 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',
          'Authorization': 'Bearer sk_test_51OtkZLP6GxdPVDvjHtsAzp3i4ZnkeUnltfhJYOKvsPXpaY6MZKn0LjZiYFvfZKzfRVOpSFh4aGpXkU4Pw62VjLYJ00M2qCElSw',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        print("The api payment is on process");
        return json.decode(response.body);
      } else {
        print('Failed to create payment intent: ${response.body}');
        return {};
      }
    } catch (e) {
      print('Exception in createPaymentIntent: ${e.toString()}');
      return {};
    }
  }

  String calculateAmount(double price) {
    return (price * 100).toInt().toString(); // Assuming price is in dollars and we need cents
  }

  // --------> Stripe payment  End <----------

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen', style: TextStyle(),),
      ),
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pay with Stripe button
            ElevatedButton(onPressed: () {
              makePayment(1, 10.00); // TODO: Change And Dynamic package id & final price
            },
              child: const Text('Pay with Stripe', style: TextStyle(fontSize:18, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      )),
    );
  }
}
