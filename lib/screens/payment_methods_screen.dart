import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

// Payment Provider for State Management
class PaymentProvider extends ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [
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
  ];

  bool _isLoading = false;
  bool _isAddingNew = false;

  // Getters
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;
  bool get isAddingNew => _isAddingNew;

  // Methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setAddingNew(bool adding) {
    _isAddingNew = adding;
    notifyListeners();
  }

  void addPaymentMethod(PaymentMethod paymentMethod) {
    _paymentMethods.add(paymentMethod);
    notifyListeners();
  }

  void removePaymentMethod(String id) {
    _paymentMethods.removeWhere((method) => method.id == id);
    notifyListeners();
  }

  void setDefaultPaymentMethod(String id) {
    _paymentMethods = _paymentMethods.map((method) {
      return method.copyWith(isDefault: method.id == id);
    }).toList();
    notifyListeners();
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

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  void _showAddPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddPaymentMethodForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Payment methods',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: paymentProvider.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = paymentProvider.paymentMethods[index];
                      return _buildPaymentMethodCard(paymentMethod, paymentProvider);
                    },
                  ),
                ),
                // Add Payment Method Button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showAddPaymentMethodDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add a Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod, PaymentProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: paymentMethod.isDefault
            ? Border.all(color: const Color(0xFF4CAF50), width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Card Icon
          Container(
            width: 50,
            height: 32,
            decoration: BoxDecoration(
              color: provider.getCardColor(paymentMethod.type),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              provider.getCardIcon(paymentMethod.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Card Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentMethod.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentMethod.maskedNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white60),
            onPressed: () {
              _showDeleteConfirmation(paymentMethod, provider);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PaymentMethod paymentMethod, PaymentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Remove Payment Method',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove this ${paymentMethod.type} ending in ${paymentMethod.lastFourDigits}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.removePaymentMethod(paymentMethod.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method removed'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPaymentMethodForm extends StatefulWidget {
  const AddPaymentMethodForm({super.key});

  @override
  State<AddPaymentMethodForm> createState() => _AddPaymentMethodFormState();
}

class _AddPaymentMethodFormState extends State<AddPaymentMethodForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedCardType = 'Visa';
  final List<String> _cardTypes = ['Visa', 'MasterCard', 'American Express'];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    // Remove all non-digit characters
    value = value.replaceAll(RegExp(r'\D'), '');

    // Add spaces every 4 digits
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiry(String value) {
    // Remove all non-digit characters
    value = value.replaceAll(RegExp(r'\D'), '');

    // Add slash after 2 digits
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      final lastFourDigits = cardNumber.substring(cardNumber.length - 4);

      final paymentMethod = PaymentMethod(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedCardType,
        lastFourDigits: lastFourDigits,
        expiryDate: _expiryController.text,
      );

      paymentProvider.addPaymentMethod(paymentMethod);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment method added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Add Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Card Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCardType,
                dropdownColor: const Color(0xFF2A2A2A),
                decoration: InputDecoration(
                  labelText: 'Card Type',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF3A3A3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                items: _cardTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCardType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF3A3A3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF3A3A3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  ),
                ),
                onChanged: (value) {
                  final formatted = _formatCardNumber(value);
                  if (formatted != value) {
                    _cardNumberController.value = _cardNumberController.value.copyWith(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.replaceAll(' ', '').length < 16) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'MM/YY',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF3A3A3A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                        ),
                      ),
                      onChanged: (value) {
                        final formatted = _formatExpiry(value);
                        if (formatted != value) {
                          _expiryController.value = _expiryController.value.copyWith(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'Enter MM/YY';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF3A3A3A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Enter CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF3A3A3A),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}