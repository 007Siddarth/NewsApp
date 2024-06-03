import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/slider_model.dart';
import 'package:newsapp/screens/article_view.dart';
import 'package:newsapp/services/news.dart';
import 'package:newsapp/services/slider_data.dart';

class AllNews extends StatefulWidget {
  AllNews({required this.news});
  String news;
  @override
  State<StatefulWidget> createState() {
    return _AllNewsState();
  }
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.slider;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.news,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              " News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount:
                widget.news == "Breaking" ? sliders.length : articles.length,
            itemBuilder: (context, index) {
              return AllNewsSection(
                image: widget.news == "Breaking"
                    ? sliders[index].urlToImage!
                    : articles[index].urlToImage!,
                title: widget.news == "Breaking"
                    ? sliders[index].title!
                    : articles[index].title!,
                desc: widget.news == "Breaking"
                    ? sliders[index].description!
                    : articles[index].description!,
              );
            }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  AllNewsSection({
    required this.desc,
    required this.image,
    required this.title,
  });

  final String image, desc, title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ArticleView(image: image, title: title, description: desc)));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error),
                    SizedBox(height: 8),
                    Text("Unable to load image"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
