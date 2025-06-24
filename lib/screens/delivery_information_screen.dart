import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../providers/delivery_provider.dart';

class DeliveryInformationScreen extends StatefulWidget {
  const DeliveryInformationScreen({super.key});

  @override
  State<DeliveryInformationScreen> createState() =>
      _DeliveryInformationScreenState();
}

class _DeliveryInformationScreenState extends State<DeliveryInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  int? _editingIndex;
  bool get _isEditing => _editingIndex != null;

  // Get the controller instance
  final DeliveryProvider deliveryProvider = Get.find<DeliveryProvider>();

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _addressLine1Controller.clear();
    _addressLine2Controller.clear();
    _cityController.clear();
    _zipCodeController.clear();
    setState(() {
      _editingIndex = null;
    });
  }

  void _populateForm(String fullAddress, int index) {
    List<String> parts = fullAddress.split(', ');
    if (parts.length >= 3) {
      _addressLine1Controller.text = parts[0];
      _addressLine2Controller.text = parts.length > 3 ? parts[1] : '';
      _cityController.text = parts[parts.length - 2];
      _zipCodeController.text = parts[parts.length - 1];
    }
    setState(() {
      _editingIndex = index;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String fullAddress = _buildFullAddress();
      if (_isEditing && _editingIndex != null) {
        deliveryProvider.updateAddress(_editingIndex!, fullAddress);
      } else {
        deliveryProvider.addAddress(fullAddress);
      }
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _isEditing ? 'Address updated successfully' : 'Address added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _buildFullAddress() {
    List<String> parts = [];
    if (_addressLine1Controller.text.trim().isNotEmpty) {
      parts.add(_addressLine1Controller.text.trim());
    }
    if (_addressLine2Controller.text.trim().isNotEmpty) {
      parts.add(_addressLine2Controller.text.trim());
    }
    if (_cityController.text.trim().isNotEmpty) {
      parts.add(_cityController.text.trim());
    }
    if (_zipCodeController.text.trim().isNotEmpty) {
      parts.add(_zipCodeController.text.trim());
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Delivery Information',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() { // Use Obx to react to changes in isLoading and addresses
          if (deliveryProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            color: Colors.white60,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Move Pin',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    label: 'Address Line 1',
                    controller: _addressLine1Controller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Address Line 1 is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Address Line 2',
                    controller: _addressLine2Controller,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'City',
                    controller: _cityController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Zip Code',
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Zip Code is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
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
                    child: Text(
                      _isEditing ? 'Update Address' : 'Submit',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _clearForm,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (deliveryProvider.addresses.isNotEmpty) ...[
                    const Text(
                      'Saved Addresses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...deliveryProvider.addresses.asMap().entries.map((entry) {
                      int index = entry.key;
                      String address = entry.value;
                      return _buildAddressCard(address, index, deliveryProvider);
                    }).toList(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon:
                const Icon(Icons.location_on_outlined, color: Colors.white60),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(
      String address, int index, DeliveryProvider provider) {
    bool isCurrentlyEditing = _editingIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentlyEditing
            ? Border.all(color: const Color(0xFF4CAF50), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: isCurrentlyEditing
                      ? const Color(0xFF4CAF50)
                      : Colors.white60,
                ),
                onPressed: () {
                  if (isCurrentlyEditing) {
                    _clearForm();
                  } else {
                    _populateForm(address, index);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  if (isCurrentlyEditing) {
                    _clearForm();
                  }
                  provider.removeAddress(index);
                },
              ),
            ],
          ),
          if (isCurrentlyEditing)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Editing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}