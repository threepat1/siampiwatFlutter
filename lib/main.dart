import 'package:flutter/material.dart';
import 'package:siampiwat/screen/widget/product_grid_item.dart';
import 'package:siampiwat/screen/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Pages(),
    );
  }
}
