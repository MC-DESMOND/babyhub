import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentModel _payment = const PaymentModel(
    paymentMethods: [
      '**** 1234',
      '**** 5678',
    ],
  );

  bool _isLoading = false;

  // Getters
  PaymentModel get payment => _payment;
  List<String> get paymentMethods => _payment.paymentMethods;
  bool get isLoading => _isLoading;

  // Methods to manage payment methods
  void addPaymentMethod(String paymentMethod) {
    _payment = _payment.copyWith(
      paymentMethods: [..._payment.paymentMethods, paymentMethod],
    );
    notifyListeners();
  }

  void removePaymentMethod(int index) {
    if (index >= 0 && index < _payment.paymentMethods.length) {
      List<String> newMethods = List.from(_payment.paymentMethods);
      newMethods.removeAt(index);
      _payment = _payment.copyWith(paymentMethods: newMethods);
      notifyListeners();
    }
  }

  void updatePaymentMethod(int index, String newMethod) {
    if (index >= 0 && index < _payment.paymentMethods.length) {
      List<String> newMethods = List.from(_payment.paymentMethods);
      newMethods[index] = newMethod;
      _payment = _payment.copyWith(paymentMethods: newMethods);
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}