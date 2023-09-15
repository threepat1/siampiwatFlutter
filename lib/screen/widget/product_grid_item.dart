import 'package:flutter/material.dart';
import 'package:siampiwat/screen/product_detail.dart';

class ProductGridItem extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final Function(Map<String, dynamic>) onAddCart;

  const ProductGridItem({
    required this.product,
    required this.isLiked,
    required this.onLikePressed,
    required this.onAddCart,
  });

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    bool showText = false;
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                product: widget.product,
                addToCart: widget.onAddCart,
              ),
            ),
          );
        },
        child: GridTile(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                product['image_url'],
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    widget.onLikePressed();
                    _showFavourite(widget.isLiked);
                  },
                  child: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.isLiked ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.7),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
