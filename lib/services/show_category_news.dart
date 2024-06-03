import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/models/show_category.dart';
import 'package:newsapp/models/slider_model.dart';
import 'package:newsapp/screens/category_news.dart';

class ShowCategoryNews {
  List<ShowCategoryModal> categoriesNews = [];
  Future<void> getCategoriesNews(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=c99ab8ed80ac4b8ca453ae137da0bf76";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ShowCategoryModal categoryModal = ShowCategoryModal(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          categoriesNews.add(categoryModal);
        }
      });
    }
  }
}
