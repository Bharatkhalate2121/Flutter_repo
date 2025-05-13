import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/widget/courosal.dart';
import 'package:news_app/widget/news_rows.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ContextClass>(context, listen: true).data;
    return Scaffold(
      appBar: AppBar(title: const Text("News App"), centerTitle: true),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 10,
          children: [
            IconButton(
              onPressed: () => {print("home")},
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
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                IconButton(
                  onPressed: () => {print("home")},
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: (data.length>1) ?[Courosal(), NewsRows()]:[Text("Loading")],
      ),
    );
  }
}
