import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:weather_app/api_calls/weather_api_call.dart";
import "package:weather_app/state.dart";
import "package:weather_app/widget/card_row_widget.dart";
import "package:weather_app/widget/card_widget.dart";
import "package:weather_app/widget/extra_info_cards.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WeatherApiCall.makeCall().then((data) {
      context.read<StateContext>().dataMapList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool theme = Provider.of<StateContext>(context, listen: true).theme;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double calculatedheight =
        height -
        ((height * 0.3) +
            (height * 0.1) +
            10 +
            (height * 0.2) +
            20 +
            20 +
            50 +
            130);
    final List<Map<String, dynamic>> dataMapList = Provider.of<StateContext>(
      context,
      listen: true,
    ).dataMapList;

    final index = Provider.of<StateContext>(context, listen: true).index;

    return MaterialApp(
      theme: (theme) ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.1,
          centerTitle: true,
          title: Text("Weather App"),
        ),
        body: Container(
          width: width,
          height: height,
          child: (dataMapList.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardWidget(),
                    SizedBox(height: 20),
                    Container(
                      width: (dataMapList.length * (height * 0.2 / 1.5) < width)
                          ? dataMapList.length * (height * 0.2 / 1.5)
                          : width,
                      height: 10 + (height * 0.2),
                      child: SizedBox(
                        height: 120,
                        child: SingleChildScrollView(
                          padding: EdgeInsetsGeometry.all(0),
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ...dataMapList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var ele = entry.value;

                                    return CardRowWidget(
                                      dataMap: ele,
                                      current_index: index,
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: (354 < width) ? 354 : width * 0.99,
                      height: 130,
                      child: ExtraInfoCards(dataMap: dataMapList[index]),
                    ),
                    SizedBox(
                      height: (calculatedheight > 0) ? calculatedheight : 1,
                    ),
                  ],
                )
              : Text("loading..."),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<StateContext>().theme = !theme;
          },
          child: (theme)
              ? const Icon(Icons.mode_night, size: 25)
              : const Icon(Icons.wb_sunny, size: 25),
        ),
      ),
    );
  }
}
