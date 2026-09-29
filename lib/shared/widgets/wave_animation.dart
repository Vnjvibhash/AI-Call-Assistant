import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class WaveAnimation extends StatefulWidget {
  final bool isAnimating;
  final Color? color;
  final double height;
  final int barCount;

  const WaveAnimation({
    super.key,
    required this.isAnimating,
    this.color,
    this.height = 36,
    this.barCount = 18,
  });

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void didUpdateWidget(WaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barColor = widget.color ?? AppTheme.primaryBlue;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (index) {
              final progress = _controller.value * 2 * pi;
              final offset = (index / widget.barCount) * 2 * pi;
              final factor = widget.isAnimating
                  ? (sin(progress + offset).abs() * 0.75 + 0.25)
                  : 0.15;

              return Container(
                width: 3.5,
                height: widget.height * factor,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(widget.isAnimating ? 0.9 : 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
