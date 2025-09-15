// lib/app/views/widgets/pulsing_circle.dart

import 'package:flutter/material.dart';

class PulsingCircle extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingCircle({
    Key? key,
    required this.color,
    this.size = 200.0, // Ukuran default lingkaran
  }) : super(key: key);

  @override
  State<PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Gunakan gradasi untuk efek yang lebih halus
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(0.5),
                widget.color.withOpacity(0.2 * _animation.value),
                widget.color.withOpacity(0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}