import 'package:freezed_annotation/freezed_annotation.dart';
import 'review.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String productId,
    required String name,
    String? description,
    required double price,
    required int stockQuantity,
    required String categoryKey,
    String? imageUrl,
    required DateTime createdAt,
    @Default([]) List<Review> reviews,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
