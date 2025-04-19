import "package:flutter/material.dart";

class ExtraInfoCards extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  const ExtraInfoCards({super.key, required this.dataMap});

  Widget build(BuildContext context) {
    int unixTimestamp = dataMap["sys"]["sunrise"];
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      unixTimestamp * 1000,
      isUtc: true,
    );
    String sunriseTime =
        "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:"
        "${time.second.toString().padLeft(2, '0')}";

    unixTimestamp = dataMap["sys"]["sunset"];
    time = DateTime.fromMillisecondsSinceEpoch(
      unixTimestamp * 1000,
      isUtc: true,
    );
    String sunsetTime =
        "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:"
        "${time.second.toString().padLeft(2, '0')}";

    return Row(
      spacing: 10,
      children: [
        Card(
          elevation: 10,
          child: SizedBox(
            height: 120,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.air_sharp),
                SizedBox(height: 10),

                Text("${dataMap["wind"]["speed"]}"),
                SizedBox(height: 5),

                Text("${dataMap["wind"]["deg"]}°"),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Card(
          elevation: 10,
          child: SizedBox(
            height: 120,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.device_thermostat),
                SizedBox(height: 10),
                Text("${dataMap["main"]["pressure"]}"),
                SizedBox(height: 5),
                Text("${dataMap["main"]["humidity"]}"),
              ],
            ),
          ),
        ),

        Card(
          elevation: 10,
          child: SizedBox(
            height: 120,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.sunny),
                SizedBox(height: 10),
                Text("$sunriseTime"),
                SizedBox(height: 5),
                Text("$sunsetTime"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
