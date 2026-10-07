import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../View/Common/Toast.dart';
import '../View/Constant/App_Colors.dart';
import '../View/Constant/App_Font.dart';
import 'Remote_Config_Service.dart';

/// Force-update via Firebase Remote Config key `force_update_version`.
/// Blank remote value means no popup.
class ForceUpdate {
  ForceUpdate._();

  /// Returns true when a blocking update dialog is shown.
  static Future<bool> checkAndBlockIfNeeded(
    BuildContext context, {
    String? apkUrl,
  }) async {
    await RemoteConfigService()
        .refreshForForceUpdate()
        .timeout(const Duration(seconds: 3), onTimeout: () {});

    final required = RemoteConfigService().forceUpdateVersion;
    if (required.isEmpty) return false;

    final info = await PackageInfo.fromPlatform();
    final current = info.version;

    if (!_isRemoteNewer(required, current)) return false;

    if (!context.mounted) return true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => _ForceUpdateDialog(
        requiredVersion: required,
        currentVersion: current,
        onUpdate: () => _onUpdatePressed(apkUrl),
      ),
    );
    return true;
  }

  static Future<void> _onUpdatePressed(String? apkUrl) async {
    final url = apkUrl?.trim() ?? '';
    if (!Platform.isAndroid || url.isEmpty) {
      ToastWidget.showToastCustom(
        "APK link not found",
        color: Colors.red,
      );
      return;
    }
    await _downloadApk(url);
  }

  /// Android 10 and below write the Download folder as a real file path.
  static Future<bool> _canWriteDownloads() async {
    if (!Platform.isAndroid) return false;
    final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdk > 29) return true;
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<void> _downloadApk(String apkUrl) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/sitaram-clothing.apk');

      await dio.download(apkUrl, tempFile.path);

      if (!await _canWriteDownloads()) {
        ToastWidget.showToastCustom(
          "Storage permission is required to download the APK",
          color: Colors.red,
        );
        return;
      }

      final result = await MediaStore().saveFile(
        tempFilePath: tempFile.path,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      log("APK saved: $result");
      ToastWidget.showToastCustom(
        "APK downloaded in Download folder",
        color: Colors.green,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      log("APK download error: $e");
      ToastWidget.showToastCustom(
        code == 404 ? "APK file not found on server" : "APK download failed",
        color: Colors.red,
      );
    } catch (e) {
      log("APK download error: $e");
      ToastWidget.showToastCustom(
        "APK download failed",
        color: Colors.red,
      );
    }
  }

  static bool _isRemoteNewer(String remote, String installed) {
    final r = _parse(remote);
    final i = _parse(installed);
    if (r == null || i == null) return false;
    for (var k = 0; k < 3; k++) {
      if (r[k] > i[k]) return true;
      if (r[k] < i[k]) return false;
    }
    return false;
  }

  static List<int>? _parse(String v) {
    final cleaned = v.trim().split('+').first.split('-').first;
    final parts = cleaned.split('.');
    if (parts.isEmpty) return null;
    final out = <int>[0, 0, 0];
    for (var i = 0; i < parts.length && i < 3; i++) {
      out[i] = int.tryParse(parts[i]) ?? 0;
    }
    return out;
  }
}

class _ForceUpdateDialog extends StatelessWidget {
  const _ForceUpdateDialog({
    required this.requiredVersion,
    required this.currentVersion,
    required this.onUpdate,
  });

  final String requiredVersion;
  final String currentVersion;
  final Future<void> Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.accentBrown;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.system_update_rounded,
                  size: 32,
                  color: accent,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Update Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.hanKenSemiBold,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A new version is available. Please update to continue using Sitaram Clothing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgCream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _VersionRow(
                      label: 'Current',
                      value: 'v$currentVersion',
                      valueColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 6),
                    _VersionRow(
                      label: 'Latest',
                      value: 'v$requiredVersion',
                      valueColor: accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _UpdateButton(onUpdate: onUpdate),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdateButton extends StatefulWidget {
  const _UpdateButton({required this.onUpdate});

  final Future<void> Function() onUpdate;

  @override
  State<_UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<_UpdateButton> {
  bool _busy = false;

  Future<void> _tap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onUpdate();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _busy ? null : _tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBrown,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accentBrown,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                'Update Now',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenSemiBold,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.hanKenMedium,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontFamily.hanKenSemiBold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
