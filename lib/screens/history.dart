import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../model/product.dart';
import '../services/firestore_service.dart';
import '../screens/cartprovider.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<CartProduct>> cartProducts;

  @override
  void initState() {
    super.initState();
    cartProducts = FirestoreService().getUserCart();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CartProduct>>(
        future: cartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); 
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            List<CartProduct>? products = snapshot.data;

            if (products != null && products.isNotEmpty) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  CartProduct product = products[index];
                  return GestureDetector(
                    onTap: () {
                      _showReorderDialog(context, product);
                    },
                    child: ListTile(
                      title: Text(product.productName ?? 'Product'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Size: ${product.size}'),
                          Text('Quantity: ${product.quantity}'),
                          Text('Price: \$${product.price}'),
                          Text('Date: ${product.date}'),
                          Text('DineInOut: ${product.dineInOrOut}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No cart history available.'));
            }
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  void _showReorderDialog(BuildContext context, CartProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reorder Item'),
          content: const Text('Would you like to reorder the same item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              
                _addToCart(product);
              },
              child: const Text('Reorder'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(CartProduct product) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

   
    cartProvider.addToCartbyhistory(
       product.productName!, 
      product.size!,  
      product.quantity!, 
    );

  
  
  }
}
