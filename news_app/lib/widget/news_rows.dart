import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api_calls/get_latest_news.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/widget/Timer_widget.dart';
import 'package:news_app/widget/courosal.dart';
import 'package:provider/provider.dart';

class NewsRows extends StatelessWidget {
  const NewsRows({super.key});

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
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        Constants.refreshIndicatorKey;
    final data = Provider.of<ContextClass>(context, listen: true).data;
    bool isLoading = false;
    bool doShowDialog = Provider.of<ContextClass>(
      context,
      listen: true,
    ).showDialog;

    void getData() {
      GetLatestNews.getDataForRow(
        Provider.of<ContextClass>(context, listen: true).nextPage,
      ).then((data) {
        late String nextPage;
        data.removeWhere((map) {
          if (map.containsKey("nextPage")) {
            nextPage = map["nextPage"];
            return true; // remove this map
          }
          return false;
        });
        context.read<ContextClass>().data = [
          ...Provider.of<ContextClass>(context, listen: false).data,
          ...data,
        ];
        context.read<ContextClass>().nextPage = nextPage;
        isLoading = false;
      });
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.85,
      // Removed circular shape which doesn't fit list view layout
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _refreshIndicatorKey.currentState?.show();
          await context.read<ContextClass>().refreshData(context);
        },
        child: ListView.builder(
          itemCount: data.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index >= data.length) {
              if (!isLoading) {
                isLoading = true;
                getData();
              }
              return Center(
                widthFactor: 2,
                heightFactor: 2,
                child: CircularProgressIndicator(),
              );
            } else if (index == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Courosal(),
                  getRow(context, data[index]),

                  // if (doShowDialog &&
                  //     !Provider.of<ContextClass>(
                  //       context,
                  //       listen: true,
                  //     ).isLoged &&
                  //     (ModalRoute.of(context)?.settings.name == '/' ||
                  //         ModalRoute.of(context)?.settings.name == 'search'))
                  //   Builder(
                  //     builder: (context) {
                  //       WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         showDialog(
                  //           context: context,
                  //           barrierDismissible:
                  //               false, // Disable Android back button
                  //           builder: (context) => PopScope(
                  //             child: Stack(
                  //               children: [
                  //                 // This prevents tap outside to dismiss (by not allowing touches to leak)
                  //                 ModalBarrier(
                  //                   dismissible: false,
                  //                   color: Colors.black54,
                  //                 ),
                  //                 Center(child: Dialog(child: TimerWidget())),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       });
                  //       return SizedBox.shrink(); // Placeholder
                  //     },
                  //   ),
                ],
              );
            } else {
              return getRow(context, data[index]);
            }
          },
        ),
      ),
    );
  }
}
