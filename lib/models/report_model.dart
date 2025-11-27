class ReportModel {
  final dynamic id;
  final String title;
  final String? url;
  final String? imageUrl;
  final String? summary;
  final String? newsSite;
  final String? publishedAt;

  ReportModel({
    required this.id,
    required this.title,
    this.url,
    this.imageUrl,
    this.summary,
    this.newsSite,
    this.publishedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      title: json['title'] ?? '',
      url: json['url'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      summary: json['summary'] ?? '',
      newsSite: json['news_site'] ?? '',
      publishedAt: json['published_at'] ?? json['publishedAt'],
    );
  }
}
