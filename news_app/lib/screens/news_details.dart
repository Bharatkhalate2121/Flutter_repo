import 'package:flutter/material.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/utils/shimmer/shimmer.dart';
import 'package:news_app/widget/bottom_bar.dart';
import 'package:news_app/widget/relavant_news_row.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatelessWidget {
  final Map<String, dynamic> newsData;
  final bool? loadNext;
  NewsDetails({super.key, required this.newsData, this.loadNext});

  Future<void> _launchUrl(BuildContext context, String url) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Opening..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      final Uri uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        // mode: LaunchMode.externalApplication,
      );
      // Wait a moment before closing the dialog, optional
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context, rootNavigator: true).pop(); // Close the dialog

      if (!launched) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(); // Close the dialog if error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arg = (loadNext ?? false) ? {"loadNext": true} : {};
    arg.addEntries(
      {"category": newsData['description'] ?? newsData['title'] ?? ""}.entries,
    );

    final bool theme = Provider.of<ContextClass>(context, listen: true).theme;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("News App")),
      body: Shimmer(
        linearGradient: theme
            ? Constants.shimmerGradientLight
            : Constants.shimmerGradientDark,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,

                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      newsData['title'] ?? "",
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                      newsData['image_url'] ?? "",
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 400),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      newsData['description'] ?? newsData['title'] ?? "",
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          const Color.fromARGB(255, 30, 183, 243),
                        ),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.zero,
                        ), // to avoid extra vertical padding
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                      onPressed: () {
                        _launchUrl(
                          context,
                          newsData['link'] ?? "https://example.com",
                        );
                      },
                      child: Center(
                        child: Text(
                          "View Full Article",
                          style: TextStyle(
                            fontSize: 12, // fit better inside 20px height
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Relevant news",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  (loadNext ?? false)
                      ? RelavantNewsRow(
                          category:
                              newsData['category'].take(5).join(',') ??
                              "latest",
                          nextPage: Provider.of<ContextClass>(
                            context,
                            listen: true,
                          ).relevantNextPage,
                        )
                      : RelavantNewsRow(
                          category:
                              newsData['category'].take(5).join(',') ??
                              "latest",
                        ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "News From Same Source",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  (loadNext ?? false)
                      ? RelavantNewsRow(
                          source: newsData['source_id'] ?? "latest",
                          nextPage: Provider.of<ContextClass>(
                            context,
                            listen: true,
                          ).sourceNextPage,
                        )
                      : RelavantNewsRow(
                          source: newsData['source_id'] ?? "latest",
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
