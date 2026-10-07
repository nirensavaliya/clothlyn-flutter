import 'dart:math' as math;

import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Splash_Controller.dart';
import '../../Constant/App_Font.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.imgSplashBg,
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            errorBuilder: (_, __, ___) => Image.asset(
              AppImages.imgSplashBg,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.bgBeige),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 5),
                  const _AnimatedSplashRings(),
                  const SizedBox(height: 22),
                  Text(
                    'Sitaram Cloth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.guGi,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleColor,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppImages.imgSplashContainer),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        width: 2,
                        height: 28,
                        color: const Color(0xFFCFC5B9),
                      ),
                      Text(
                        'SYSTEM READY',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 11,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff7D766C),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  Container(
                    height: 3,
                    width: double.infinity,
                    color: AppColors.goldLine.withOpacity(0.65),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(AppImages.imgSplashPowerBy, scale: 3),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo with outer/inner rings — opposite rotation + soft pulse.
class _AnimatedSplashRings extends StatefulWidget {
  const _AnimatedSplashRings();

  static const double logoSize = 130.8;
  static const double ringOuterSize = 190;
  static const double ringInnerSize = 160.8;

  @override
  State<_AnimatedSplashRings> createState() => _AnimatedSplashRingsState();
}

class _AnimatedSplashRingsState extends State<_AnimatedSplashRings>
    with TickerProviderStateMixin {
  late final AnimationController _outerRotate;
  late final AnimationController _innerRotate;
  late final AnimationController _pulse;

  late final Animation<double> _outerScale;
  late final Animation<double> _innerScale;

  @override
  void initState() {
    super.initState();

    _outerRotate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _innerRotate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _outerScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _innerScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _outerRotate.dispose();
    _innerRotate.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _AnimatedSplashRings.ringOuterSize,
      height: _AnimatedSplashRings.ringOuterSize,
      child: AnimatedBuilder(
        animation: Listenable.merge([_outerRotate, _innerRotate, _pulse]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: _outerScale.value,
                child: Transform.rotate(
                  angle: _outerRotate.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size.square(
                      _AnimatedSplashRings.ringOuterSize,
                    ),
                    painter: _SplashRingPainter(
                      color: AppColors.ringOuterColor.withOpacity(0.55),
                      strokeWidth: 2.8,
                      arcs: const [
                        _RingArc(start: -0.35, sweep: 1.6),
                        _RingArc(start: 1.9, sweep: 0.9),
                        _RingArc(start: 3.4, sweep: 1.1),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: _innerScale.value,
                child: Transform.rotate(
                  angle: -_innerRotate.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size.square(
                      _AnimatedSplashRings.ringInnerSize,
                    ),
                    painter: _SplashRingPainter(
                      color: AppColors.ringInnerColor.withOpacity(0.75),
                      strokeWidth: 2.6,
                      arcs: const [
                        _RingArc(start: 0.2, sweep: 1.4),
                        _RingArc(start: 2.2, sweep: 1.0),
                        _RingArc(start: 4.0, sweep: 1.2),
                      ],
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        },
        child: SizedBox(
          width: _AnimatedSplashRings.logoSize,
          height: _AnimatedSplashRings.logoSize,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Image.asset(
              AppImages.imgSplashLogo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.checkroom_rounded,
                  size: 64,
                  color: AppColors.accentBrown,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingArc {
  final double start;
  final double sweep;

  const _RingArc({required this.start, required this.sweep});
}

class _SplashRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<_RingArc> arcs;

  _SplashRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.arcs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    for (final arc in arcs) {
      canvas.drawArc(rect, arc.start, arc.sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashRingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.arcs != arcs;
  }
}
