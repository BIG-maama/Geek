import 'dart:ui';

import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomRadioButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.05; // تقريباً 20px على شاشات متوسطة
    final fontSize = screenWidth * 0.035; // تقريباً 13px على شاشات متوسطة

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CustomPaint(
              painter: RadioButtonPainter(
                isSelected: isSelected,
                color: const Color(0xFFC2C2C2),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.015),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioButtonPainter extends CustomPainter {
  final bool isSelected;
  final Color color;

  RadioButtonPainter({required this.isSelected, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Draw outer circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 2,
      paint,
    );

    if (isSelected) {
      // Draw inner filled circle if selected
      final Paint fillPaint =
          Paint()
            ..color = color
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 4,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
