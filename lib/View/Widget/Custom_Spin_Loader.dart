import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Constant/App_Colors.dart';

/// SpinKitSpinningLines loader.
/// [boxed] true → cream card (Product/Scan style); false → spinner only (buttons).
class CustomSpinLoader extends StatelessWidget {
  final double size;
  final bool boxed;
  final Color? color;

  static const Color boxBg = AppColors.bgBeige;

  const CustomSpinLoader({
    super.key,
    this.size = 48,
    this.boxed = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final spinner = SpinKitSpinningLines(
      color: color ?? AppColors.accentBrown,
      size: size,
      lineWidth: boxed ? 2.2 : 2,
    );

    if (!boxed) {
      return Center(child: spinner);
    }

    return Center(
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: spinner,
      ),
    );
  }
}
