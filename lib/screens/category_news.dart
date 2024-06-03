import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/show_category.dart';
import 'package:newsapp/screens/article_view.dart';
import 'package:newsapp/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  CategoryNews({required this.name, super.key});
  String name;

  @override
  State<StatefulWidget> createState() {
    return _CategoryNewsState();
  }
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModal> categories = [];
  bool _loading = true;

  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(widget.name.toLowerCase());
    categories = showCategoryNews.categoriesNews;
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
            Text(widget.name,
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
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ShowCategory(
                image: categories[index].urlToImage!,
                title: categories[index].title!,
                desc: categories[index].description!,
                url: categories[index].url!,
              );
            }),
      ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  ShowCategory({
    required this.desc,
    required this.image,
    required this.title,
    required this.url,
  });

  final String image, desc, title, url;

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
