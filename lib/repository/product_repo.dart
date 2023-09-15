import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ProductRepository {
  Future<List<dynamic>> loadProductData() async {
    try {
      // Load JSON data from the asset
      String data = await rootBundle.loadString('lib/data/mockproduct.json');
      final jsonData = json.decode(data);
      final products = jsonData['product_items'];
      return products;
    } catch (e) {
      print("Error loading product data: $e");
      return [];
    }
  }
}
