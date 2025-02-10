import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String? id;
  String? userId; 
  String? productName;
  String? size;
  int? quantity;
  double? price;
  DateTime? date;
  String? dineInOrOut;

   CartProduct({this.id, this.userId, this.productName, this.size, this.quantity, this.price, this.date, this.dineInOrOut});

  CartProduct.fromMap(Map<String, dynamic> data) {
    id = data['id']; 
     userId = data['userId'];
    productName = data['productName'];
    size = data['size'];
    quantity = data['quantity'];
    price = data['price'];
    date = (data['date'] as Timestamp).toDate();
    dineInOrOut = data['dineInOrOut'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
       'userId': userId,
      'productName': productName,
      'size': size,
      'quantity': quantity,
      'price': price,
       'date': date != null ? DateTime.now() : null,
       'dineInOrOut': dineInOrOut,
    };
  }
}
