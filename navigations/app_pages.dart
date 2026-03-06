import 'package:merchant/features/add_product_promotion/add_product_promotion_binding.dart';
import 'package:merchant/features/add_product_promotion/add_product_promotion_page.dart';
import 'package:merchant/features/auth/info_store/info_store_binding.dart';
import 'package:merchant/features/auth/info_store/info_store_page.dart';
import 'package:merchant/features/auth/register/register_binding.dart';
import 'package:merchant/features/auth/register/register_page.dart';
import 'package:merchant/features/auth/reset_password/reset_password_binding.dart';
import 'package:merchant/features/auth/reset_password/reset_password_page.dart';
import 'package:merchant/features/confirm_order/confirm_order_binding.dart';
import 'package:merchant/features/confirm_order/confirm_order_page.dart';
import 'package:merchant/features/evaluate/evaluate_binding.dart';
import 'package:merchant/features/evaluate/evaluate_page.dart';
import 'package:merchant/features/evaluate_detail/evaluate_detail_binding.dart';
import 'package:merchant/features/evaluate_detail/evaluate_detail_page.dart';
import 'package:merchant/features/income_statistics/detail_order_statistics/detail_order_statistics_binding.dart';
import 'package:merchant/features/income_statistics/detail_order_statistics/detail_order_statistics_page.dart';
import 'package:merchant/features/income_statistics/income_statistics_binding.dart';
import 'package:merchant/features/income_statistics/income_statistics_page.dart';
import 'package:merchant/features/info_profile/info_profile_binding.dart';
import 'package:merchant/features/info_profile/info_profile_page.dart';
import 'package:merchant/features/menu/menu_custom/arrange_dishes/arrange_dishes_binding.dart';
import 'package:merchant/features/menu/menu_custom/arrange_dishes/arrange_dishes_page.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_binding.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_page.dart';
import 'package:merchant/features/menu/menu_custom/list_product_by_category/list_product_by_category_binding.dart';
import 'package:merchant/features/menu/menu_custom/list_product_by_category/list_product_by_category_page.dart';
import 'package:merchant/features/menu/menu_options/create_product/create_product_binding.dart';
import 'package:merchant/features/menu/menu_options/create_product/create_product_page.dart';
import 'package:merchant/features/menu/view/index_page.dart';
import 'package:merchant/features/menu/view/index_binding.dart';
import 'package:merchant/features/menu/menu_custom/create_category/create_category_binding.dart';
import 'package:merchant/features/menu/menu_custom/create_category/create_category_page.dart';
import 'package:merchant/features/menu/menu_custom/create_food/create_food_binding.dart';
import 'package:merchant/features/menu/menu_custom/create_food/create_food_page.dart';
import 'package:merchant/features/menu/menu_custom/list_category/list_category_binding.dart';
import 'package:merchant/features/menu/menu_custom/list_category/list_category_page.dart';
import 'package:merchant/features/splash/splash_binding.dart';
import 'package:merchant/features/splash/splash_page.dart';
import 'package:merchant/features/use_voucher/use_voucher_binding.dart';
import 'package:merchant/features/use_voucher/use_voucher_page.dart';
import 'package:merchant/features/voucher/voucher_binding.dart';
import 'package:merchant/features/voucher/voucher_page.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_binding.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_page.dart';
import 'package:merchant/features/voucher_discount/voucher_discount_binding.dart';
import 'package:merchant/features/voucher_discount/voucher_discount_page.dart';
import 'package:merchant/features/wallet/add_bank/add_bank_binding.dart';
import 'package:merchant/features/wallet/add_bank/add_bank_page.dart';
import 'package:merchant/features/wallet/confirm_transaction/confirm_transaction_binding.dart';
import 'package:merchant/features/wallet/confirm_transaction/confirm_transaction_page.dart';
import 'package:merchant/features/wallet/deposit_information/deposit_information_binding.dart';
import 'package:merchant/features/wallet/deposit_information/deposit_information_page.dart';
import 'package:merchant/features/wallet/detail_transaction/detail_transaction_binding.dart';
import 'package:merchant/features/wallet/detail_transaction/detail_transaction_page.dart';
import 'package:merchant/features/wallet/convert/detail_convert/detail_convert_binding.dart';
import 'package:merchant/features/wallet/convert/detail_convert/detail_convert_page.dart';
import 'package:merchant/features/wallet/dispose/dispose_binding.dart';
import 'package:merchant/features/wallet/dispose/dispose_page.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_binding.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_page.dart';
import 'package:merchant/features/notifycation/notifycation_binding.dart';
import 'package:merchant/features/notifycation/notifycation_page.dart';
import 'package:merchant/features/notifycation_detail/notifycation_detail_binding.dart';
import 'package:merchant/features/notifycation_detail/notifycation_detail_page.dart';
import 'package:merchant/features/profile/profile_binding.dart';
import 'package:merchant/features/profile/profile_page.dart';
import 'package:merchant/features/refund/detail_refund/detail_refund_binding.dart';
import 'package:merchant/features/refund/detail_refund/detail_refund_page.dart';
import 'package:merchant/features/refund/oder_refund/oder_refund_binding.dart';
import 'package:merchant/features/refund/oder_refund/oder_refund_page.dart';
import 'package:merchant/features/refund/request_refund/request_refund_binding.dart';
import 'package:merchant/features/refund/request_refund/request_refund_page.dart';
import 'package:merchant/features/setting_time/setting_time_binding.dart';
import 'package:merchant/features/setting_time/setting_time_page.dart';
import 'package:merchant/features/support/support_binding.dart';
import 'package:merchant/features/support/support_page.dart';
import 'package:merchant/features/voucher_detail/voucher_detail_binding.dart';
import 'package:merchant/features/voucher_detail/voucher_detail_page.dart';
import 'package:merchant/features/wallet/convert/convert_binding.dart';
import 'package:merchant/features/wallet/convert/convert_page.dart';
import 'package:merchant/features/wallet/convert/confirm_convert/confirm_convert_binding.dart';
import 'package:merchant/features/wallet/convert/confirm_convert/confirm_convert_page.dart';
import 'package:merchant/features/wallet/wallet_discount/wallet_discount_binding.dart';
import 'package:merchant/features/wallet/wallet_discount/wallet_discount_page.dart';
import 'package:merchant/features/wallet/wallet_in/wallet_in_binding.dart';
import 'package:merchant/features/wallet/wallet_in/wallet_in_page.dart';
import 'package:merchant/features/wallet/with_draw/with_draw_binding.dart';
import 'package:merchant/features/wallet/with_draw/with_draw_page.dart';
import 'package:get/get.dart';
import 'package:merchant/features/auth/login/login_binding.dart';
import 'package:merchant/features/auth/login/login_page.dart';
import 'package:merchant/features/auth/fogot_pass/fogot_pass_binding.dart';
import 'package:merchant/features/auth/fogot_pass/fogot_pass_page.dart';
import 'package:merchant/features/auth/otp/otp_binding.dart';
import 'package:merchant/features/auth/otp/otp_page.dart';
import 'package:merchant/features/my_oder/my_oder_binding.dart';
import 'package:merchant/features/my_oder/my_oder_page.dart';
import 'package:merchant/features/oder_detail/oder_detail_binding.dart';
import 'package:merchant/features/oder_detail/oder_detail_page.dart';
import 'package:merchant/features/root/root.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: initial, page: () => SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.root, page: () => RootPage(), binding: RootBinding()),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.fogotPass,
      page: () => FogotPassPage(),
      binding: FogotPassBinding(),
    ),
    GetPage(name: Routes.otp, page: () => OtpPage(), binding: OtpBinding()),
    GetPage(
      name: Routes.myOrder,
      page: () => MyOrderPage(),
      binding: MyOrderBinding(),
    ),
    GetPage(
      name: Routes.oderDetail,
      page: () => OrderDetailPage(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: Routes.refund,
      page: () => OrderRefundPage(),
      binding: OrderRefundBinding(),
    ),
    GetPage(
      name: Routes.requestRefund,
      page: () => RequestRefundPage(),
      binding: RequestRefundBinding(),
    ),
    GetPage(
      name: Routes.detailRefund,
      page: () => DetailRefundPage(),
      binding: DetailRefundBinding(),
    ),
    GetPage(
      name: Routes.createCategory,
      page: () => CreateCategoryPage(),
      binding: CreateCategoryBinding(),
    ),
    GetPage(
      name: Routes.listCategory,
      page: () => ListCategoryPage(),
      binding: ListCategoryBinding(),
    ),
    GetPage(
      name: Routes.createProduct,
      page: () => CreateProductPage(),
      binding: CreateProductBinding(),
    ),
    GetPage(
      name: Routes.menu,
      page: () => MenuTabBar(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: Routes.arrangeDishes,
      page: () => ArrangeDishesPage(),
      binding: ArrangeDishesBinding(),
    ),

    GetPage(
      name: Routes.voucherDetail,
      page: () => VoucherDetailPage(),
      binding: VoucherDetailBinding(),
    ),

    GetPage(
      name: Routes.infoProfile,
      page: () => InfoProfilePage(),
      binding: InfoProfileBinding(),
    ),
    GetPage(
      name: Routes.support,
      page: () => SupportPage(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.incomeStatistics,
      page: () => IncomeStatisticsPage(),
      binding: IncomeStatisticsBinding(),
    ),
    GetPage(
      name: Routes.notifycation,
      page: () => NotifycationPage(),
      binding: NotifycationBinding(),
    ),
    GetPage(
      name: Routes.notifycationDetail,
      page: () => NotifycationDetailPage(),
      binding: NotifycationDetailBinding(),
    ),
    GetPage(
      name: Routes.evaluate,
      page: () => EvaluatePage(),
      binding: EvaluateBinding(),
    ),
    GetPage(
      name: Routes.evaluateDetail,
      page: () => EvaluateDetailPage(),
      binding: EvaluateDetailBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.settingTime,
      page: () => SettingTimePage(),
      binding: SettingTimeBinding(),
    ),
    GetPage(
      name: Routes.myWallet,
      page: () => MyWalletPage(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: Routes.dispose,
      page: () => DisposePage(),
      binding: DisposeBinding(),
    ),
    GetPage(
      name: Routes.detailTransaction,
      page: () => DetailTransactionPage(),
      binding: DetailTransactionBinding(),
    ),
    GetPage(
      name: Routes.withDraw,
      page: () => WithDrawPage(),
      binding: WithDrawBinding(),
    ),
    GetPage(
      name: Routes.addBank,
      page: () => AddBankPage(),
      binding: AddBankBinding(),
    ),
    GetPage(
      name: Routes.convert,
      page: () => ConvertPage(),
      binding: ConvertBinding(),
    ),
    GetPage(
      name: Routes.confirmConvert,
      page: () => ConfirmConvertPage(),
      binding: ConfirmConvertBinding(),
    ),
    GetPage(
      name: Routes.detailConvert,
      page: () => DetailConvertPage(),
      binding: DetailConvertBinding(),
    ),

    GetPage(
      name: Routes.listVoucher,
      page: () => VoucherPage(),
      binding: VoucherBinding(),
    ),
    GetPage(
      name: Routes.useVoucher,
      page: () => UseVoucherPage(),
      binding: UseVoucherBinding(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => ResetPasswordPage(),
      binding: ResetPasswordBinding(),
    ),

    GetPage(
      name: Routes.createFood,
      page: () => CreateFoodPage(),
      binding: CreateFoodBinding(),
    ),
    GetPage(
      name: Routes.addProductPromotion,
      page: () => AddProductPromotionPage(),
      binding: AddProductPromotionBinding(),
    ),
    GetPage(
      name: Routes.listMenu,
      page: () => ListMenuPage(),
      binding: ListMenuBinding(),
    ),

    GetPage(
      name: Routes.listProductByCategory,
      page: () => ListProductByCategoryPage(),
      binding: ListProductByCategoryBinding(),
    ),
    GetPage(
      name: Routes.detailOrderStatistics,
      page: () => DetailOrderStatisticsPage(),
      binding: DetailOrderStatisticsBinding(),
    ),
    GetPage(
      name: Routes.confirmOrderDetail,
      page: () => ConfirmOrderPage(),
      binding: ConfirmOrderBinding(),
    ),
    GetPage(
      name: Routes.walletDiscount,
      page: () => WalletDiscountPage(),
      binding: WalletDiscountBinding(),
    ),
    GetPage(
      name: Routes.depositInformation,
      page: () => DepositInformationPage(),
      binding: DepositInformationBinding(),
    ),
    GetPage(
      name: Routes.confirmTransaction,
      page: () => ConfirmTransactionPage(),
      binding: ConfirmTransactionBinding(),
    ),
    GetPage(
      name: Routes.walletIn,
      page: () => WalletInPage(),
      binding: WalletInBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.infoStore,
      page: () => InfoStorePage(),
      binding: InfoStoreBinding(),
    ),
    GetPage(
      name: Routes.createVoucher,
      page: () => CreateVoucherPage(),
      binding: CreateVoucherBinding(),
    ),
    GetPage(
      name: Routes.voucherDiscount,
      page: () => VoucherDiscountPage(),
      binding: VoucherDiscountBinding(),
    ),
  ];
}
