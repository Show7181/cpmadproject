import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';
class FirestoreService {
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');
final FirebaseAuth _auth = FirebaseAuth.instance;
String? getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid ;  
  }

  Future<void> addCartProduct(CartProduct cartProduct) async {
     String? userId = getCurrentUserId();
    var docRef = cartCollection.doc();  
    debugPrint('add docRef: ${docRef.id}');
 cartProduct.id = docRef.id;
   cartProduct.userId = userId; 
    await cartCollection.doc(docRef.id).set(cartProduct.toMap()); 
  }

 Future<List<CartProduct>> getUserCart() async {
  String? userId = getCurrentUserId();
  QuerySnapshot snapshot = await cartCollection
      .where('userId', isEqualTo: userId)  
      .get();

  List<CartProduct> cartProducts = snapshot.docs.map((doc) {
    return CartProduct.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();

  return cartProducts;
}

}
