import 'package:flutter/material.dart';
import 'package:babyhub/core/models/product.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          "${product.description ?? ''}\n₦${NumberFormat("#,##0.00", "en_NG").format(product.price)}",
        ),
        isThreeLine: true,
      ),
    );
  }
}
