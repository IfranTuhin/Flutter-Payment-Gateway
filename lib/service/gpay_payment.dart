import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import  'package:http/http.dart' as http;

class GPayPayment {

  Future<void> processPayment(
      dynamic paymentToken, int packageId, String referCode) async {
    Map<String, dynamic> jsonMap = json.decode(paymentToken);
    print("The payment is ongoing ${jsonMap["id"]}");
    dynamic token = jsonMap["id"];

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? userId = prefs.getString(AppConstraints.userId);
    // int u_id = int.parse(userId!);

    if(referCode.isEmpty) {
      final response = await http.post(
        Uri.parse('https://main.assalam.app/api/makePayment/1/1/$token'), // Replace with your actual endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // body: {'refer_ud' : referCode},
      );
      print("The response is on process ${response.body}");
      Map<String, dynamic> jsonRes = json.decode(response.body);
      Fluttertoast.showToast(msg: jsonRes["message"]);
      // ui
      // Get.off(BottomNaveBarPage());
      Fluttertoast.showToast(
        msg: 'Now you are now premium Member',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }else {
      final response = await http.post(
        Uri.parse('https://main.assalam.app/api/makePayment/1u_id}/${packageId}/${token}/${referCode}'), // Replace with your actual endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // body: {'refer_ud' : referCode},
      );
      print("The response is on process ${response.body}");
      Map<String, dynamic> jsonRes = json.decode(response.body);
      Fluttertoast.showToast(msg: jsonRes["message"]);
      // ui
     //  Get.off(BottomNaveBarPage());
      Fluttertoast.showToast(
        msg: 'Now you are premium Member',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

  }

}