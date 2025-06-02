import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/widget/Timer_widget.dart';
import 'package:news_app/widget/auth.dart';
import 'package:news_app/widget/bottom_bar.dart';
import 'package:news_app/widget/user_widget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  bool? loginPage = true;
  UserScreen({super.key, this.loginPage});

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (loginPage ?? false) {
      bodyContent = Auth(); // add key if needed
    } else {
      bodyContent = context.select<ContextClass, bool>((ctx) => ctx.isLoged)
          ? const UserWidget(userName: "bharat")
          : const TimerWidget();
    }
    return Scaffold(
      body: const UserWidget(
        userName: "bharat",
      ), //bodyContent, //UserWidget(userName: 'bharat'),
      bottomNavigationBar: BottomBar(),
    );
  }
}
