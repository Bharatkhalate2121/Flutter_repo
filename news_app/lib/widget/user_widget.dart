import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String userName;
  const UserWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Container(
          padding: EdgeInsets.all(16),
          child: Icon(
            Icons.person,
            size: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
        Text(userName),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red[600]),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            fixedSize: WidgetStatePropertyAll(
              Size.fromWidth(MediaQuery.of(context).size.width * 0.5),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(5),
              ),
            ),
          ),
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('Log Out'), Icon(Icons.logout)],
          ),
        ),
      ],
    );
  }
}
