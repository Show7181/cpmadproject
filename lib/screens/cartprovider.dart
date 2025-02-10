import 'package:cpmadproject/model/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firestore_service.dart';  


class CartProvider extends ChangeNotifier {
  String? _dineInOrOut; 
   String? get dineInOrOut => _dineInOrOut;

  final Map<int, Map<String, int>> _cart = {};
   Map<int, Map<String, int>> get cart => _cart;
final List<double> noodlePrice = [17.00, 16.50, 15.50, 14.80, 13.50, 16.00];
  final List<String> noodleName = [
    'MUSHROOM MINCED MEAT NOODLE',
    'LAKSA',
    'HANDMADE FISHBALL SOUP',
    'FISHBALL NOODLE DRY',
    'SIGNATURE MEE SUA DRY',
    'FRIED HOKKIEN PRAWN NOODLE',
  ];
 int _quantity = 0;
 
  int get quantity => _quantity;

int? _selectedSizeIndex;
int? get selectedSizeIndex => _selectedSizeIndex;
 int get cartCount => _cart.length;
 int get count => _cart.isNotEmpty
    ? _cart.values
        .map((item) => item.values.reduce((a, b) => a + b)) 
        .reduce((a, b) => a + b) 
    : 0;
  double get totalPrice {
    double total = 0;
    _cart.forEach((index, sizes) {
      sizes.forEach((size, quantity) {
        total += noodlePrice[index] * quantity;
      });
    });
    return total;
  }
double getItemPrice(int index) {

  int selectedIndex = _selectedSizeIndex ?? 0;
  return noodlePrice[index] * _quantity;
}

 void setDineInOrOut(String choice) {
    _dineInOrOut = choice;  
    print("dineInOrOut set to: $_dineInOrOut");
    notifyListeners();  
  }



void addToCart(int index, String size, int quantity){
    if (_cart.containsKey(index)) {
      if (_cart[index]!.containsKey(size)) {
        _cart[index]![size] = _cart[index]![size]! + quantity;
      } else {
        _cart[index]![size] = quantity;
      }
    } else {
      _cart[index] = {size: quantity};
    }
    notifyListeners();
}

void addToCartbyhistory(String? productName, String size, int quantity) {
  if (productName == null) {
    print('Product name is missing');
  } else {
    int productIndex = noodleName.indexOf(productName);

   if (productIndex != -1) {
  
      if (_cart.containsKey(productIndex)) {
        if (_cart[productIndex]!.containsKey(size)) {
          _cart[productIndex]![size] = _cart[productIndex]![size]! + quantity;
        } else {
          _cart[productIndex]![size] = quantity;
        }
      } else {
        _cart[productIndex] = {size: quantity};
      }
      notifyListeners(); 
      print('Adding $productName to the cart');
    } else {
      print('Product not found in the noodle list');
    }
  }
}

   void clear(int shoeIndex, String size){
     cart[shoeIndex]?.remove(size);
     
      if (cart[shoeIndex]!.isEmpty) {
        cart.remove(shoeIndex);
      }
      notifyListeners();
   }
   void selectSize(int index) {
    _selectedSizeIndex = index;
    notifyListeners(); 
  }
    void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }
  void clearCart() {
  cart.clear();
  notifyListeners();
}

 Future<void> saveCartToFirestore() async {
  DateTime currentDate = DateTime.now();
    try {
      
      for (var cartItem in _cart.entries) {
        final cartIndex = cartItem.key;
        final sizes = cartItem.value;
        
        for (var sizeEntry in sizes.entries) {
          final size = sizeEntry.key;
          final quantity = sizeEntry.value;
          final price = noodlePrice[cartIndex];
          final noodlename = noodleName[cartIndex];
            var cartProduct = CartProduct(
          productName: noodlename, 
          size: size,
          quantity: quantity,
          price: price,
         date: currentDate,
         dineInOrOut: _dineInOrOut,
        );

          
         
          await FirestoreService().addCartProduct(cartProduct);  
        }
      }Fluttertoast.showToast(
        msg: 'Cart saved successfully!',
        gravity: ToastGravity.TOP,
      );
    } catch (e) {
    
      Fluttertoast.showToast(
        msg: 'Error saving cart: $e',
        gravity: ToastGravity.TOP,
      );

     
    
    }
  }
}