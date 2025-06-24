import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/payment_method.dart';

// Payment Provider for State Management
class PaymentProvider extends GetxController {
  RxList<PaymentMethod> _paymentMethods = <PaymentMethod>[
    PaymentMethod(
      id: '1',
      type: 'Visa',
      lastFourDigits: '1023',
      expiryDate: '12/25',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: 'MasterCard',
      lastFourDigits: '4023',
      expiryDate: '08/24',
    ),
    PaymentMethod(
      id: '3',
      type: 'Visa',
      lastFourDigits: '5043',
      expiryDate: '03/26',
    ),
  ].obs;

  RxBool _isLoading = false.obs;
  RxBool _isAddingNew = false.obs;

  // Getters
  List<PaymentMethod> get paymentMethods => _paymentMethods.toList();
  bool get isLoading => _isLoading.value;
  bool get isAddingNew => _isAddingNew.value;

  // Methods
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void setAddingNew(bool adding) {
    _isAddingNew.value = adding;
  }

  void addPaymentMethod(PaymentMethod paymentMethod) {
    _paymentMethods.add(paymentMethod);
  }

  void removePaymentMethod(String id) {
    _paymentMethods.removeWhere((method) => method.id == id);
  }

  void setDefaultPaymentMethod(String id) {
    _paymentMethods.assignAll(_paymentMethods.map((method) {
      return method.copyWith(isDefault: method.id == id);
    }).toList());
  }

  IconData getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'american express':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Color getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A237E);
      case 'mastercard':
        return const Color(0xFFD32F2F);
      case 'american express':
        return const Color(0xFF388E3C);
      default:
        return const Color(0xFF424242);
    }
  }
}