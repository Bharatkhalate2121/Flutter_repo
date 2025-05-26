import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:provider/provider.dart';

class Courosal extends StatelessWidget {
  const Courosal({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ContextClass>(context, listen: true).courosalData;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: CarouselSlider(
        options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
        items: data
            .where((newsData) {
              return (newsData["image_url"] != null &&
                  newsData["title"] != null);
            })
            .map((newsData) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Provider.of<ContextClass>(
                        context,
                        listen: false,
                      ).current = newsData['article_id'] ?? "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetails(newsData: newsData),
                        ),
                      );

                      // GetRelevantNews.getData(
                      //   category: newsData['category'].take(5).join(','),
                      // ).then((data) {
                      //   data.where((listData) {
                      //     if (listData.containsKey("nextPage")) {
                      //       print("nextPage:"+listData['nextPage']);
                      //       context.read<ContextClass>().relevantNextPage = listData['nextPage'];
                      //       // Provider.of<ContextClass>(
                      //       //   context,
                      //       //   listen: true,
                      //       // ).relevantNextPage = listData['nextPage'];
                      //     }
                      //     return !listData.containsKey("nextPage");
                      //   }).toList();
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => NewsDetails(
                      //         newsData: newsData,
                      //       ),
                      //     ),
                      //   );
                      // });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              newsData['image_url'],
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: double.infinity),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (newsData['title'].length > 75
                                    ? newsData['title'].substring(0, 75) + "..."
                                    : newsData['title']),
                                maxLines: 3,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            })
            .toList(),
      ),
    );
  }
}
