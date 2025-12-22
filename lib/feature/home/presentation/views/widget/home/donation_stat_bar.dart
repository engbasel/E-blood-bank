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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value / widget.maxValue,
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
            Text(
              widget.value.toString(),
              style: TextStyles.semiBold16,
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return LinearProgressIndicator(
              value: _animation.value,
              minHeight: 8,
              backgroundColor: widget.color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(widget.color),
              borderRadius: BorderRadius.circular(12),
            );
          },
        ),
      ],
    );
  }
}
