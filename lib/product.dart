import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';

class ProductPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final String? searchQuery;

  const ProductPage({
    super.key,
    required this.products,
    this.searchQuery,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Sample data matching the image
  List<Map<String, dynamic>> productData = [
    {
      "id": 1,
      "name": "Nintendo Pro",
      "image": "Icons/controller.svg",
      "price": 310,
      "sales": "1200 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 2,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 3,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 4,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 5,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 6,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 7,
      "name": "Deaf Cods",
      "image": "Icons/controller.svg",
      "price": 120,
      "sales": "2400 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
    {
      "id": 8,
      "name": "Nintendo Pro",
      "image": "Icons/controller.svg",
      "price": 310,
      "sales": "1200 Sales",
      "rating": "4.5 Ratings",
      "isFavorite": false
    },
  ];

  // Navigation function to details page using GoRouter
  void navigateToDetails(Map<String, dynamic> product) {
    NavigationHelper.goToDetails(
      context,
      product: {
        'name': product['name'],
        'price': product['price'].toString(),
        'rating': product['rating'].replaceAll(' Ratings', ''),
        'sales': product['sales'].replaceAll(' Sales', ''),
        'stock': '48', // Default stock value
        'description': 'A sleek black joystick with neon accents and a comfortable grip for precise gaming control...',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Products Grid
            Expanded(
              child: _buildProductsGrid(),
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
          // Back button using GoRouter
          GestureDetector(
            onTap: () => NavigationHelper.goBack(context),
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

          // Title - centered
          Expanded(
            child: Center(
              child: Text(
                "Products",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
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

  Widget _buildProductsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
        ),
        itemCount: productData.length,
        itemBuilder: (context, index) {
          final product = productData[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => navigateToDetails(product), // Uses GoRouter navigation
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Product Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        product['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        // Fallback if SVG doesn't load
                        placeholderBuilder: (context) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            product['name'].contains('Nintendo')
                                ? Icons.gamepad
                                : Icons.headphones,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Heart Icon
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          product['isFavorite'] = !product['isFavorite'];
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(17.5),
                        ),
                        child: Icon(
                          product['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product['isFavorite']
                              ? Colors.red
                              : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Sales and Rating
                  Text(
                    "${product['sales']} • ${product['rating']}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
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
          ],
        ),
      ),
    );
  }
}