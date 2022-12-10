import 'package:flutter/cupertino.dart';
import 'package:iug/helpers/db_helper.dart';
import 'package:iug/models/article.dart';

class DatebaseProvider with ChangeNotifier {
  List<Article> _postsList = [];

  List<Article> get postsList {
    return [..._postsList];
  }

  void addArticle(Article article, String table) {
    DBHelper.insert(table, {
      'id': article.id!,
      'title': article.title!,
      'excerpt': article.excerpt!,
      'content': article.content!,
      'date': article.date!,
    });
  }

  Future<void> fetchAndSetPosts() async {
    final dataList = await DBHelper.getData("posts");
    _postsList = dataList
        .map((post) => Article(
              id: int.parse(post['id']),
              title: post['title'],
              excerpt: post['excerpt'],
              content: post['content'],
              date: post['date'],
            ))
        .toList();
    notifyListeners();
  }
}
