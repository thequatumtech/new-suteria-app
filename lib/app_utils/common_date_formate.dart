import 'package:intl/intl.dart';

commonDateFormat(String date){
  try {
    DateTime dateFormat = DateFormat('yyyy-MM-dd').parse(date);
    String newFormatDate = DateFormat('dd/MM/yyyy').format(dateFormat);
    return newFormatDate;
  }  catch (e) {
    return date;
  }
}

commonApiDateFormat(String date){
  try {
    DateTime dateFormat = DateFormat('dd/MM/yyyy').parse(date);
    String newFormatDate = DateFormat('yyyy-MM-dd').format(dateFormat);
    return newFormatDate;
  }  catch (e) {
    return date;
  }
}

bool isPolicyExpired(String? date) {
  if (date == null || date.isEmpty) return false;
  try {
    final now = DateTime.now();
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date).add(const Duration(days: 1));
    return tempDate.isBefore(now);
  } catch (e) {
    try {
      final now = DateTime.now();
      DateTime tempDate = DateFormat("dd/MM/yyyy").parse(date).add(const Duration(days: 1));
      return tempDate.isBefore(now);
    } catch (_) {
      return false;
    }
  }
}