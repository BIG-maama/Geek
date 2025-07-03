import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/core/api/dio_consumer.dart';
import 'package:dio/dio.dart';
import 'package:pro/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int totalFrames = 45;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create: (_) => UserCubit(DioConsumer(dio: Dio())),
                  child: const King(),
                ),
          ),
        );
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getFrameName(int index) {
    final paddedIndex = index.toString().padLeft(3, '0'); // 000, 001, 002 ...
    return 'assets/frames/frame_$paddedIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            int currentFrame = (_controller.value * (totalFrames - 1)).floor();
            String framePath = getFrameName(currentFrame);
            return Image.asset(framePath);
          },
        ),
      ),
    );
  }
}
