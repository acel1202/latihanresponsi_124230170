import 'package:flutter/material.dart';
import 'view/login_page.dart';
import 'view/home_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/session_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SpaceFlight App",
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const EntryCheck(),
    );
  }
}

class EntryCheck extends StatefulWidget {
  const EntryCheck({super.key});

  @override
  State<EntryCheck> createState() => _EntryCheckState();
}

class _EntryCheckState extends State<EntryCheck> with WidgetsBindingObserver {
  final auth = AuthController();
  bool? stillLoggedIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLogin();
  }

  Future<void> checkLogin() async {
    stillLoggedIn = await auth.isStillLoggedIn();
    setState(() {});
  }

  /// Deteksi lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // App ke background
    if (state == AppLifecycleState.paused) {
      await SessionController.saveLastActive();
    }

    // App kembali dari background
    if (state == AppLifecycleState.resumed) {
      final expired = await SessionController.isExpired();

      if (expired) {
        await auth.logout();

        if (!mounted) return;

        /// Tampilkan popup session expired
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Session Expired"),
            content: const Text(
                "You have been away for too long. Please login again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (stillLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return stillLoggedIn! ? const HomePage() : const LoginPage();
  }
}
