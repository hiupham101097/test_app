import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant/domain/data/models/location_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/features/auth/info_store/model/register_request.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';

class InfoProfileController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode phoneFocusNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode addressFocusNode = FocusNode();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final store = StoreModel().obs;
  final isEdit = false.obs;
  final listLocation = <ModelLocation>[].obs;
  final selectedLocation = Rx<ModelLocation?>(null);
  final pickedImagesAvatar = Rx<String>("");
  Timer? debounce;
  final validate = false.obs;
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      _validateForm();
    });
    emailController.addListener(() {
      _validateForm();
    });
    addressController.addListener(() {
      _validateForm();
    });
    ever(isEdit, (value) {});
    ever(pickedImagesAvatar, (value) {
      _validateForm();
    });
    nameController.addListener(() {
      _validateForm();
    });

    store.value = StoreDB().currentStore() ?? StoreModel();

    if (store.value.phone.isNotEmpty) {
      phoneController.text = store.value.phone;
      emailController.text = store.value.ownerEmail;
      addressController.text = store.value.location;
      nameController.text = store.value.name;
      selectedLocation.value = ModelLocation(
        fullAddress: store.value.location,
        province: store.value.province,
        district: store.value.district,
        ward: store.value.commune,
        street: store.value.street,
        location: LocationCoordinates(
          lat: store.value.lat,
          lng: store.value.lng,
        ),
      );
    }
  }

  void _validateForm() {
    validate.value =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        selectedLocation.value != null &&
        (nameController.text != store.value.name ||
            emailController.text != store.value.ownerEmail ||
            pickedImagesAvatar.value != store.value.imageUrlMap ||
            addressController.text != store.value.location) &&
        addressController.text.isNotEmpty;
  }

  void actionEdit() {
    if (isEdit.value &&
        (formKey.currentState?.validate() ?? false) &&
        validate.value) {
      updateStore();
    } else if (!isEdit.value) {
      isEdit.value = !isEdit.value;
    }
  }

  void onSearchLocation(String search) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      fetchLocation(search);
    });
  }

  Future<void> fetchLocation(String search) async {
    if (search.isNotEmpty) {
      EasyLoading.show();
      await client
          .fetchListLocation(search: search)
          .then((response) {
            EasyLoading.dismiss();
            if (response.data != null && response.data is List) {
              listLocation.assignAll(
                (response.data as List)
                    .map(
                      (e) => ModelLocation.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
              );
            } else {
              DialogUtil.showErrorMessage(response.data["resultApi"]);
            }
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    } else {
      listLocation.clear();
    }
  }

  void onSelectLocation(ModelLocation location) {
    addressController.text = location.fullNewAddress;
    selectedLocation.value = location;
    listLocation.clear();
  }

  Future<void> updateStore() async {
    EasyLoading.show();

    final request = RegisterStoreRequest(
      name: nameController.text,
      slug: AppUtil.generateSlug(nameController.text),
      imageFile: pickedImagesAvatar.value,
      organizationId: 1,
      // phone: phoneController.text,
      // ownerEmail: emailController.text,
      location: selectedLocation.value?.fullNewAddress ?? "",
      province: selectedLocation.value?.province ?? "",
      district: selectedLocation.value?.district ?? "",
      commune: selectedLocation.value?.ward ?? "",
      street: selectedLocation.value?.street ?? "",
      lat: selectedLocation.value?.location?.lat ?? 0,
      lng: selectedLocation.value?.location?.lng ?? 0,
    );
    final formData = await request.toFormData();
    await client
        .updateStore(formData: formData, idStore: store.value.id)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            store.value = StoreModel.fromJson(
              response.data["resultApi"]['data'] as Map<String, dynamic>,
            );

            await StoreDB().save(store.value);
            isEdit.value = !isEdit.value;
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
