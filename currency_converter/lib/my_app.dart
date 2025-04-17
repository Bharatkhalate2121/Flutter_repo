import "package:currency_converter/context_class.dart";
import "package:flutter/material.dart";
import 'package:get/get.dart';
import "package:currency_converter/text_field_widget.dart";
import "package:currency_converter/button_widget.dart";
import "package:provider/provider.dart";

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt inr = context.watch<ContextClass>().inr;
    final RxInt usd = context.watch<ContextClass>().usd;
    final convert = Provider.of<ContextClass>(context, listen: false).convert;

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Currency Converter"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  "${usd.value}",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              TextFieldWidget(inr: inr),
              ButtonWidget(convert: convert),
            ],
          ),
        ),
      ),
    );
  }
}
