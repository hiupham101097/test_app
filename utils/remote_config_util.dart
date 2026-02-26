import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RemoteConfigUtil {
  static Future<bool> checkForAppUpdate({Function? onSkip}) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 2),
        ),
      );

      await remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersionName = packageInfo.version;
      final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      final bool isAndroid = Platform.isAndroid;
      final String platform = isAndroid ? 'android' : 'ios';

      final String minVersion = remoteConfig.getString(
        'merchant_min_version_$platform',
      );
      final String latestVersion = remoteConfig.getString(
        'merchant_latest_version_$platform',
      );

      int _extractBuild(String version) {
        if (version.contains(':')) {
          final parts = version.split(':');
          return int.tryParse(parts.last) ?? 0;
        }
        return int.tryParse(version) ?? 0;
      }

      String _extractVersion(String version) {
        if (version.contains(':')) {
          final parts = version.split(':');
          return parts.first;
        }
        return version;
      }

      int _compareVersion(String current, String min) {
        final currentParts = current.split('.').map(int.parse).toList();
        final minParts = min.split('.').map(int.parse).toList();

        while (currentParts.length < 3) currentParts.add(0);
        while (minParts.length < 3) minParts.add(0);

        for (int i = 0; i < 3; i++) {
          if (currentParts[i] < minParts[i]) return -1;
          if (currentParts[i] > minParts[i]) return 1;
        }
        return 0;
      }

      final int minBuild = _extractBuild(minVersion);
      final int latestBuild = _extractBuild(latestVersion);
      final String minVersionName = _extractVersion(minVersion);
      final String latestVersionName = _extractVersion(latestVersion);

      final int compareWithMin = _compareVersion(
        currentVersionName,
        minVersionName,
      );
      final int compareWithLatest = _compareVersion(
        currentVersionName,
        latestVersionName,
      );

      Get.log(
        '🔍 Remote Config: min=$minVersion($minBuild), latest=$latestVersion($latestBuild), current=$currentVersionName:$currentBuildNumber',
      );

      bool showDialog = false;
      bool forceUpdate = false;
      bool showSkip = false;

      if (compareWithMin < 0 ||
          (compareWithMin == 0 && currentBuildNumber < minBuild)) {
        showDialog = true;
        forceUpdate = true;
        showSkip = false;
      } else if (compareWithLatest < 0 ||
          (compareWithLatest == 0 && currentBuildNumber < latestBuild)) {
        showDialog = true;
        forceUpdate = false;
        showSkip = true;
      } else {
        showDialog = false;
      }

      // if (showDialog) {
      //   showAlertAppUpdateDialog(
      //     Get.context!,
      //     title: "Cập nhật phiên bản mới nhất",
      //     message:
      //         forceUpdate
      //             ? "Vui lòng cập nhật phiên bản mới nhất để tiếp tục sử dụng ứng dụng."
      //             : "Đã có phiên bản mới, bạn có muốn cập nhật không?",
      //     isShowSkip: showSkip,
      //     onSkip: () {
      //       onSkip?.call();
      //     },
      //     onUpdate: () async {
      //       final storeUrl =
      //           isAndroid
      //               ? 'https://play.google.com/store/apps/details?id=com.chothongminh.merchant'
      //               : 'https://apps.apple.com/vn/app/merchant-market/id6754241428';
      //       final uri = Uri.tryParse(storeUrl);
      //       if (uri != null && await canLaunchUrl(uri)) {
      //         await launchUrl(uri, mode: LaunchMode.externalApplication);
      //       } else {
      //         Get.log('⚠️ Không thể mở link cập nhật: $storeUrl');
      //       }
      //     },
      //   );
      //   return true;
      // }

      return false;
    } catch (e, st) {
      Get.log('❌ RemoteConfig checkForAppUpdate error: $e\n$st');
      return false;
    }
  }
}
