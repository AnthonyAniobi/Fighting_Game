import 'package:fighting_game/models/app_version_data.dart';
import 'package:fighting_game/services/check_upgrade_version.dart';
import 'package:flutter/foundation.dart';

class UpgradeNotifier extends ChangeNotifier {
  // make a singleton
  static final UpgradeNotifier instance = UpgradeNotifier._();

  UpgradeNotifier._();

  factory UpgradeNotifier() => instance;

  bool _updateModalShown = false;
  AppVersionData? _currentVersion;
  AppVersionData? _latestVersion;

  bool get hasUpdate => (_currentVersion == null || _latestVersion == null)
      ? false
      : _currentVersion!.hasUpdate(_latestVersion!);
  bool get hasMajorUpdate => (_currentVersion == null || _latestVersion == null)
      ? false
      : _currentVersion!.isMajorFix(_latestVersion!);
  bool get updateModalShown => _updateModalShown;

  Future<void> checkForUpdates() async {
    // Simulate checking for updates
    if (_currentVersion != null && _latestVersion != null) {
      return;
    }
    final data = await CheckUpgradeVersion.checkUpgradeManually();
    _currentVersion = data?.currentVersion;
    _latestVersion = data?.newVersion;

    notifyListeners();
  }

  void markUpdateModalShown() {
    _updateModalShown = true;
    notifyListeners();
  }

  bool get shouldShowModal {
    if (_latestVersion == null) {
      return false;
    }
    if (hasMajorUpdate) {
      // must show update modal if there is a major update
      return true;
    } else if (hasUpdate) {
      // modal has already been dismissed so dont show again
      if (updateModalShown) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  void launchStore() {
    CheckUpgradeVersion.launchStore();
  }
}
