import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Delivery Information Data Model
// Delivery Provider for State Management
class DeliveryProvider extends GetxController {
  final RxList<String> _addresses = <String>[
    '537 Paper Street, Bradford, 19806',
    '123 Main Rd, Apt 4B, Springfield, 98765',
  ].obs;
  final RxBool _isLoading = false.obs;

  // Getters
  List<String> get addresses => _addresses.toList();
  bool get isLoading => _isLoading.value;

  // Methods
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void addAddress(String address) {
    _addresses.add(address);
  }

  void updateAddress(int index, String newAddress) {
    if (index >= 0 && index < _addresses.length) {
      _addresses[index] = newAddress;
    }
  }

  void removeAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);
    }
  }
}