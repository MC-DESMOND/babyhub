import 'package:flutter/material.dart';
import '../models/delivery_model.dart';

class DeliveryProvider extends ChangeNotifier {
  DeliveryModel _delivery = const DeliveryModel(
    addresses: [
      '123 Main St, City, State',
      '456 Oak Ave, City, State',
    ],
  );

  bool _isLoading = false;

  // Getters
  DeliveryModel get delivery => _delivery;
  List<String> get addresses => _delivery.addresses;
  bool get isLoading => _isLoading;

  // Methods to manage addresses
  void addAddress(String address) {
    _delivery = _delivery.copyWith(
      addresses: [..._delivery.addresses, address],
    );
    notifyListeners();
  }

  void removeAddress(int index) {
    if (index >= 0 && index < _delivery.addresses.length) {
      List<String> newAddresses = List.from(_delivery.addresses);
      newAddresses.removeAt(index);
      _delivery = _delivery.copyWith(addresses: newAddresses);
      notifyListeners();
    }
  }

  void updateAddress(int index, String newAddress) {
    if (index >= 0 && index < _delivery.addresses.length) {
      List<String> newAddresses = List.from(_delivery.addresses);
      newAddresses[index] = newAddress;
      _delivery = _delivery.copyWith(addresses: newAddresses);
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}