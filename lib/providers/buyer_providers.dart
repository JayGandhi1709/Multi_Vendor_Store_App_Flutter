import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/models/buyer_model.dart';

class BuyerProvider extends ChangeNotifier {
  Buyer? _buyer = Buyer(
    id: '',
    name: '',
    email: '',
    address: '',
    profileImage: '',
    phoneNumber: '',
  );

  Buyer? get buyer => _buyer;

  void setBuyer(String buyer) {
    _buyer = Buyer.fromJson(buyer);
    notifyListeners();
  }

  void setBuyerFromModel(Buyer buyer) {
    _buyer = buyer;
    notifyListeners();
  }
  
  void clearProvider() {
    _buyer = null;
    notifyListeners();
  }
}
