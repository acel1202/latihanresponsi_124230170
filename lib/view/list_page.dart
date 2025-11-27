import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'package:intl/intl.dart';

String formatDate(String raw) {
  try {
    final date = DateTime.parse(raw);
    return DateFormat("MMMM dd, yyyy – HH:mm").format(date);
  } catch (e) {
    return raw;
  }
}

class ListPage extends StatefulWidget {
  final String menu;
  final String title;

  const ListPage({super.key, required this.menu, required this.title});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    items = await ApiService.fetchList(widget.menu);
    setState(() => loading = false);
  }

  Widget buildItem(Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                id: a["id"],
                menu: widget.menu,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (a["image_url"] != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  a["image_url"],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A2868),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a["news_site"] ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(a["published_at"] ?? ""),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black87,
                      size: 18,
                    ),
                  )
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
        title: Text(widget.title),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => buildItem(items[i]),
            ),
    );
  }
}
