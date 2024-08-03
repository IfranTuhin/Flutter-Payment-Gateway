
import 'package:flutter/material.dart';
import 'package:flutter_payment_getway/service/gpay_payment.dart';
import 'package:flutter_payment_getway/service/stripe_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  StripePayment stripePayment = StripePayment();
  GPayPayment gPayPayment = GPayPayment();

  @override
  void initState() {
    super.initState();
     Stripe.publishableKey = "pk_test_51OtkZLP6GxdPVDvjcMC2ZIDtHaqfk8fOjn0ianG9MgcgVcz4OUQZ2xQF0afPofLSPPw6Neu7O88yI3JEMVW9V0o9005dNT7pOE"; // TODO: this have to be changed when live
  }

  final Pay _payClient = Pay.withAssets([
    'json/google_pay_config.json',
  ]);

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
              stripePayment.makeStripePayment(1, 10.00); // TODO: Change And Dynamic package id & final price
            },
              child: const Text('Pay with Stripe', style: TextStyle(fontSize:18, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),

            // Pay with Google pay
            Center(
              child: SizedBox(
                width: 200,
                child: RawGooglePayButton(
                  type: GooglePayButtonType.pay,
                  onPressed: () async {
                    var result = await _payClient.showPaymentSelector(
                      PayProvider.google_pay,
                      <PaymentItem>[
                        const  PaymentItem(
                          label: 'Total',
                          amount: '20',
                          status: PaymentItemStatus.final_price,
                        ),
                      ],
                    );
                    await gPayPayment.processPayment(
                      result['paymentMethodData']["tokenizationData"]["token"],
                      1,
                      '1',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
