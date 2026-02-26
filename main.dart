import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:merchant/domain/data/models/category_sestym_model.dart';
import 'package:merchant/domain/data/models/open_time_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_bank_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/fcm_util.dart';
import 'package:merchant/utils/local_notification_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:merchant/utils/screen_utill.dart';
import 'constants/app_constants.dart';
import 'di_container.dart' as di;
import 'domain/data/models/user_model.dart';
import 'l10n/translation_service.dart';
import 'navigations/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory();
  await di.init();
  await TranslationService.init();
  configLoading();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(StoreModelAdapter());
  Hive.registerAdapter(WalletBankModelAdapter());
  Hive.registerAdapter(WalletModelAdapter());
  Hive.registerAdapter(WalletUserModelAdapter());
  Hive.registerAdapter(OpenTimeModelAdapter());
  Hive.registerAdapter(CategorySestymModelAdapter());
  await Hive.openBox<UserModel>(AppConstants.BOX_USER);
  await Hive.openBox<StoreModel>(AppConstants.BOX_STORE);
  await Hive.openBox<WalletModel>(AppConstants.BOX_WALLET);
  await Hive.openBox<WalletUserModel>(AppConstants.BOX_WALLET_USER);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SentryFlutter.init((options) {
    options.dsn =
        'https://bc928508afcc32db3f84c58681743556@o4509789910663168.ingest.us.sentry.io/4510345690087424';
    options.sendDefaultPii = true;
  });
  LocalNotificationUtil().init();
  FcmUtil().init();
  FcmUtil().initForegroundNotification();
  FcmUtil().backgroundHandler();
  FirebaseMessaging.onBackgroundMessage(
    LocalNotificationUtil.backgroundMessageHandler,
  );
  runApp(
    GetMaterialApp(
      translations: TranslationService(),
      locale: const Locale('vi'),
      fallbackLocale: TranslationService.fallbackLocale,
      builder: (context, child) {
        ScreenUtil.instance = ScreenUtil(width: 375, allowFontScaling: false)
          ..init(context);
        setupInteractedMessage();
        return EasyLoading.init()(context, child);
      },
      title: 'merchant',
      theme: ThemeData(
        brightness: Brightness.light,
        splashColor: Colors.transparent,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      checkerboardRasterCacheImages: false,
      showPerformanceOverlay: false,
      useInheritedMediaQuery: true,
      defaultTransition: Transition.rightToLeft,
      unknownRoute: AppPages.routes[0],
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 12.0
    ..indicatorWidget = Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation(Color(0xff001D53)),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(360),
          child: Image.asset(
            'assets/images/logo_loading.png',
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),
      ],
    )
    ..progressColor = AppColors.bgBottomNavigationBar
    ..backgroundColor = Colors.transparent
    ..indicatorColor = AppColors.bgBottomNavigationBar
    ..textColor = AppColors.bgBottomNavigationBar
    // ..maskColor = Colors.black.withOpacity(0.5)
    // ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = []
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..customAnimation = CustomAnimation();
}

void setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    LocalNotificationUtil.openNotification(initialMessage);
  }

  final NotificationAppLaunchDetails? launchDetails =
      LocalNotificationUtil.notificationAppLaunchDetails ??
      await LocalNotificationUtil().getNotificationAppLaunchDetails();
  final bool didLaunchFromNotification =
      launchDetails?.didNotificationLaunchApp ?? false;
  final String? payload = launchDetails?.notificationResponse?.payload;
  if (didLaunchFromNotification && payload != null) {
    LocalNotificationUtil.handleNotificationPayload(payload);
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(turns: controller, child: child),
    );
  }
}
