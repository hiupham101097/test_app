import 'package:get/utils.dart';

enum RefuntTabEnum {
  complaint,
  reimbursement;

  String getLabel() {
    switch (this) {
      case RefuntTabEnum.complaint:
        return 'oder_complaint'.tr;
      case RefuntTabEnum.reimbursement:
        return 'oder_reimbursement'.tr;
    }
  }
}
