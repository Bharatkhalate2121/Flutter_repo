import 'package:flutter/material.dart';
import "package:weather_app/screen/home_screen.dart";
import "package:provider/provider.dart";
import "package:weather_app/state.dart";

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => StateContext(), child: HomeScreen()),
  );
}
