import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:currency_converter/button_widget.dart";

class TextFieldWidget extends StatelessWidget {
  final RxInt inr;
  const TextFieldWidget({super.key, required this.inr});

  @override
  Widget build(BuildContext Context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter Amount",
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                inr.value = int.parse(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
