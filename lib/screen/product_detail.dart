import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>)? addToCart;
  final bool isLiked; // Add isLiked property
  final VoidCallback onToggleLike; // Callback to toggle liked state

  const ProductDetailPage({
    this.addToCart,
    required this.product,
    required this.isLiked,
    required this.onToggleLike,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool? liked;
  _showFavourite(fav) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a GlobalKey for the AlertDialog
        final GlobalKey<State<StatefulWidget>> key = GlobalKey();
        Future.delayed(Duration(seconds: 1), () {
          // Check if the AlertDialog is still in the tree before trying to pop it
          if (key.currentContext != null) {
            Navigator.of(key.currentContext!).pop();
          }
        });
        return AlertDialog(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          key: key, // Assign the GlobalKey to the AlertDialog
          title: fav
              ? Center(
                  child: Text(
                  'Removed to Favorites',
                  style: TextStyle(color: Colors.white),
                ))
              : Center(
                  child: Text(
                  'Added to Favorites',
                  style: TextStyle(color: Colors.white),
                )),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liked = widget.isLiked;
  }

  @override
  showAddedCart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a GlobalKey for the AlertDialog
        final GlobalKey<State<StatefulWidget>> key = GlobalKey();
        Future.delayed(Duration(seconds: 1), () {
          // Check if the AlertDialog is still in the tree before trying to pop it
          if (key.currentContext != null) {
            Navigator.of(key.currentContext!).pop();
          }
        });
        return AlertDialog(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          key: key, // Assign the GlobalKey to the AlertDialog
          title: Center(
            child: Text(
              'Added to Cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.product['image_url'] ?? '',
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              widget.product['name'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${widget.product['price'] ?? 0.toStringAsFixed(2)}' ?? '',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.addToCart!(widget.product);
                showAddedCart();
              },
              child: Text('Add to Cart'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Toggle the liked state and call the callback
                widget.onToggleLike();
                _showFavourite(widget.isLiked);
                setState(() {
                  liked = !liked!;
                });
              },
              child: Icon(
                liked! ? Icons.favorite : Icons.favorite_border,
                color: liked! ? Colors.red : Colors.grey,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
