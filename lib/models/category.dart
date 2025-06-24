class Category {
  final int id;
  final String name;
  final List<int>? productsIdList; // Added productsIdList

  Category({required this.id, required this.name, this.productsIdList});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      productsIdList: (json['productsIdList'] as List<dynamic>?)?.map((e) => e as int).toList(), // Parse list of ints
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productsIdList': productsIdList, // Include in toJson
    };
  }
}