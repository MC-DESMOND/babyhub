import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';

class SearchProductPage extends StatefulWidget {
  final List<Map<String, dynamic>> allProducts; // Now expects data from HomePage
  final String? initialCategory;

  const SearchProductPage({
    super.key,
    required this.allProducts,
    this.initialCategory,
  });

  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initialize with all products or filter by initial category
    filteredProducts = widget.initialCategory != null
        ? widget.allProducts
        .where((product) => product['category'] == widget.initialCategory)
        .toList()
        : widget.allProducts;

    // Listen to search text changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      _filterProducts();
    });
  }

  void _filterProducts() {
    if (searchQuery.isEmpty) {
      filteredProducts = widget.initialCategory != null
          ? widget.allProducts
          .where((product) => product['category'] == widget.initialCategory)
          .toList()
          : widget.allProducts;
    } else {
      filteredProducts = widget.allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final category = product['category'].toString().toLowerCase();
        final matchesSearch = name.contains(searchQuery) || category.contains(searchQuery);

        if (widget.initialCategory != null) {
          return matchesSearch && product['category'] == widget.initialCategory;
        }
        return matchesSearch;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(),

            // Search Bar
            _buildSearchBar(),

            // Search Results
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => NavigationHelper.goBack(context), // Using Go Router navigation
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: Text(
                widget.initialCategory != null
                    ? "${widget.initialCategory} Products"
                    : "Product Search",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Spacer to balance the layout
          SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            Icon(
              Icons.search,
              color: Colors.white54,
              size: 24,
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Search Product",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white24,
            ),
            SizedBox(height: 16),
            Text(
              searchQuery.isEmpty ? "Start typing to search products" : "No products found",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to details page using Go Router
        NavigationHelper.goToDetails(
          context,
          product: {
            'name': product['name'],
            'price': product['price'].toString(),
            'rating': product['rating'].replaceAll(' Ratings', ''),
            'sales': product['sales'].replaceAll(' Sales', ''),
            'stock': '48', // Default stock value
            'description': 'A sleek black joystick with neon accents and a comfortable grip for precise gaming control...', 
            'image': product['image'], // Pass the image from the product object
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(15),
              ),
              child: SvgPicture.asset(
                product['image'], // Use the image from the product map
                width: 40,
                height: 30,
                color: Colors.grey[600],
                placeholderBuilder: (context) => Icon(
                  Icons.image,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),

            SizedBox(width: 15),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product['category'], // Category name from product map
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00C896),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${product['sales']} • ${product['rating']}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Price and Favorite
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      product['isFavorite'] = !product['isFavorite'];
                    });
                  },
                  child: Icon(
                    product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: product['isFavorite'] ? Colors.red : Colors.white70,
                    size: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "\$${product['price']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}