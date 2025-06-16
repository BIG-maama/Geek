import 'package:flutter/material.dart';

import 'dart:ui';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool isPassword;
  final TextEditingController? controller;
  final String? prefixText;
  final VoidCallback? onTogglePasswordVisibility;
  final bool passwordVisible;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    this.placeholder,
    this.isPassword = false,
    this.controller,
    this.prefixText,
    this.onTogglePasswordVisibility,
    this.passwordVisible = false,
    this.keyboardType = TextInputType.text,
    //required int maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Almarai',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (prefixText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    prefixText!,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFC2C2C2),
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !passwordVisible,
                  keyboardType: keyboardType,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFC2C2C2),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              if (isPassword)
                GestureDetector(
                  onTap: onTogglePasswordVisibility,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CustomPaint(
                        painter: EyeIconPainter(
                          color: const Color(0xFFC7C7C7),
                          crossed: !passwordVisible,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class EyeIconPainter extends CustomPainter {
  final Color color;
  final bool crossed;

  EyeIconPainter({required this.color, this.crossed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final Path path = Path();

    // Draw eye outline
    path.moveTo(size.width * 0.1, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.1,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);

    // Draw pupil
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      paint,
    );

    if (crossed) {
      // Draw line through eye for crossed out version
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.1),
        Offset(size.width * 0.9, size.height * 0.9),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

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

class AppColors {
  // Primary colors
  static const Color primaryGreen = Color(0xFF06DE87);

  // Background colors
  static const Color background = Colors.white;
  static const Color inputBackground = Color(0xFFEEEEEE);

  // Text colors
  static const Color textPrimary = Colors.black;
  static const Color textGrey = Color(0xFFC7C7C7);
  static const Color hintText = Color(0xFFC2C2C2);
}
