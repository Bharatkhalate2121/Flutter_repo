import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/screens/home_screen_shimmer.dart';
import 'package:news_app/widget/bottom_bar.dart';
import 'package:news_app/widget/news_rows.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ContextClass>(context, listen: true).data;
    final courosalData = Provider.of<ContextClass>(
      context,
      listen: true,
    ).courosalData;

    return Scaffold(
      appBar: AppBar(title: const Text("News App"), centerTitle: true),
      bottomNavigationBar: BottomBar(),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                IconButton(
                  onPressed: () => {
                    print("Home"),
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                  },
                  icon: Icon(Icons.home),
                ),
                IconButton(
                  onPressed: () => {print("User")},
                  icon: Icon(Icons.person),
                ),
                IconButton(
                  onPressed: () => {print("Search")},
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () => {Navigator.pop(context), print("closed")},
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
      body: (data.length > 1 && courosalData.length > 1)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [NewsRows()],
            )
          : HomeScreenShimmer(
              theme: Provider.of<ContextClass>(context, listen: true).theme,
            ),
    );
  }
}
