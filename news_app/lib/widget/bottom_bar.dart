import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 10,
        children: [
          IconButton(
            onPressed: () async {
              Constants.refreshIndicatorKey.currentState?.show();
              await context.read<ContextClass>().refreshData(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              print("home");
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
        ],
      ),
    );
  }
}
