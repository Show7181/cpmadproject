import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartprovider.dart';
import 'home_page.dart';
import 'package:badges/badges.dart' as badges;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool dineInSelected = false;
  bool dineOutSelected = false;

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        backgroundColor: const Color(0xFFD8900A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                int cartIndex = cartProvider.cart.keys.elementAt(index);
                var cartItem = cartProvider.cart[cartIndex];
                Map<String, int> size = cartProvider.cart[cartIndex]!;

                return Column(
                  children: cartItem!.entries.map((entry) {
                    String size = entry.key;
                    int quantity = entry.value;
                    return Card(
                      color: const Color.fromARGB(255, 243, 209, 148),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                      "images/food${cartIndex + 1}.PNG"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity: $quantity',
                                        style: const TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Size: $size',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              cartProvider.clear(cartIndex, size);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.amber[600],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Price: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      badges.Badge(
                        position: badges.BadgePosition.topEnd(
                            top: 5, end: 3),
                        badgeContent: Text(
                          cartProvider.count.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        badgeColor: Colors.orange,
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: cartProvider.cartCount > 0
                                ? Colors.blue
                                : Colors.black.withOpacity(0.25),
                          ),
                          onPressed: cartProvider.cartCount > 0
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CartPage()),
                                  );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
        onPressed: () {
          setState(() {
            dineInSelected = true; 
            dineOutSelected = false;
           
            cartProvider.setDineInOrOut('Dine In');  
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: dineInSelected ? Colors.green : Colors.white,
          side: BorderSide(
            color: dineInSelected ? Colors.green : Colors.black,
          ),
        ),
        child: const Text(
          'Dine In',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            dineOutSelected = true;
            dineInSelected = false;
           
            cartProvider.setDineInOrOut('Dine Out');
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: dineOutSelected ? Colors.blue : Colors.white,
          side: BorderSide(
            color: dineOutSelected ? Colors.blue : Colors.black,
          ),
        ),
        child: const Text(
          'Dine Out',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    ],
  ),
),

          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              color: Colors.amber[600],
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    await cartProvider.saveCartToFirestore();
                    cartProvider.clearCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text(
                    'Check Out',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
