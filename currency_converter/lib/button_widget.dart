import "package:flutter/material.dart";

class ButtonWidget extends StatelessWidget {
  final Function convert;
  const ButtonWidget({super.key, required Function this.convert});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        fixedSize: WidgetStateProperty.all(Size(400, 50)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        ),
      ),
      onPressed: () {
        convert();
      },
      child: Text("Convert"),
    );
  }
}
