import 'package:flutter/material.dart';
import 'package:myapp/New_UI/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      navigateToHomeScreen();
    });

    super.initState();
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(
              flex: 1,
            ),
            Container(
              height: 100,
              width: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://static.tvmaze.com/images/tvm-header-logo.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // const Text(
            //   "Tv Maze",
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 2,
            //     color: Colors.white,
            //   ),
            // ),
            const SizedBox(height: 100),
            const Center(
              child: CircularProgressIndicator(),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
