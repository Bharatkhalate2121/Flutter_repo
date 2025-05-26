import 'package:flutter/material.dart';
import 'package:news_app/api_calls/get_source_news.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/utils/shimmer/shimmer_loading.dart';
import 'package:provider/provider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/api_calls/get_relevant_news.dart';

class RelavantNewsRow extends StatefulWidget {
  final String? category;
  String? nextPage;
  final String? source;
  RelavantNewsRow({super.key, this.category, this.nextPage, this.source});

  @override
  State<RelavantNewsRow> createState() => _RelavantNewsRow();
}

class _RelavantNewsRow extends State<RelavantNewsRow> {
  late List<Map<String, dynamic>> newsData;
  bool loading = true;
  bool isLoading = false;

  void getData(BuildContext context) {
    String nextPage = (widget.category != null && widget.source == null)
        ? Provider.of<ContextClass>(context, listen: true).relevantNextPage
        : Provider.of<ContextClass>(context, listen: true).sourceNextPage;
    widget.nextPage = (widget.nextPage != null) ? widget.nextPage : nextPage;
    Future<List<Map<String, dynamic>>> getData =
        (widget.category != null && widget.source == null)
        ? GetRelevantNews.getNextData(
            category: widget.category ?? "latest",
            nextPage: widget.nextPage ?? "",
          )
        : GetSourceNews.getData(
            domain: widget.source ?? 'bbc',
            nextPage: widget.nextPage,
          );
    getData.then((data) {
      data.removeWhere((map) {
        if (map.containsKey("nextPage")) {
          context.read<ContextClass>().relevantNextPage = map['nextPage'];
          widget.nextPage = map['nextPage'];
          return true;
        }
        return false;
      });
      newsData = [...newsData, ...data];
      isLoading = false;
    });
  }

  Widget getWidget({required newsData}) {
    return Container(
      height: 200, // give height to constrain the ListView
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: newsData.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (!(index >= newsData.length)) {
            return GestureDetector(
              onTap: () {
                Provider.of<ContextClass>(context, listen: false).current =
                    newsData[index]['article_id'] ?? "";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NewsDetails(
                        newsData: newsData[index],
                        loadNext: true,
                      );
                    },
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        newsData[index]['image_url'] ?? "",
                        height: 100,
                        width: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 100),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${newsData[index]['title'].substring(0, newsData[index]['title'].length < 72 ? newsData[index]['title'].length : 72)}${newsData[index]['title'].length < 72 ? '' : '...'}',
                          style: TextStyle(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            if (!isLoading) {
              isLoading = true;
              getData(context);
            }
            return Center(
              widthFactor: 2,
              heightFactor: 2,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget getShimmerWidget() {
    return Container(
      height: 200, // give height to constrain the ListView
      padding: EdgeInsets.all(10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...[1, 1, 1, 1, 1, 1, 1, 1, 1, 1].map((news) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.all(5),
                width: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerLoading(
                        isLoading: true,
                        child: Card(child: Container(height: 100, width: 200)),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<List<Map<String, dynamic>>> getData =
          (widget.nextPage != null && widget.category != null)
          ? GetRelevantNews.getNextData(
              category: widget.category ?? "latest",
              nextPage: widget.nextPage ?? "",
            )
          : (widget.nextPage != null && widget.source != null)
          ? GetSourceNews.getData(
              domain: widget.source ?? 'bbc',
              nextPage: widget.nextPage,
            )
          : (widget.category != null)
          ? GetRelevantNews.getData(category: widget.category ?? "latest")
          : GetSourceNews.getData(domain: widget.source ?? 'bbc');

      getData.then((data) {
        data.removeWhere((map) {
          if (map.containsKey("nextPage")) {
            if (widget.category != null) {
              context.read<ContextClass>().relevantNextPage = map['nextPage'];
            } else {
              context.read<ContextClass>().sourceNextPage = map['nextPage'];
            }
            widget.nextPage = map['nextPage'];
            return true;
          }
          return false;
        });
        this.loading = false;
        
        this.newsData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return getWidget(newsData: newsData);
    } else {
      return getShimmerWidget();
    }
  }
}