import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class DonationStatBar extends StatefulWidget {
  final IconData icon;
  final String title;
  final int value;
  final int maxValue;
  final Color color;

  const DonationStatBar({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  State<DonationStatBar> createState() => _DonationStatBarState();
}

class _DonationStatBarState extends State<DonationStatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<int> _countAnimation;

  double get _progress {
    if (widget.maxValue == 0) return 0;
    return (widget.value / widget.maxValue).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant DonationStatBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value ||
        oldWidget.maxValue != widget.maxValue) {
      _controller.dispose();
      _initAnimation();
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: _progress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _countAnimation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, color: widget.color),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyles.semiBold14,
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _countAnimation,
              builder: (context, _) {
                return Text(
                  _countAnimation.value.toString(),
                  style: TextStyles.semiBold16,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                minHeight: 8,
                backgroundColor: widget.color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(widget.color),
              ),
            );
          },
        ),
      ],
    );
  }
}
