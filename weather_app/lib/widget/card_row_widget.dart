import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:weather_app/state.dart";

class CardRowWidget extends StatelessWidget {
  Map<String, dynamic> dataMap;
  int current_index;
  CardRowWidget({
    super.key,
    required this.dataMap,
    required this.current_index,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.2;
    final double width = height / 1.5;
    final bool border =
        (Provider.of<StateContext>(context, listen: true).index ==
            current_index)
        ? true
        : false;
    return InkWell(
      onTap: () {
        context.read<StateContext>().index = current_index;
      },
      child: Card(
        margin: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          spacing: 0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height,
              decoration: border
                  ? BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 0,
                children: [
                  Image(
                    height: height * 0.6,
                    width: width,
                    image: NetworkImage(
                      "https://openweathermap.org/img/wn/${dataMap["weather"][0]["icon"]}.png",
                    ),
                  ),
                  SizedBox(
                    height: height * 0.3,
                    child: Column(
                      children: [
                        Text(
                          "${dataMap["name"]}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text("${dataMap["main"]["temp"]}°"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
