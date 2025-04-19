import 'package:flutter/material.dart';
import 'package:pro/rigister.dart';

class SkipScreen extends StatelessWidget {
  const SkipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.07,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF06DE87),
                borderRadius: BorderRadius.circular(10),
              ),
              child: MaterialButton(
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.05),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1, // تناسب مربعي افتراضي
                  child: Image.asset(
                    "images/splash_screen-Photoroom.png",
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
