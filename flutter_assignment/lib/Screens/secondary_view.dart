import 'package:flutter/material.dart';
import 'package:flutter_assignment/Models/Data.dart';
import 'package:flutter_assignment/Models/DataList.dart';

class SecondaryView extends StatefulWidget {
  final List<Data> dataList;
  const SecondaryView({Key? key, required this.dataList}) : super(key: key);

  @override
  State<SecondaryView> createState() => _SecondaryViewState();
}

class _SecondaryViewState extends State<SecondaryView> {
  int? _id;
  String? _url;
  String? _description;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.dataList[0].id;
    _url = widget.dataList[0].url;
    _description = widget.dataList[0].description;
  }

  void changeData() {
    if (_id == widget.dataList.last.id) {
      setState(() {
        _id = widget.dataList[0].id;
        _url = widget.dataList[0].url;
        _description = widget.dataList[0].description;
      });
    } else {
      setState(() {
        _url = widget.dataList[_id!].url;
        _description = widget.dataList[_id!].description;
        _id = widget.dataList[_id!].id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo appp"),
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
                children: [
                  if (_id == 1) Image.asset(_url!) else Image.network(_url!),
                  const SizedBox(height: 10),
                  if (_description !=
                      null) // Check for null before displaying text
                    Text(
                      _description!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: changeData,
                    child: const Text("cahnge"),
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
