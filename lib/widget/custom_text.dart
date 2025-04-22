import 'package:flutter/material.dart';

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
