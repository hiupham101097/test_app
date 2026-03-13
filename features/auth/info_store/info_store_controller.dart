import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/commons/views/bottomsheet_custom_mutil.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/category_sestym_model.dart';
import 'package:merchant/domain/data/models/location_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/auth/info_store/model/register_request.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/object_util.dart';
import 'package:uuid/uuid.dart';

enum RegisterCondition { intro, buildStep }

enum StepEnum { step1, step2, step3, step4 }

class InfoStoreController extends GetxController {
  final ApiClient client = ApiClient();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final currentPage = 0.obs;
  final registerCondition = RegisterCondition.intro.obs;
  final step = StepEnum.step1.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;
  final validate = false.obs;
  final uuid = ''.obs;
  final introduceCode = ''.obs;
  final store = StoreModel().obs;
  //step 1
  final nameFocusNode = FocusNode();
  final nameController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final selectedCategorySestym = Rx<List<CategorySestymModel>>([]);
  final selectedCategorySestymFocusNode = FocusNode();
  final selectedCategorySestymController = TextEditingController();
  final listCategorySestym = <CategorySestymModel>[].obs;
  final pickedImagesAvatar = "".obs;
  final pickedImagesBanner = "".obs;
  final listLocation = <ModelLocation>[].obs;
  final List<String> listField = ["Quán ăn", "Bách hoá"];
  final selectedFieldFocusNode = FocusNode();
  final selectedFieldController = TextEditingController();
  final indexSelectedField = 0.obs;
  //step 2
  final searchLocationFocusNode = FocusNode();
  final searchLocationController = TextEditingController();
  final streetFocusNode = FocusNode();
  final streetController = TextEditingController();
  final wardFocusNode = FocusNode();
  final wardController = TextEditingController();
  final districtFocusNode = FocusNode();
  final districtController = TextEditingController();
  final provinceFocusNode = FocusNode();
  final provinceController = TextEditingController();
  final selectedLocation = Rx<ModelLocation?>(null);
  Timer? debounce;
  final showListSuggestion = false.obs;

  //step 3
  final pickedImagesMenus = "".obs;
  final minPriceFocusNode = FocusNode();
  final minPriceController = TextEditingController();
  final maxPriceFocusNode = FocusNode();
  final maxPriceController = TextEditingController();

  //step 4
  final codeNumberFocusNode = FocusNode();
  final codeNumberController = TextEditingController();
  final pickedImagesVerificationDocuments = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    uuid.value = Uuid().v4();
    nameController.addListener(_validateForm);
    descriptionController.addListener(_validateForm);
    selectedCategorySestymController.addListener(_validateForm);
    searchLocationController.addListener(_validateForm);
    streetController.addListener(_validateForm);
    wardController.addListener(_validateForm);
    districtController.addListener(_validateForm);
    provinceController.addListener(_validateForm);
    minPriceController.addListener(_validateForm);
    maxPriceController.addListener(_validateForm);
    codeNumberController.addListener(_validateForm);
    selectedFieldController.addListener(_validateForm);
    // Re-validate whenever step or register mode changes
    ever(step, (_) {
      _validateForm();
    });
    ever(registerCondition, (_) {
      _validateForm();
    });
    ever(selectedCategorySestym, (_) {
      _validateForm();
    });
    ever(selectedLocation, (_) {
      _validateForm();
    });
    ever(pickedImagesMenus, (_) {
      _validateForm();
    });
    ever(pickedImagesVerificationDocuments, (_) {
      _validateForm();
    });
    ever(pickedImagesAvatar, (_) {
      _validateForm();
    });
    ever(pickedImagesBanner, (_) {
      _validateForm();
    });
    // fetchCategorySestym();
    store.value = StoreDB().currentStore() ?? StoreModel();
    if (Get.arguments != null) {
      if (Get.arguments['email'] != null) {
        email.value = Get.arguments['email'];
      }
      if (Get.arguments['phone'] != null) {
        phone.value = Get.arguments['phone'];
      }
      if (Get.arguments['password'] != null) {
        password.value = Get.arguments['password'];
      }
      if (Get.arguments['introduceCode'] != null) {
        introduceCode.value = Get.arguments['introduceCode'];
      } 
    }

     initData();
  }

  void initData() {
    if (store.value.id.isNotEmpty) {
      selectedCategorySestym.value = store.value.systemCategories ?? [];
      selectedCategorySestymController.text = selectedCategorySestym.value
          .map((e) => e.name ?? "")
          .toList()
          .join(", ");
      nameController.text = store.value.name;
      descriptionController.text = store.value.description;
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
      searchLocationController.text = store.value.location;
      streetController.text = store.value.street;
      wardController.text = store.value.commune;
      districtController.text = store.value.district;
      provinceController.text = store.value.province;
      minPriceController.text = store.value.minPrice.toString();
      maxPriceController.text = store.value.maxPrice.toString();
      pickedImagesAvatar.value = store.value.imageUrlMap;
      pickedImagesBanner.value = store.value.bannerUrlMap;
      pickedImagesMenus.value = store.value.menuUrlMap;
      pickedImagesVerificationDocuments.value = store.value.businessLicenseMap;
      codeNumberController.text = store.value.taxCode;
      _validateForm();
    }
  }

  void onSelectLocation(ModelLocation location) {
    showListSuggestion.value = false;
    selectedLocation.value = location;
    searchLocationController.text = location.fullNewAddress;
    streetController.text = location.street;
    wardController.text = location.ward;
    districtController.text = location.district;
    provinceController.text = location.province;
  }

  List<Map<String, dynamic>> get steps => [
    {
      'title': 'Thông tin cửa hàng',
      'subtitle':
          'Bắt đầu giới thiệu cửa hàng của bạn đến với khách hàng! Hãy chia sẻ tên, lĩnh vực và cách mọi người có thể liên hệ với bạn.',
      'image': AssetConstants.step1,
      'isSuccess':
          store.value.name.isNotEmpty &&
          store.value.description.isNotEmpty &&
          store.value.imageUrl.isNotEmpty &&
          store.value.bannerImg.isNotEmpty,
    },
    {
      'title': ' Địa chỉ kinh doanh',
      'subtitle':
          'Cho khách hàng biết bạn đang ở đâu! Vị trí rõ ràng giúp đơn hàng được giao nhanh hơn và tạo niềm tin khi mua sắm.',
      'image': AssetConstants.step2,
      'isSuccess':
          selectedLocation.value != null &&
          // streetController.text.isNotEmpty &&
          wardController.text.isNotEmpty &&
          // districtController.text.isNotEmpty &&
          selectedCategorySestym.value.isNotEmpty &&
          provinceController.text.isNotEmpty,
    },
    {
      'title': 'Giá và hình ảnh menu',
      'subtitle':
          'Thu hút khách hàng ngay từ cái nhìn đầu tiên. Hãy thêm hình ảnh món ngon, giá hấp dẫn và mô tả thật “gây thèm”',
      'image': AssetConstants.step3,
      'isSuccess':
          store.value.maxPrice > 0 &&
          store.value.minPrice > 0 &&
          store.value.minPrice <= store.value.maxPrice &&
          store.value.menu.isNotEmpty,
    },
    {
      'title': 'Giấy tờ và xác minh',
      'subtitle':
          'Một vài bước nhỏ để khẳng định uy tín lớn! Cung cấp giấy tờ giúp cửa hàng bạn được xác minh và sẵn sàng kinh doanh trên Chợ Thông Minh.',
      'image': AssetConstants.step4,
      'isSuccess':
          store.value.businessLicenseNumber.isNotEmpty &&
          store.value.taxCode.isNotEmpty &&
          store.value.taxCode.trim().length >= 10,
    },
  ];
  void onAction() {
    if (registerCondition.value == RegisterCondition.intro) {
      if (store.value.status != '' &&
          store.value.status.isNotEmpty &&
          store.value.status == 'APPROVE') {
        Get.offAllNamed(Routes.login);
      } else {
        registerCondition.value = RegisterCondition.buildStep;
        _validateForm();
      }
    } else {
      validate.value = false;
      if (step.value == StepEnum.step1) {
        step.value = StepEnum.step2;
        _validateForm();
      } else if (step.value == StepEnum.step2) {
        step.value = StepEnum.step3;
        _validateForm();
      } else if (step.value == StepEnum.step3) {
        step.value = StepEnum.step4;
        _validateForm();
      } else if (step.value == StepEnum.step4) {
        registerStore();
        validate.value = true;
      }
    }
  }

  void _validateForm() {
    if (step.value == StepEnum.step1) {
      _validateFormStep1();
    } else if (step.value == StepEnum.step2) {
      _validateFormStep2();
    } else if (step.value == StepEnum.step3) {
      _validateFormStep3();
    } else {
      _validateFormStep4();
    }
  }

  void _validateFormStep1() {
    validate.value =
        nameController.text.isNotEmpty &&
        indexSelectedField.value >= 0 &&
        selectedFieldController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedCategorySestym.value.isNotEmpty &&
        pickedImagesAvatar.value.isNotEmpty &&
        pickedImagesBanner.value.isNotEmpty;
  }

  void _validateFormStep2() {
    validate.value =
        selectedLocation.value != null &&
        // streetController.text.isNotEmpty &&
        wardController.text.isNotEmpty &&
        // districtController.text.isNotEmpty &&
        provinceController.text.isNotEmpty;
  }

  void _validateFormStep3() {
    final minPrice = int.tryParse(minPriceController.text.replaceAll(',', ''));
    final maxPrice = int.tryParse(maxPriceController.text.replaceAll(',', ''));

    validate.value =
        minPriceController.text.isNotEmpty &&
        maxPriceController.text.isNotEmpty &&
        minPrice != null &&
        maxPrice != null &&
        minPrice > 0 &&
        maxPrice > 0 &&
        minPrice <= maxPrice &&
        pickedImagesMenus.isNotEmpty;
  }

  void _validateFormStep4() {
    validate.value =
        pickedImagesVerificationDocuments.isNotEmpty &&
        codeNumberController.text.isNotEmpty &&
        codeNumberController.text.trim().length >= 10;
  }

  Future<void> fetchCategorySestym() async {
    EasyLoading.show();
    await client
        .fetchListCategorySestym(
          system: indexSelectedField.value + 1,
          limit: 99,
        )
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["systemCategories"] != null) {
            listCategorySestym.assignAll(
              (response.data["systemCategories"] as List)
                  .map(
                    (e) =>
                        CategorySestymModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> registerStore() async {
    EasyLoading.show();

    final request = RegisterStoreRequest(
      id: store.value.status == "REJECT" ? '' : uuid.value,
      name: nameController.text,
      slug: AppUtil.generateSlug(nameController.text),
      description: descriptionController.text,
      imageFile: pickedImagesAvatar.value,
      bannerFile: pickedImagesBanner.value,
      organizationId: 1,
      phone: phone.value,
      ownerEmail: email.value,
      location: selectedLocation.value?.fullNewAddress ?? "",
      province: selectedLocation.value?.province ?? "",
      district: selectedLocation.value?.district ?? "",
      commune: selectedLocation.value?.ward ?? "",
      street: selectedLocation.value?.street ?? "",
      lat: selectedLocation.value?.location?.lat ?? 0,
      lng: selectedLocation.value?.location?.lng ?? 0,
      minPrice: int.tryParse(minPriceController.text.replaceAll(',', '')) ?? 0,
      maxPrice: int.tryParse(maxPriceController.text.replaceAll(',', '')) ?? 0,
      menu: pickedImagesMenus.value,
      rating: 0,
      openTime: "00:00",
      closeTime: "00:00",
      taxCode: codeNumberController.text,
      businessLicenseNumber: pickedImagesVerificationDocuments.value,
      status: store.value.status == "REJECT" ? "" : "PENDING",
      storeSystemCategory:
          selectedCategorySestym.value.map((e) => {"id": e.id ?? ""}).toList(),
      system: [(indexSelectedField.value + 1).toString()],
      introduceCode: introduceCode.value,
    );
    print("request: ${request.toJson()}");
    final formData = await request.toFormData();

    if (store.value.status == "REJECT") {
      await client
          .updateRejectStore(formData: formData, idStore: store.value.id)
          .then((response) async {
            EasyLoading.dismiss();
            if (response.statusCode == 200) {
              registerCondition.value = RegisterCondition.intro;
              store.value = StoreModel.fromJson(
                response.data["resultApi"]['data'] as Map<String, dynamic>,
              );
              await StoreDB().save(store.value);
              DialogUtil.showSuccessMessage(
                response.data["message"] ?? "Cập nhật thành công",
              );
            }
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    } else {
      await client
          .registerStoreFormData(formData: formData)
          .then((response) async {
            EasyLoading.dismiss();
            if (response.statusCode == 200 &&
                response.data["resultApi"]['data'] != null) {
              registerCondition.value = RegisterCondition.intro;
              store.value = StoreModel.fromJson(
                response.data["resultApi"]['data'] as Map<String, dynamic>,
              );
              sl<LocalClient>().setEmail(email.value);
              sl<LocalClient>().clearPhone();
              await StoreDB().save(store.value);
              DialogUtil.showSuccessMessage(
                response.data["message"] ??
                    "Tạo cửa hàng thành công, Vui lòng đợi duyệt",
              );
            }
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    }
    EasyLoading.dismiss();
  }

  void onSearchLocation(String search) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      showListSuggestion.value = true;
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

  void showBottomSheetCategory() {
    Get.bottomSheet(
      BottomsheetCustomMutilWidget(
        title: "category".tr,
        dataCustom: listCategorySestym.map((e) => e.name ?? "").toList(),
        onConfirm: (index) {
          selectedCategorySestym.value =
              listCategorySestym
                  .where((e) => index.contains(listCategorySestym.indexOf(e)))
                  .toList();
          selectedCategorySestymController.text = selectedCategorySestym.value
              .map((e) => e.name ?? "")
              .toList()
              .join(", ");
        },
        selectedItem:
            selectedCategorySestym.value.map((e) => e.name ?? "").toList(),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showBottomSheetField() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "lĩnh vực kinh doanh".tr,
        dataCustom: listField,
        onTap: (index) {
          selectedFieldController.text = listField[index];
          indexSelectedField.value = index;
          listCategorySestym.clear();
          selectedCategorySestym.value = [];
          selectedCategorySestymController.text = "";
          fetchCategorySestym();
        },
        selectedItem: selectedFieldController.text,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onBackPress() {
    if (step.value == StepEnum.step4) {
      step.value = StepEnum.step3;
      _validateForm();
    } else if (step.value == StepEnum.step3) {
      step.value = StepEnum.step2;
      _validateForm();
    } else if (step.value == StepEnum.step2) {
      step.value = StepEnum.step1;
      _validateForm();
    } else if (step.value == StepEnum.step1) {
      registerCondition.value = RegisterCondition.intro;
      _validateForm();
    }
  }

  String getStepTitle() {
    return step.value == StepEnum.step1
        ? "Thông tin cửa hàng"
        : step.value == StepEnum.step2
        ? "Địa chỉ kinh doanh"
        : step.value == StepEnum.step3
        ? "Giá và hình ảnh menu"
        : "Giấy tờ và xác minh";
  }

  String gettitleButton() {
    switch (registerCondition.value) {
      case RegisterCondition.intro:
        if (store.value.status != '' && store.value.status.isNotEmpty) {
          switch (store.value.status.toUpperCase()) {
            case "PENDING":
              return "Đang chờ duyệt";
            case "APPROVE":
              return "TIẾN HÀNH KINH DOANH";
            case "REJECT":
              return "Đã từ chối";
            default:
              return "";
          }
        }
        return "Tạo hồ sơ";
      case RegisterCondition.buildStep:
        switch (step.value) {
          case StepEnum.step1:
            return "Tiếp theo";
          case StepEnum.step2:
            return "Tiếp theo";
          case StepEnum.step3:
            return "Tiếp theo";
          case StepEnum.step4:
            return store.value.status == "" ? "HOÀN THÀNH" : "Lưu chỉnh sửa";
        }
    }
  }
}
