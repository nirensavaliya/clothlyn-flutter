// import 'package:flutter/material.dart';
//
// class FlipCard extends StatefulWidget {
//   final bool showFront;
//   final Widget front;
//   final Widget back;
//   final Duration duration;
//
//   const FlipCard({
//     super.key,
//     required this.showFront,
//     required this.front,
//     required this.back,
//     this.duration = const Duration(milliseconds: 600),
//   });
//
//   @override
//   State<FlipCard> createState() => _FlipCardState();
// }
//
// class _FlipCardState extends State<FlipCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: widget.duration);
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }
//
//   @override
//   void didUpdateWidget(covariant FlipCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.showFront != oldWidget.showFront) {
//       if (widget.showFront) {
//         _controller.reverse();
//       } else {
//         _controller.forward();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (_, child) {
//         double angle = _animation.value * 3.1416;
//         bool isFront = angle <= 3.1416 / 2;
//
//         return Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.identity()
//             ..setEntry(3, 2, 0.001)
//             ..rotateY(angle),
//           child: isFront ? widget.front : Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()..rotateY(3.1416),
//             child: widget.back,
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final bool showFront;
  final Widget front;
  final Widget back;
  final Duration duration;

  const FlipCard({
    super.key,
    required this.showFront,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.showFront ? 0 : 1,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showFront != oldWidget.showFront) {
      widget.showFront ? _controller.reverse() : _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final angle = _animation.value * pi;
        final isFrontVisible = angle < pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle),
          child: isFrontVisible
              ? widget.front
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: widget.back,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
