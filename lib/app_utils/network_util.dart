import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkUtil {
  Future<bool> isConnected(BuildContext context, Function onRetry) async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      return result;
    } on SocketException catch (_) {
      return false;
    }
  }
}