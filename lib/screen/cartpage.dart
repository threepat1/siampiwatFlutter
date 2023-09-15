import 'package:flutter/material.dart';
import 'package:siampiwat/screen/checkout.dart';

class cartScreen extends StatefulWidget {
  const cartScreen({
    Key? key,
    required this.cartList,
    required this.selectedProducts,
  }) : super(key: key);

  final List<Map<String, dynamic>> cartList;
  final List<Map<String, dynamic>> selectedProducts;

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  Map<String, int> productQuantities = {};
  double total = 0.0;
  List<Map<String, dynamic>> filteredCartList = [];
  Set<String> uniqueProductIds = Set();

  @override
  void initState() {
    super.initState();
    // Calculate the initial total price when the widget is created
    total = calculateTotalPrice();
  }

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

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (final product in widget.cartList) {
      final productId = product['id'].toString();
      if (!uniqueProductIds.contains(productId)) {
        uniqueProductIds.add(productId);
        filteredCartList.add(product);
      }
    }

    for (var product in filteredCartList) {
      final productId = product['id'].toString();
      final quantity = productQuantities[productId] ?? 1;

      totalPrice += product['price'] * quantity;
    }

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    for (final product in widget.cartList) {
      final productId = product['id'].toString();
      if (!uniqueProductIds.contains(productId)) {
        uniqueProductIds.add(productId);
        filteredCartList.add(product);
      }
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: filteredCartList.length,
        itemBuilder: (BuildContext context, int index) {
          final product = filteredCartList[index];
          final bool isLiked = widget.selectedProducts.contains(product);

          // Get the product's ID
          final productId = product['id'].toString();

          // Get the quantity for the product, default to 1 if not set
          final quantity = productQuantities[productId] ?? 1;

          return SlideMenu(
            menuItems: [
              Container(
                color: Colors.redAccent,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.cartList.removeAt(index);
                      productQuantities.remove(productId);
                      total = calculateTotalPrice();
                    });
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text('Cart',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Image.network(
                      product['image_url'],
                      fit: BoxFit.cover,
                    ),
                    title: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name']),
                          Text('\$${product['price'].toStringAsFixed(2)}'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      // Decrease the quantity by 1
                                      productQuantities[productId] =
                                          quantity - 1;

                                      // Recalculate the total
                                      total = calculateTotalPrice();
                                    });
                                  }
                                },
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    // Increase the quantity by 1
                                    productQuantities[productId] = quantity + 1;

                                    // Recalculate the total
                                    total = calculateTotalPrice();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        _showFavourite(isLiked);
                        if (isLiked) {
                          widget.selectedProducts.remove(product);
                        } else {
                          widget.selectedProducts.add(product);
                        }
                        setState(() {});
                      },
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Price: \$${total?.toStringAsFixed(2) ?? 0}',
                style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      cartItems: filteredCartList,
                      productQuantities: productQuantities,
                      total: total,
                    ),
                  ),
                );
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideMenu extends StatefulWidget {
  final Widget? child;
  final List<Widget>? menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
            .animate(CurveTween(curve: Curves.decelerate).animate(_controller));

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta! / context.size!.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity! <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.redAccent,
                            child: new Row(
                              children: widget.menuItems!.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
