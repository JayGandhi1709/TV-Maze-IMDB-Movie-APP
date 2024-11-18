import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/movie_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Maze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // change app text color to white
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        // listTileTheme: const ListTileThemeData(
        //   textColor: Colors.black,
        //   titleTextStyle: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 16,
        //   ),
        //   subtitleTextStyle: TextStyle(
        //     color: Colors.grey,
        //     fontSize: 14,
        //   ),
        // ),
        scaffoldBackgroundColor: Colors.white.withAlpha(240),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
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
      home: const HomeScreen(),
    );
  }
}
