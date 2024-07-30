import 'package:flutter/material.dart';
import 'package:flutter_payment_getway/screen/home_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {

  Stripe.publishableKey = "pk_test_51OtkZLP6GxdPVDvjcMC2ZIDtHaqfk8fOjn0ianG9MgcgVcz4OUQZ2xQF0afPofLSPPw6Neu7O88yI3JEMVW9V0o9005dNT7pOE"; // TODO: this have to be changed when live

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
