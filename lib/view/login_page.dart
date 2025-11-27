import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthController();
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool remember = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadSaved();
  }

  Future<void> loadSaved() async {
    final saved = await auth.getSavedUsername();
    if (saved != null) {
      user.text = saved;
      remember = true;
      setState(() {});
    }
  }

  Future<void> handleLogin() async {
    setState(() => loading = true);

    final success =
        await auth.login(user.text.trim(), pass.text.trim(), remember);

    setState(() => loading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau Password salah.")),
      );
    }
  }

  Widget inputField(
      {required String label,
      required TextEditingController controller,
      bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Color(0xFF3A2868))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF4EEFF),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE4FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
          child: Column(
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A2868),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue exploring space news",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // Card container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    inputField(label: "Username", controller: user),
                    inputField(
                        label: "Password", controller: pass, obscure: true),
                    Row(
                      children: [
                        Checkbox(
                          value: remember,
                          onChanged: (v) =>
                              setState(() => remember = v ?? false),
                          activeColor: const Color(0xFF6A4BBC),
                        ),
                        const Text("Remember me"),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage())),
                          child: const Text("Register"),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4BBC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
