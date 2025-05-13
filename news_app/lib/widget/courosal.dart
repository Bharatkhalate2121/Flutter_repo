import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:provider/provider.dart';

class Courosal extends StatelessWidget {
  const Courosal({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ContextClass>(context, listen: true).data;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: CarouselSlider(
        options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
        items: data.where((newsData){
          return (newsData["image_url"] != null && newsData["title"] != null);
        }).map((newsData) {
          
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    // Handle the button tap here
                    print('Image tapped');
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
                              (newsData['title'].length > 50
                                  ? newsData['title'].substring(0, 50) + "..."
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
    
        }).toList(),
      ),
    );
  }
}
