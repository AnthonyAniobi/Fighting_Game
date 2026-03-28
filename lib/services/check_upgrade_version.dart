import 'package:fighting_game/models/app_version_data.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckUpgradeVersion {
  static Future<({AppVersionData newVersion, AppVersionData currentVersion})?>
  checkUpgradeManually() async {
    late String? storeVersionCode;
    late String? currentVersionCode;
    // late String? releaseNotesCode;

    final upgrader = Upgrader();

    await upgrader.initialize(); // fetches latest version

    storeVersionCode = upgrader.currentAppStoreVersion;
    // releaseNotesCode = upgrader.releaseNotes ?? '';
    currentVersionCode = upgrader.currentInstalledVersion;

    if ((storeVersionCode != null) && (currentVersionCode != null)) {
      final storeVersion = AppVersionData.fromString(storeVersionCode);
      final currentVersion = AppVersionData.fromString(currentVersionCode);

      return (newVersion: storeVersion, currentVersion: currentVersion);
    } else {
      return null;
    }
  }

  static Future<void> launchStore() async {
    final upgrader = Upgrader();
    final url = upgrader.currentAppStoreListingURL;
    if (url == null) {
      return;
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
