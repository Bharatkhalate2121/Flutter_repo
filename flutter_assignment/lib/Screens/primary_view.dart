import 'package:flutter/material.dart';
import 'package:flutter_assignment/Models/Data.dart';
import 'package:flutter_assignment/Widget/FormWidget.dart';
import 'package:flutter_assignment/Widget/ViewDataBtn.dart';

class PrimaryView extends StatefulWidget {
  const PrimaryView({Key? key}) : super(key: key);

  @override
  State<PrimaryView> createState() => _PrimaryViewState();
}

class _PrimaryViewState extends State<PrimaryView> {
  int state = 0;
  Data? formData;
  List<Data> dataList = [];

  @override
  initState() {
    Data d = new Data(1, "assets/images/demo_img.jpeg", "Image from local");
    dataList.add(d);
  }

  void formSubmit(Data incomingFormData) {
    setState(() {
      formData = incomingFormData;
      formData!.id = getIndex();
      dataList.add(formData!);
      for (var data in dataList) print(data);
    });
  }

  int getIndex() {
    if (dataList.length != 0) {
      int id = dataList.last.id;
      return ++id;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Demo app"),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 207, 205, 205),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                margin: const EdgeInsets.all(20),
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppBar(title: const Text("Form"), centerTitle: true),
                    const SizedBox(height: 20),
                    FormWidget(onFormSubmit: formSubmit),
                    const SizedBox(height: 30),
                    ViewDataBtn(dataList: dataList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
