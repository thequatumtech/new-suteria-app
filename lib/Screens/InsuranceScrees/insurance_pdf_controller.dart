
import 'package:get/get.dart';


class InsurancePdfController extends GetxController {
  RxBool isTermConditions = false.obs;
  RxBool isTermConditionsDraf = false.obs;
  RxBool isPaymentSuccess = false.obs;

  void resetTerms() {
    isTermConditions.value = false;
    isTermConditionsDraf.value = false;
  }
}
