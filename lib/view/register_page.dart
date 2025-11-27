import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool loading = false;
  final auth = AuthController();

  Widget inputField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
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

  Future<void> doRegister() async {
    final u = user.text.trim();
    final p = pass.text.trim();

    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username dan password wajib diisi!")));
      return;
    }

    setState(() => loading = true);
    await auth.register(u, p);
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A2868)),
              ),
              const SizedBox(height: 12),
              const Text("Register now and start exploring space content!",
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 32),
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
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    inputField(label: "Username", controller: user),
                    inputField(
                        label: "Password", controller: pass, obscure: true),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : doRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4BBC),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    )
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
