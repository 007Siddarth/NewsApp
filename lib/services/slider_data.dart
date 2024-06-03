import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/models/slider_model.dart';

class Sliders {
  List<SliderModel> slider = [];
  Future<void> getSlider() async {
    String url =
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=c99ab8ed80ac4b8ca453ae137da0bf76";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          SliderModel sliderModel = SliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          slider.add(sliderModel);
        }
      });
    }
  }
}
