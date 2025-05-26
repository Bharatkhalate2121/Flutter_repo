import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/utils/shimmer/shimmer.dart';
import 'package:news_app/utils/shimmer/shimmer_loading.dart';

class HomeScreenShimmer extends StatelessWidget {
  final bool theme; //true->light, false->dark
  HomeScreenShimmer({super.key, required this.theme});

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient:
          MediaQuery.of(context).platformBrightness != Brightness.dark
          ? Constants.shimmerGradientLight
          : Constants.shimmerGradientDark,
      child: ListView(
        physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
        children: [
          _buildCourosalItem(context),
          ...[1, 1, 1, 1, 1, 1, 1, 1, 1].map((e) => _buildListItem(context)),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Text Column
              Expanded(
                flex: 6,
                child: ShimmerLoading(
                  isLoading: _isLoading,
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
                child: ShimmerLoading(
                  isLoading: _isLoading,
                  child: Card(
                    child: Container(height: 100, width: double.infinity),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourosalItem(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: CarouselSlider(
        options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((newsData) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
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

                        child: ShimmerLoading(
                          isLoading: _isLoading,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Card(),
                          ),
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
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "",
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
