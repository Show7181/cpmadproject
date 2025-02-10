import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartprovider.dart';
import 'package:badges/badges.dart' as badges;
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final String imgPath;
  final String noodleName;
  final String noodlePrice;
  final int index;

  const DetailPage({super.key, required this.imgPath, required this.noodleName, required this.noodlePrice, required this.index});

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    List<String> sizes = ['S', 'M', 'L'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noodleName, style: const TextStyle(fontWeight: FontWeight.bold)),
         backgroundColor: const Color(0xFFD8900A),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150.0,
              width: 30.0,
             child: badges.Badge(
               position: badges.BadgePosition.topEnd(top: -5, end: -8),
              
              badgeContent: Text(
                cartProvider.count.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
                badgeColor: Colors.white,
              child: IconButton(
                icon: Icon(
                Icons.shopping_cart,
                color: cartProvider.cartCount > 0 ? Colors.white : Colors.black.withOpacity(0.25),
              ),
                onPressed:cartProvider.cartCount > 0? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                }
                :null,
              ),
             ),
             
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: widget.imgPath,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(widget.imgPath, height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.noodleName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '\$${widget.noodlePrice}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD8900A),),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Select Size:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  color: Colors.black,
                  selectedBorderColor: Colors.blueAccent,
                  isSelected: List.generate(3, (index) => cartProvider.selectedSizeIndex == index),
                  onPressed: (index) {
                    cartProvider.selectSize(index);
                    if (cartProvider.quantity > 0) {
                      String selectedSize = sizes[cartProvider.selectedSizeIndex!];
                      cartProvider.addToCart(widget.index, selectedSize, cartProvider.quantity);
                    }
                  },
                  children: [
                    _buildSizeButton('S'),
                    _buildSizeButton('M'),
                    _buildSizeButton('L'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Price: \$${cartProvider.getItemPrice(widget.index).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.black, size: 30),
                        onPressed: cartProvider.decreaseQuantity,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                        ),
                        child: Text(
                          cartProvider.quantity.toString(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.black, size: 30),
                        onPressed: cartProvider.increaseQuantity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 50,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
