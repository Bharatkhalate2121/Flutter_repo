import "package:flutter/material.dart";
import "package:currency_converter/my_app.dart";
import "package:provider/provider.dart";
import "package:currency_converter/context_class.dart";

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => ContextClass(), child: MyApp()),
  );
}
