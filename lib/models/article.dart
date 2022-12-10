class Article {
  int? id;
  String? date;
  String? title;
  String? content;
  String? excerpt;

  Article({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.excerpt,
  });

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id']!;
    date = json['date']!;
    title = json['title']!;
    content = json['content']!;
    excerpt = json['excerpt']!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['title'] = title;
    data['content'] = content;
    data['excerpt'] = excerpt;

    return data;
  }

  
}
