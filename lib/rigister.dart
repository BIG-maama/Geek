import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width <= 640;
    final isMediumScreen = screenSize.width <= 991 && screenSize.width > 640;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width:
                    isSmallScreen
                        ? screenSize.width
                        : isMediumScreen
                        ? screenSize.width
                        : 393,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      isSmallScreen
                          ? 16
                          : isMediumScreen
                          ? 20
                          : 0,
                  vertical:
                      isSmallScreen
                          ? 16
                          : isMediumScreen
                          ? 20
                          : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo Image
                    Image.asset(
                      "images/splash_screen-Photoroom.png",
                      width:
                          isSmallScreen
                              ? screenSize.width
                              : isMediumScreen
                              ? screenSize.width * 0.8
                              : 305,
                      height: isSmallScreen || isMediumScreen ? null : 625,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    // Welcome Text
                    Text(
                      'مرحبا بك في تطبيق دواء.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Registration Button
                    Container(
                      width:
                          isSmallScreen
                              ? screenSize.width
                              : isMediumScreen
                              ? screenSize.width * 0.8
                              : 291,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF06DE87),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Handle registration button tap
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'التسجيل من خلال الايميل',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                left: 10, // Right in RTL
                                child: Image.asset(
                                  'assets/images/google_icon.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Terms and Conditions Text
                    Text(
                      'من خلال انشاء حساب في التطبيق فقد قمت بالموافقة على الشروط والاحكام',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8F8F8F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
