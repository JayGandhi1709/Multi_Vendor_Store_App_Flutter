import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/models/buyer_model.dart';
import 'package:multi_vender_store_app/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems => _cartItems;

  CartModel _cart = CartModel(
    vendorId: '',
    productId: '',
    productName: '',
    price: 0,
    quantity: 0,
    productStock: 0,
    productImages: [],
    productSize: '',
    scheduleDate: Timestamp.now(),
  );

  double get totalPrice {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addProductToCart(CartModel cart) {
    _cart = cart;
    if (_cartItems.containsKey(_cart.productId)) {
      _cartItems.update(
        _cart.productId,
        (existingCart) => CartModel(
          vendorId: existingCart.vendorId,
          productId: existingCart.productId,
          productName: existingCart.productName,
          price: existingCart.price,
          quantity: existingCart.quantity + 1,
          productStock: existingCart.productStock,
          productImages: existingCart.productImages,
          productSize: existingCart.productSize,
          scheduleDate: existingCart.scheduleDate,
        ),
      );
    } else {
      _cartItems.putIfAbsent(cart.productId, () => cart);
    }
    notifyListeners();
  }

  void setCart(String cart) {
    _cart = CartModel.fromJson(cart);
    _cartItems.addAll(_cart as Map<String, CartModel>);
    notifyListeners();
  }

  void addToCartFromModel(CartModel cart) {
    _cart = cart;
    _cartItems.putIfAbsent(cart.productId, () => cart.copyWith(quantity: 1));
    notifyListeners();
  }

  void addToCartFromJsonDocumentSnapshot(
      DocumentSnapshot<Object?> product, String? size) {
    _cart = CartModel.fromJsonDocumentSnapshot(product);
    if (_cartItems.containsKey(_cart.productId) &&
        _cartItems.containsValue(_cart.productSize)) {
      // increment(_cart);
      // if (_cart.productStock > _cart.quantity) {
      _cartItems.update(
        _cart.productId,
        (CartModel existingCart) => existingCart.copyWith(
          quantity: existingCart.quantity + 1,
        ),
      );
      // }
    } else {
      _cartItems.putIfAbsent(
        _cart.productId,
        () => _cart.copyWith(
          quantity: 1,
          productSize: size,
        ),
      );
    }
    notifyListeners();
  }

  void clearProvider() {
    _cartItems.clear();
    notifyListeners();
  }

  void increment(CartModel cart) {
    if (_cart.productStock > _cart.quantity) {
      _cartItems.update(
        cart.productId,
        (CartModel existingCart) => existingCart.copyWith(
          quantity: existingCart.quantity + 1,
        ),
      );
    }

    notifyListeners();
  }

  void decrement(CartModel cart) {
    if (cart.quantity > 1) {
      _cartItems.update(
        cart.productId,
        (CartModel existingCart) => existingCart.copyWith(
          quantity: existingCart.quantity - 1,
        ),
      );
    } else {
      _cartItems.remove(cart.productId);
    }
    notifyListeners();
  }
}
