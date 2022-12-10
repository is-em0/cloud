import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iug/helpers/firestore_helper.dart';
import 'package:iug/providers/database_provider.dart';
import '../models/article.dart';

class ListPosts with ChangeNotifier {
  final List<Article> _postsList = [];

  List<Article> get postsList {
    return [..._postsList];
  }

  Future<void> fetchPosts(int page) async {
    String url = 'https://www.iugaza.edu.ps/wp-json/wp/v2/posts?page=$page';
    try {
      final Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        // _postsList.addAll(data(response.data));
        data(response.data);
        notifyListeners();
      } else {
        print("Bad Response On request fetchNews");
      }
    } catch (_) {}
  }

  List<Article> data(List<dynamic> input) {
    final List<Article> loadedItems = [];

    for (var e in input) {
      final Article article = Article(
        id: e["id"] ?? "",
        content: e["content"]["rendered"] ?? "",
        date: e["date"] ?? "",
        excerpt: e["excerpt"]["rendered"] ?? "",
        title: e["title"]["rendered"] ?? "",
      );
      loadedItems.insert(0, article);
      DatebaseProvider().addArticle(article, "posts");
      addPost(article);
    }
    return loadedItems;
  }

  Future<List<Article>> getAllPosts() async {
    _postsList.clear();
    _postsList.addAll(
        await FireStoreHelper.fireStoreHelper.getAllPostsFromFirestore());
    notifyListeners();
    return _postsList;
  }

  Future<void> addPost(Article article) async {
    await FireStoreHelper.fireStoreHelper.addPostToFirestore(article);
  }
}
