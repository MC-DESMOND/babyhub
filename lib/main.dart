import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Baby App',
      theme: ThemeData.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // JSON-like structure for page data
  Map<String, dynamic> pageData = {
    "header": {
      "user": {
        "name": "GoodyFx",
        "avatar": "Icons/profile.svg",
        "greeting": "Hello, ",
        "subtitle": "What are you looking for?"
      },
      "title": "Home"
    },
    "search": {
      "placeholder": "Search Product",
      "icon": "Icons/search_icon.svg"
    },
    "categories": [
      {"name": "Best Seller", "isActive": true},
      {"name": "Earphones", "isActive": false},
      {"name": "Charger", "isActive": false},
      {"name": "Protection", "isActive": false}
    ],
    "sections": {
      "Best Seller": [
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
          "image": "Icons/earphones.svg",
          "price": 120,
          "sales": "2400 Sales",
          "rating": "4.5 Ratings",
          "isFavorite": false
        }
      ],
      "Earphones": [
        {
          "id": 3,
          "name": "AirPods Pro",
          "image": "Icons/controller.svg",
          "price": 250,
          "sales": "3200 Sales",
          "rating": "4.8 Ratings",
          "isFavorite": false
        }
      ],
      "Charger": [
        {
          "id": 4,
          "name": "Fast Charger",
          "image": "Icons/controller.svg",
          "price": 45,
          "sales": "1800 Sales",
          "rating": "4.3 Ratings",
          "isFavorite": false
        }
      ],
      "Protection": [
        {
          "id": 5,
          "name": "Phone Case",
          "image": "Icons/controller.svg",
          "price": 25,
          "sales": "5000 Sales",
          "rating": "4.6 Ratings",
          "isFavorite": false
        }
      ]
    }
  };

  String selectedCategory = "Best Seller";
  int selectedNavIndex = 0;

  // Method to get all products from all categories
  List<Map<String, dynamic>> getAllProducts() {
    List<Map<String, dynamic>> allProducts = [];
    final sections = pageData['sections'] as Map<String, dynamic>;

    sections.forEach((category, products) {
      for (var product in products) {
        // Add category info to each product
        Map<String, dynamic> productWithCategory = Map.from(product);
        productWithCategory['category'] = category;
        allProducts.add(productWithCategory);
      }
    });

    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Search Bar
            _buildSearchBar(),

            // Category Pills
            _buildCategoryPills(),

            // Products Section
            Expanded(
              child: _buildProductsSection(),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    final headerData = pageData['header'];
    final userData = headerData['user'];

    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[800],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SvgPicture.asset(
                userData['avatar'],
                fit: BoxFit.cover,
                // Fallback if SVG doesn't load
                placeholderBuilder: (context) => Icon(
                  Icons.person,
                  color: Colors.white54,
                  size: 30,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),

          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    children: [
                      TextSpan(
                        text: userData['greeting'],
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextSpan(
                        text: userData['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(text: "!"),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userData['subtitle'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          // Home Title
          Text(
            headerData['title'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final searchData = pageData['search'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          // Navigate to Search Page using Go Router
          NavigationHelper.goToSearch(
            context,
            allProducts: getAllProducts(),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              SvgPicture.asset(
                searchData['icon'],
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                // Fallback if SVG doesn't load
                placeholderBuilder: (context) => Icon(
                  Icons.search,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  searchData['placeholder'],
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = pageData['categories'] as List;

    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category['name'];
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF00C896) : Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                category['name'],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsSection() {
    final sectionData = pageData['sections'][selectedCategory] as List? ?? [];

    return Column(
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCategory,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to search page with category filter using Go Router
                  NavigationHelper.goToSearch(
                    context,
                    allProducts: getAllProducts(),
                    initialCategory: selectedCategory,
                  );
                },
                child: Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00C896),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Products List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: sectionData.length,
            itemBuilder: (context, index) {
              final product = sectionData[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Product Image and Heart Icon
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    product['image'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    // Fallback if SVG doesn't load
                    placeholderBuilder: (context) => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.image,
                        color: Colors.white54,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        product['isFavorite'] = !product['isFavorite'];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: product['isFavorite'] ? Colors.red : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${product['sales']} • ${product['rating']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Text(
                  "\$${product['price']}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final List<Map<String, dynamic>> navItems = [
      {"icon": Icons.home, "label": "HOME", "index": 0},
      {"icon": Icons.favorite_border, "label": "WISHLIST", "index": 1},
      {"icon": Icons.shopping_bag_outlined, "label": "CART", "index": 2},
      {"icon": Icons.person_outline, "label": "LOGIN", "index": 3},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navItems.map((item) {
          final isSelected = selectedNavIndex == item['index'];
          return GestureDetector(
            onTap: () {
              if (item['index'] == 0) {
                setState(() {
                  selectedNavIndex = item['index'];
                });
              } else {
                // Static for other tabs as requested
                print("${item['label']} tapped (static)");
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? Color(0xFF00C896) : Colors.white54,
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Color(0xFF00C896) : Colors.white54,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}