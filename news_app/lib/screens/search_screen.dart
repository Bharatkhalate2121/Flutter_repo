import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:news_app/api_calls/search_news.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/screens/search_result_screen.dart';
import 'package:news_app/utils/shimmer/shimmer.dart';
import 'package:news_app/utils/shimmer/shimmer_loading.dart';

import 'package:news_app/widget/history_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? keyword;
  final TextEditingController _controller = TextEditingController(); // Add this
  bool loading = false;
  List<Map<String, dynamic>> data = [];
  bool isLoadingNext = false;
  Debouncer debouncer = new Debouncer(delay: Duration(seconds: 5));

  void getData({required String query, String? page}) {
    Future<List<Map<String, dynamic>>> getNews = (page != null)
        ? SearchNews.getData(query: query, nextPage: page)
        : SearchNews.getData(query: query);
    getNews.then((value) {
      if (!mounted) return;
      setState(() {
        data = [...data, ...value];
        isLoadingNext = false;
      });
    });
  }

  Future<void> addSearchToHistory(String searchTerm) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> history = pref.getStringList('history') ?? [];

    // Remove if already exists to re-add it at the top
    history.remove(searchTerm);
    history.insert(0, searchTerm);

    // Optional: Limit history to latest 20 items
    if (history.length > 20) {
      history = history.sublist(0, 20);
    }

    await pref.setStringList('history', history);
  }

  void getDebouncedData() {
    Future<List<Map<String, dynamic>>> getNews = SearchNews.getData(
      query: keyword ?? '',
    );
    getNews.then((value) {
      if (!mounted) return;
      setState(() {
        data = value;
        isLoadingNext = false;
        loading = false;
      });
    });
  }

  Widget getContent(BuildContext context) {
    return ((keyword != null && keyword!.trim().isNotEmpty))
        ? ListView.builder(
            physics: loading
                ? const NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemCount: (data.length == 0) ? 10 : data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (data.isNotEmpty && index >= data.length) {
                if (!isLoadingNext) {
                  isLoadingNext = true;
                  getData(
                    query: keyword ?? '',
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
                Map<String, dynamic> dummyData = (data.length != 0)
                    ? data[index]
                    : {};
                return getRow(context, dummyData);
              }
            },
          )
        : HistoryList();
  }

  Widget getRow(BuildContext context, Map<String, dynamic> newsData) {
    final theme = Provider.of<ContextClass>(context).theme;
    final title = newsData["title"] ?? "";
    final isLong = title.length > 95;
    final displayTitle = isLong ? title?.substring(0, 95) : title;

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
                child: (data.isNotEmpty && !loading)
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: theme ? Colors.black : Colors.white,
                          ),
                          children: [
                            TextSpan(text: displayTitle ?? ''),
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
                      )
                    : ShimmerLoading(
                        isLoading: loading,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(width: 10),
              // Image Container
              Expanded(
                flex: 4,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: (data.length != 0 && !loading)
                      ? Image.network(
                          newsData["image_url"] ?? "",
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 100),
                        )
                      : ShimmerLoading(
                          isLoading: loading,
                          child: Card(
                            child: Container(
                              height: 100,
                              width: double.infinity,
                            ),
                          ),
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
    final bool theme = Provider.of<ContextClass>(context, listen: true).theme;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("News App")),
      body: Shimmer(
        linearGradient: theme
            ? Constants.shimmerGradientLight
            : Constants.shimmerGradientDark,
        child: ListView(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              controller: _controller,
                              onFieldSubmitted: (value) => {
                                if (!loading &&
                                    data.isNotEmpty &&
                                    !value.trim().isEmpty)
                                  {
                                    addSearchToHistory(value),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            new SearchResultScreen(
                                              keyword: value,
                                              data: data,
                                            ),
                                      ),
                                    ),
                                  },
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty) {
                                  setState(() {
                                    keyword = value;
                                    loading = true;
                                  });
                                  debouncer.call(getDebouncedData);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                keyword = '';
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.done, color: Colors.grey),
                            onPressed: () {
                              if (!loading && data.isNotEmpty) {
                                addSearchToHistory(keyword ?? '');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        new SearchResultScreen(
                                          keyword: keyword ?? '',
                                          data: data,
                                        ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: getContent(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
