import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  String? _selectedCategory;
  String? _selectedStatus;

  final List<String> _categories = ['Clothing', 'Toys', 'Baby Food', 'Skincare'];
  final List<String> _statuses = ['Available', 'Out of Stock', 'Few Units Left'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GoodyFX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Dashboard', style: TextStyle(color: Colors.grey)),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                const Text('Product', style: TextStyle(color: Colors.grey)),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                const Text('Diapers', style: TextStyle(color: Colors.grey)),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                const Text(
                  'Edit Product',
                  style: TextStyle(color: Color(0xFF4A9EFF), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Information',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Modify product details as needed.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 24),
                  _buildTextField('SKU', ''),
                  const SizedBox(height: 16),
                  _buildTextField('Product Name', ''),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Size', '', inputType: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Color', '')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    'Product Category',
                    _selectedCategory,
                    _categories,
                    (val) => setState(() => _selectedCategory = val),
                    hintText: 'Select category',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Price', '', inputType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField('Quantity', '', inputType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    'Product Status ',
                    _selectedStatus,
                    _statuses,
                    (val) => setState(() => _selectedStatus = val),
                    hintText: 'Select status',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Image Product',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note : ',
                          style: TextStyle(
                            color: Color(0xFF4A9EFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Format photos SVG, PNG, or JPG (Max size 4mb)',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: [
                      _buildImageContainer(hasImage: false, label: 'Picture 1'),
                      _buildImageContainer(hasImage: false, label: 'Picture 2'),
                      _buildImageContainer(hasImage: false, label: 'Picture 3'),
                      _buildImageContainer(hasImage: false, label: 'Picture 4'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4A9EFF)),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Discard Changes',
                      style: TextStyle(
                        color: Color(0xFF4A9EFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/all-orders'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A9EFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hintText, {TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: inputType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    void Function(String?) onChanged, {
    required String hintText,
    }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items
              .asMap()
              .entries
              .map((entry) {
                int index = entry.key;
                String item = entry.value;

                return DropdownMenuItem<String>(
                  value: item,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (index != items.length - 1)
                        const Divider(
                          color: Colors.white24,
                          thickness: 1,
                          height: 0,
                        ),
                    ],
                  ),
                );
              })
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2A2A2A),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildImageContainer({required bool hasImage, String? label}) {
    return Container(
      decoration: BoxDecoration(
        color: hasImage ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasImage ? Colors.transparent : Colors.white,
        ),
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://via.placeholder.com/100',
                fit: BoxFit.cover,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF4A9EFF), size: 32),
                if (label != null) ...[
                  const SizedBox(height: 4),
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ],
            ),
    );
  }
}