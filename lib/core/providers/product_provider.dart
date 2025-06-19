import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/core/services/dummy_service.dart';
import 'package:babyhub/core/models/product.dart';

final dummyServiceProvider = Provider<DummyService>((ref) {
  return DummyService();
});

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.read(dummyServiceProvider);
  return await service.fetchProducts();
});
