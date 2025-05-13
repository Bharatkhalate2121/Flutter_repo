import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:provider/provider.dart';

class NewsRows extends StatelessWidget {
  const NewsRows({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ContextClass>(context, listen: true).data;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.535,
      // Removed circular shape which doesn't fit list view layout
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ...data.where((newsData){
            return (newsData["image_url"] != null && newsData["title"] != null);
          }).map<Widget>((newsData) {
            
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: InkWell(
                onTap: () {
                  print("Tapped news $newsData");
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
                            text: newsData["title"].substring(0, (newsData["title"].length>90)? 90:newsData["title"].length),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Provider.of<ContextClass>(
                                    context,
                                    listen: true,
                                  ).theme
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            children: [
                              TextSpan(text: "..."),
                              TextSpan(
                                text: "more",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("Read more tapped");
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
                          child: Image.network(
                            height: 100,
                            newsData["image_url"],
                            fit: BoxFit.cover,
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
}
