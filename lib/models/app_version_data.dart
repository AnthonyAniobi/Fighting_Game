class AppVersionData {
  final int bugFix;
  final int featureFix;
  final int breakingFix;

  String get name => '$breakingFix.$featureFix.$bugFix';

  AppVersionData._({
    required this.bugFix,
    required this.featureFix,
    required this.breakingFix,
  });

  factory AppVersionData.fromString(String versionCode) {
    final codes = versionCode.split('.');
    return AppVersionData._(
      bugFix: int.parse(codes.last),
      featureFix: int.parse(codes[1]),
      breakingFix: int.parse(codes.first),
    );
  }
}

extension AppVersionDataExtension on AppVersionData {
  bool isMajorFix(AppVersionData storeVersion) =>
      storeVersion.breakingFix > breakingFix;

  bool isFeatureFix(AppVersionData storeVersion) {
    if (storeVersion.breakingFix > breakingFix) {
      return true;
    }
    if ((storeVersion.breakingFix == breakingFix) &&
        (storeVersion.featureFix > featureFix)) {
      return true;
    } else {
      return false;
    }
  }

  bool isBugFix(AppVersionData storeVersion) => storeVersion.bugFix > bugFix;

  bool hasUpdate(AppVersionData storeVersion) {
    if (storeVersion.breakingFix > breakingFix) {
      return true;
    } else if (storeVersion.breakingFix == breakingFix) {
      if (storeVersion.featureFix > featureFix) {
        return true;
      } else if (storeVersion.featureFix == featureFix) {
        if (storeVersion.bugFix > bugFix) {
          return true;
        }
      }
    }
    return false;
  }
}
