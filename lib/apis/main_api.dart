import 'dart:convert';

import 'package:http/http.dart';

class BackendApi {
  static int onum = 10;
  static String audioDat = '';

  static Future<void> sendSpeechData(int vendorID,
      {int ordernumber = -1}) async {
    onum++;
    String feedbackData = audioDat;
    print(audioDat);
    if (feedbackData.isNotEmpty) {
      Map<String, dynamic> data = {"data": feedbackData};
      //send data to spring backend with orderID and vendor
      var response = await post(
          Uri.parse(
              "http://192.168.29.136:8080/customer/feedbackToVendor?vendorID=$vendorID&orderNumber=$ordernumber"),
          headers: {
            "Content-type": 'application/json',
          },
          body: jsonEncode(data));
      audioDat = '';
    }
  }
}
