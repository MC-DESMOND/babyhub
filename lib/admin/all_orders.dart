import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedTab = 0;
  final List<String> tabs = ['All Orders', 'Shipping', 'Completed', 'Cancel'];

  // ✅ Using a placeholder container instead of asset image to avoid loading errors
  final List<Map<String, dynamic>> _orders = List.generate(8, (index) => {
        'id': '#023${index + 1}',
        'name': 'Story Kitadakie (Green)',
        'customer': 'Leslie Alexander',
        'price': '\$21.78',
        'date': '04/17/23',
        'time': '8:25 PM',
        'status': 'Paid',
      });

  final Set<int> _expandedIndexes = {};

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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GoodyFX',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                Text('Admin', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.menu, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orders',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text('Dashboard', style: TextStyle(color: Colors.grey)),
                Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                Text('Orders', style: TextStyle(color: Colors.grey)),
                Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                Text('All Orders',
                    style: TextStyle(color: Color(0xFF4A9EFF), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isActive = _selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      selected: isActive,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tabs[index]),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('41',
                                style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                      selectedColor: const Color(0xFF4A9EFF),
                      backgroundColor: const Color(0xFF2E2E2E),
                      labelStyle: TextStyle(color: isActive ? Colors.white : Colors.white70),
                      onSelected: (_) => setState(() => _selectedTab = index),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for id, name, product',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 16),

            const Row(
              children: [
                Icon(Icons.filter_list, color: Colors.white),
                SizedBox(width: 8),
                Text('Product', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final isExpanded = _expandedIndexes.contains(index);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                            value: false,
                            onChanged: (_) {},
                          ),
                          title: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${order['id']} - ${order['name']}',
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isExpanded) {
                                  _expandedIndexes.remove(index);
                                } else {
                                  _expandedIndexes.add(index);
                                }
                              });
                            },
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow('Customer', order['customer']),
                                _detailRow('Price', order['price']),
                                _detailRow('Date', order['date']),
                                _detailRow('Payment', '${order['date']} at ${order['time']}'),
                                const Row(
                                  children: [
                                    Text('Status', style: TextStyle(color: Colors.white70)),
                                    SizedBox(width: 12),
                                    Chip(
                                      label:
                                          Text('Paid', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.green,
                                      visualDensity: VisualDensity.compact,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Row(
                                  children: [
                                    Text('Action', style: TextStyle(color: Colors.white70)),
                                    SizedBox(width: 12),
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 12),
                                    Icon(Icons.delete, color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white70),
                    children: const [
                      TextSpan(
                        text: '1',
                        style: TextStyle(
                          color: Color(0xFF4A9EFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: ' - 8 of 13 Pages'),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}