import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = AuthController();

  Future<void> logoutManual() async {
    await auth.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1E8FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 50, color: const Color(0xFF3A2868)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A2868),
                      )),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hai, Username!"),
        actions: [
          IconButton(onPressed: logoutManual, icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView(
        children: [
          buildMenuCard(
            title: "News",
            subtitle: "Latest SpaceFlight news from trusted sources.",
            icon: Icons.article_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ListPage(menu: "articles", title: "Berita Terkini"),
              ),
            ),
          ),
          buildMenuCard(
            title: "Blog",
            subtitle: "More detailed insights and mission breakdowns.",
            icon: Icons.menu_book_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ListPage(menu: "blogs", title: "Blog Space"),
              ),
            ),
          ),
          buildMenuCard(
            title: "Report",
            subtitle: "Reports from space agencies & missions.",
            icon: Icons.insert_chart_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ListPage(menu: "reports", title: "Laporan Misi"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
