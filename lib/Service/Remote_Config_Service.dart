import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  FirebaseRemoteConfig? _rc;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;

    _rc = FirebaseRemoteConfig.instance;

    await _rc!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 5),
      minimumFetchInterval:
          kDebugMode ? Duration.zero : const Duration(hours: 1),
    ));

    await _rc!.setDefaults({
      'force_update_version': '',
    });

    try {
      await _rc!.activate();
    } catch (_) {}

    _ready = true;

    () async {
      try {
        await _rc!.fetchAndActivate();
      } catch (_) {}
    }();
  }

  Future<void> refreshForForceUpdate() async {
    if (_rc == null) return;
    try {
      await _rc!.fetchAndActivate();
    } catch (_) {}
  }

  /// Blank remote value means no force-update popup.
  String get forceUpdateVersion {
    if (!_ready || _rc == null) return '';
    return _rc!.getString('force_update_version').trim();
  }
}
