import 'package:flutter/material.dart';
import 'package:flutter_assignment/Models/Data.dart';
import 'package:flutter_assignment/Screens/secondary_view.dart';

class ViewDataBtn extends StatefulWidget {
  final List<Data> dataList;
  const ViewDataBtn({Key? key, required this.dataList}) : super(key: key);
  @override
  State<ViewDataBtn> createState() => _ViewDataBtnState();
}

class _ViewDataBtnState extends State<ViewDataBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SecondaryView(dataList: widget.dataList),
          ),
        );
      },
      child: const Text("View Data"),
    );
  }
}
