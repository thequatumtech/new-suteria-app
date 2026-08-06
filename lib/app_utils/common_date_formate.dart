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