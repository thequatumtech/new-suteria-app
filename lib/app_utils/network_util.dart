import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkUtil {
  static final InternetConnectionChecker _checker = InternetConnectionChecker.createInstance();

  Future<bool> isConnected(BuildContext context, Function onRetry) async {
    try {
      return await _checker.hasConnection;
    } on SocketException catch (_) {
      return false;
    } catch (_) {
      return true;
    }
  }
}