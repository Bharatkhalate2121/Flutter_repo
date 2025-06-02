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
              if (ModalRoute.of(context)?.settings.name == '/') {
                await Constants.refreshIndicatorKey.currentState?.show();
                await context.read<ContextClass>().refreshData(context);
                print("home");
                return;
              }
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              print("home");
            },

            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async {
              if (ModalRoute.of(context)?.settings.name == '/users') {
                return;
              }
              Navigator.pushNamed(context, '/users');
              print("user");
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () => {
              Navigator.pushNamed(context, '/search'),
              print("Search"),
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
