import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/evaluation_item_model.dart';
import 'package:merchant/features/evaluate_detail/widget/bottomsheet_feedback.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EvaluateDetailController extends GetxController {
  final ApiClient client = ApiClient();
  final evaluationItem = EvaluationItemModel().obs;
  final focusNode = FocusNode();
  final feedbackController = TextEditingController();
  final isValidate = false.obs;

  @override
  void onInit() {
    super.onInit();
    feedbackController.addListener(() {
      if (feedbackController.text.isNotEmpty) {
        isValidate.value = true;
      } else {
        isValidate.value = false;
      }
    });
    if (Get.arguments != null && Get.arguments['evaluationItem'] != null) {
      evaluationItem.value = Get.arguments['evaluationItem'];
      fetchDetail();
    }
  }

  Future<void> sendFeedback(String feedback) async {
    EasyLoading.show();
    await client
        .sendFeedback(id: evaluationItem.value.evaluationId, feedback: feedback)
        .then((response) {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            fetchDetail();
            eventBus.fire(EvaluateEvent());
            DialogUtil.showSuccessMessage("send_feedback_success".tr);
          } else {
            DialogUtil.showErrorMessage("send_feedback_failed".tr);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchDetail() async {
    EasyLoading.show();
    await client
        .fetchDetailEvaluate(id: evaluationItem.value.evaluationId)
        .then((response) {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            evaluationItem.value = EvaluationItemModel.fromJson(
              response.data['resultApi'],
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetFeedback() {
    Get.bottomSheet(
      BottomSheetFeedback(
        onTap: (feedback) {
          Get.back();
          sendFeedback(feedback);
        },
      ),
    );
  }
}
