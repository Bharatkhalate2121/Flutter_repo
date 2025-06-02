import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:weather_app/state.dart";
import 'package:flutter/foundation.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataMapList = Provider.of<StateContext>(
      context,
      listen: true,
    ).dataMapList;
    final index = Provider.of<StateContext>(context, listen: true).index;
    final double width = MediaQuery.of(context).size.width * 1;
    final double height = MediaQuery.of(context).size.height;
    return Card(
      margin: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 30),
      elevation: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: (width * 0.85 > 400) ? 400 : width * 0.85,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsGeometry.all(23),
                  height: height * 0.2,
                  width: (width > 300) ? 300 : width,
                  child: Image.asset(
                    kIsWeb
                        ? "images/${dataMapList[index]["weather"][0]["icon"]}.png"
                        : "assets/images/${dataMapList[index]["weather"][0]["icon"]}.png",
                  ),
                ),

                Container(
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Text(
                        "${dataMapList[index]["name"]}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text("${dataMapList[index]["main"]["temp"]}°"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
