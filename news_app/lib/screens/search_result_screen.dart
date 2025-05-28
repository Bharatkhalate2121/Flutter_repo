import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:news_app/api_calls/search_news.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/widget/bottom_bar.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;
  final List<Map<String, dynamic>> data;
  const SearchResultScreen({
    super.key,
    required this.keyword,
    required this.data,
  });
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late List<Map<String, dynamic>> data;
  bool isLoadingNext = false;
  Debouncer debouncer = new Debouncer(delay: Duration(seconds: 5));

  void getData({required String query, String? page}) {
    Future<List<Map<String, dynamic>>> getNews = (page != null)
        ? SearchNews.getData(query: query, nextPage: page)
        : SearchNews.getData(query: query);
    getNews.then((value) {
      setState(() {
        data = [...data, ...value];
        isLoadingNext = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  Widget getContent(BuildContext context) {
    return ListView.builder(
      itemCount: data.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (data.isNotEmpty && index >= data.length) {
          if (!isLoadingNext) {
            isLoadingNext = true;
            getData(
              query: widget.keyword,
              page: Provider.of<ContextClass>(
                context,
                listen: false,
              ).searchNextPage,
            );
          }
          return Center(
            widthFactor: 2,
            heightFactor: 2,
            child: CircularProgressIndicator(),
          );
        } else {
          return getRow(context, data[index]);
        }
      },
    );
  }

  Widget getRow(BuildContext context, Map<String, dynamic> newsData) {
    final theme = Provider.of<ContextClass>(context).theme;
    final title = newsData["title"] ?? "";
    final isLong = title.length > 95;
    final displayTitle = isLong ? title.substring(0, 95) : title;

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Provider.of<ContextClass>(context, listen: false).current =
              newsData['article_id'] ?? "";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetails(newsData: newsData),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Text Column
              Expanded(
                flex: 6,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: theme ? Colors.black : Colors.white,
                    ),
                    children: [
                      TextSpan(text: displayTitle),
                      if (isLong) TextSpan(text: "... "),
                      if (isLong)
                        TextSpan(
                          text: "more",
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Read more tapped");
                              // Optionally navigate or expand the text
                            },
                        ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10),
              // Image Container
              Expanded(
                flex: 4,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    newsData["image_url"] ?? "",
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("News App")),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: getContent(context),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
