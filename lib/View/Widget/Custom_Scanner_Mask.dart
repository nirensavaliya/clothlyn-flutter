import 'package:flutter/material.dart';

class ScannerMask extends StatelessWidget {
  final double boxSize;
  const ScannerMask({super.key, required this.boxSize});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxPossible =
            constraints.biggest.shortestSide; // for safety on odd aspect ratios
        // `boxSize` is already clamped by the caller, but keep this defensive
        // to avoid runtime asserts on extremely small constraints.
        final double safeBoxSize =
            maxPossible > 0 ? boxSize.clamp(0.0, maxPossible) : boxSize;

        final double top = ((constraints.maxHeight - safeBoxSize) / 2)
            .clamp(0.0, double.infinity);
        final double side = ((constraints.maxWidth - safeBoxSize) / 2)
            .clamp(0.0, double.infinity);

        return Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: top,
                width: constraints.maxWidth,
                color: Colors.black.withOpacity(0.65),
              ),
            ),

            /// BOTTOM
            Positioned(
              bottom: 0,
              child: Container(
                height: top,
                width: constraints.maxWidth,
                color: Colors.black.withOpacity(0.65),
              ),
            ),

            /// LEFT
            Positioned(
              top: top,
              left: 0,
              child: Container(
                width: side,
                height: safeBoxSize,
                color: Colors.black.withOpacity(0.65),
              ),
            ),

            /// RIGHT
            Positioned(
              top: top,
              right: 0,
              child: Container(
                width: side,
                height: safeBoxSize,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ],
        );
      },
    );
  }
}
