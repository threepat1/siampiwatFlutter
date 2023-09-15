import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, int> productQuantities;
  final double total;

  CheckoutPage({
    required this.cartItems,
    required this.productQuantities,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: 'https://payment.spw.challenge/checkout?price=\$$total',
              size: 280,
              // You can include embeddedImageStyle Property if you
              //wanna embed an image from your Asset folder
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(
                  100,
                  100,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Scan & Pay', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Price: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
