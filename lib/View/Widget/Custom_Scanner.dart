import 'package:flutter/material.dart';
import '../Constant/App_Colors.dart';

class ScannerOverlay extends StatefulWidget {
  final double boxSize;
  const ScannerOverlay({super.key, required this.boxSize});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = widget.boxSize;
    final Color cornerColor = AppColors.goldLine;

    final double thickness = (boxSize * 0.05).clamp(3.5, 7.5);
    final double cornerLen = (boxSize * 0.22).clamp(28.0, 56.0);
    final double scanPad = (boxSize * 0.12).clamp(18.0, 32.0);

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        children: [
          // Top-left
          Positioned(
            top: 0,
            left: 0,
            child: _LShape(
              thickness: thickness,
              cornerLen: cornerLen,
              color: cornerColor,
              corner: _LCorner.topLeft,
            ),
          ),
          // Top-right
          Positioned(
            top: 0,
            right: 0,
            child: _LShape(
              thickness: thickness,
              cornerLen: cornerLen,
              color: cornerColor,
              corner: _LCorner.topRight,
            ),
          ),
          // Bottom-left
          Positioned(
            bottom: 0,
            left: 0,
            child: _LShape(
              thickness: thickness,
              cornerLen: cornerLen,
              color: cornerColor,
              corner: _LCorner.bottomLeft,
            ),
          ),
          // Bottom-right
          Positioned(
            bottom: 0,
            right: 0,
            child: _LShape(
              thickness: thickness,
              cornerLen: cornerLen,
              color: cornerColor,
              corner: _LCorner.bottomRight,
            ),
          ),

          // Animated scan line
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double t = _controller.value; // 0..1
              final double y = scanPad + (boxSize - 2 * scanPad) * t;
              return Positioned(
                left: thickness * 0.5,
                right: thickness * 0.5,
                top: y - thickness / 2,
                child: IgnorePointer(
                  child: Container(
                    height: thickness,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(thickness),
                      color: cornerColor.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: cornerColor.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _LCorner { topLeft, topRight, bottomLeft, bottomRight }

class _LShape extends StatelessWidget {
  final double thickness;
  final double cornerLen;
  final Color color;
  final _LCorner corner;

  const _LShape({
    required this.thickness,
    required this.cornerLen,
    required this.color,
    required this.corner,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(thickness);
    switch (corner) {
      case _LCorner.topLeft:
        return SizedBox(
          width: cornerLen,
          height: cornerLen,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: thickness,
                  height: cornerLen,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: r.topLeft,
                      bottomLeft: r.bottomLeft,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: cornerLen,
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: r.topLeft,
                      topRight: r.topRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case _LCorner.topRight:
        return SizedBox(
          width: cornerLen,
          height: cornerLen,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: thickness,
                  height: cornerLen,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topRight: r.topRight,
                      bottomRight: r.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: cornerLen,
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: r.topLeft,
                      topRight: r.topRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case _LCorner.bottomLeft:
        return SizedBox(
          width: cornerLen,
          height: cornerLen,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: thickness,
                  height: cornerLen,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: r.bottomLeft,
                      topLeft: r.topLeft,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: cornerLen,
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: r.bottomLeft,
                      bottomRight: r.bottomRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case _LCorner.bottomRight:
        return SizedBox(
          width: cornerLen,
          height: cornerLen,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: thickness,
                  height: cornerLen,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomRight: r.bottomRight,
                      topRight: r.topRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: cornerLen,
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: r.bottomLeft,
                      bottomRight: r.bottomRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
