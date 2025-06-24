import 'package:flutter/material.dart'; // For IconData, not strictly model

// Payment Method Data Model
class PaymentMethod {
  final String id;
  final String type; // 'Visa', 'MasterCard', 'American Express', etc.
  final String lastFourDigits;
  final String expiryDate;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    required this.expiryDate,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? lastFourDigits,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get maskedNumber => '**** **** **** $lastFourDigits';
}