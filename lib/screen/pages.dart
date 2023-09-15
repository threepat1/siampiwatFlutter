import 'package:flutter/material.dart';
import 'package:siampiwat/repository/product_repo.dart';
import 'package:siampiwat/screen/cartpage.dart';
import 'package:siampiwat/screen/widget/product_grid_item.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _currentIndex = 0;
  List<dynamic> products = [];
  List<Map<String, dynamic>> selectedProducts = [];
  List<Map<String, dynamic>> cartList = [];

  @override
  void initState() {
    super.initState();
    ProductRepository().loadProductData().then((data) {
      setState(() {
        products = data;
      });
    });
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      if (!cartList.contains(product['id'])) cartList.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          final List<Widget> _pages = [
            homeScreen(),
            saveScreen(),
            cartScreen(
              cartList: cartList,
              selectedProducts: selectedProducts,
            )
          ];

          return _pages[_currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget saveScreen() {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: selectedProducts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (selectedProducts == null || selectedProducts.isEmpty) {
            return Container();
          }
          final product = selectedProducts[index];
          final bool isLiked = selectedProducts.contains(product);

          return ProductGridItem(
            product: product,
            onAddCart: addToCart,
            isLiked: isLiked,
            onLikePressed: () {
              setState(() {
                if (isLiked) {
                  selectedProducts.remove(product);
                } else {
                  selectedProducts.add(product);
                }
              });
            },
          );
        },
      ),
    );
  }

  Widget homeScreen() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text('For You',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: products?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  if (products == null || products.isEmpty) {
                    return Container();
                  }
                  final product = products[index];
                  final bool isLiked = selectedProducts.contains(product);

                  return ProductGridItem(
                    product: product,
                    isLiked: isLiked,
                    onAddCart: addToCart,
                    onLikePressed: () {
                      setState(() {
                        if (isLiked) {
                          selectedProducts.remove(product);
                        } else {
                          selectedProducts.add(product);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
