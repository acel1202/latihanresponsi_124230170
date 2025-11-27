import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../controllers/article_controller.dart';
import '../controllers/blog_controller.dart';
import '../controllers/report_controller.dart';

String formatDate(String raw) {
  try {
    final date = DateTime.parse(raw);
    return DateFormat("MMMM dd, yyyy").format(date);
  } catch (e) {
    return raw;
  }
}

class DetailPage extends StatefulWidget {
  final dynamic id;
  final String menu;

  const DetailPage({
    super.key,
    required this.id,
    required this.menu,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    if (widget.menu == "articles") {
      data = await ArticleController().getDetail(widget.id);
    } else if (widget.menu == "blogs") {
      data = await BlogController().getDetail(widget.id);
    } else if (widget.menu == "reports") {
      data = await ReportController().getDetail(widget.id);
    }

    setState(() => loading = false);
  }

  Future<void> openUrl(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("URL tidak tersedia")));
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A2868),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("News Detail"),
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : buildDetailContent(),
    );
  }

  Widget buildDetailContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          if (data!["image_url"] != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                data!["image_url"],
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 20),

          // TITLE
          Text(
            data!["title"] ?? "",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          // SITE
          Text(
            data!["news_site"] ?? "",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 4),

          // DATE
          Text(
            formatDate(data!["published_at"] ?? ""),
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          // SUMMARY
          Text(
            data!["summary"] ?? "",
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 30),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () => openUrl(data!["url"]),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                minimumSize: const Size(10, 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text(
                "See more…",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 40), // aman dari navbar
        ],
      ),
    );
  }
}
