import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/router.dart';
import 'package:template/src/views/splash_view.dart';
import 'package:template/src/views/dashboard/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      fontFamily: 'Wanted Sans',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: const Color(0xFFF7F7F8), // TODO: change primary color
        primary: const Color(0xFF323157), // TODO: change primary color
        surface: Colors.white,
        onSurface: Colors.black,
        inverseSurface: Colors.black,
        surfaceContainer: const Color(0xFFF1F1F1),
        surfaceTint: Colors.transparent,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: Colors.white,
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.black),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: Color(0xFFF1F1F1),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
    final darkTheme = ThemeData(
      fontFamily: 'Wanted Sans',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF46415D), // TODO: change primary color
        primary: const Color(0xFF323157), // TODO: change primary color
        surface: Colors.black,
        onSurface: Colors.white,
        inverseSurface: Colors.white,
        surfaceContainer: const Color(0xFF181818),
        surfaceTint: Colors.transparent,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: Color(0xFF181818),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
    return AdaptiveTheme(
      debugShowFloatingThemeButton: true,
      initial: AdaptiveThemeMode.system,
      light: lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          lightTheme.textTheme,
        ),
      ),
      dark: darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          darkTheme.textTheme,
        ),
      ),
      builder: (lightTheme, darkTheme) {
        return MaterialApp.router(
          title: 'My App',
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: router,
          builder: (context, child) => GateWay(
            child: child ?? SplashView(),
          ),
        );
      },
    );
  }
}

class GateWay extends StatefulWidget {
  const GateWay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GateWay> createState() => _GateWayState();
}

class _GateWayState extends State<GateWay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: theme.textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}