import 'package:flutter/material.dart';
import 'package:myapp/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Maze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // change app text color to white
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            subtitleTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            )),
        scaffoldBackgroundColor: Colors.white12,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white24,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromRGBO(60, 148, 139, 1),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white24,
          selectedItemColor: Color.fromRGBO(60, 148, 139, 1),
          unselectedItemColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
