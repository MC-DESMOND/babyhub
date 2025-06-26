import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';
import 'services/category_service.dart';
import 'services/product_service.dart';
import 'services/auth_service.dart';
import 'models/category.dart';
import 'models/product.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

void main() {
  runApp(const MyApp());
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
  final AuthService _authService = AuthService();
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();

  List<Category> _categories = [];
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];

  String selectedCategoryName = "Best Seller";
  int selectedNavIndex = 0;
  bool _isLoading = true;
  String _errorMessage = '';
  String _userName = 'GoodyFx'; // Default, will be updated by currentUser
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        _userName = currentUser.name;
        _isLoggedIn = true;
      } else {
        _userName = 'GoodyFx';
        _isLoggedIn = false;
        print("User not logged in. Data fetching might require authentication.");
      }

      final fetchedCategories = await _categoryService.readAllCategories();
      if (fetchedCategories != null && fetchedCategories.isNotEmpty) {
        _categories = fetchedCategories;
        // Ensure "Best Seller" category exists or pick the first available
        if (_categories.any((c) => c.name == "Best Seller")) {
          selectedCategoryName = "Best Seller";
        } else if (_categories.isNotEmpty) {
          selectedCategoryName = _categories.first.name;
        } else {
          selectedCategoryName = "No Categories"; // Handle case where categories list is empty
        }
      } else {
        _errorMessage = 'Failed to load categories. Please ensure backend is running and you are logged in.';
        print(_errorMessage);
      }

      final fetchedProducts = await _productService.readAllProducts();
      if (fetchedProducts != null && fetchedProducts.isNotEmpty) {
        _allProducts = fetchedProducts;
        _filterProductsByCategory(selectedCategoryName);
      } else {
        _errorMessage += '\nFailed to load products. Please ensure backend is running and you are logged in.';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProductsByCategory(String categoryName) {
    setState(() {
      selectedCategoryName = categoryName;
      final selectedCategoryObj = _categories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => Category(id: -1, name: "Unknown"), // Fallback for unmatched category
      );

      _displayedProducts = _allProducts
          .where((product) => product.category.id == selectedCategoryObj.id)
          .toList();
    });
  }

  List<Map<String, dynamic>> _convertProductsToMapList(List<Product> products) {
    return products.map((p) {
      return {
        "id": p.id,
        "name": p.name,
        "image": p.image,
        "description": p.description,
        "price": p.price,
        "averageRating": p.averageRating, 
        "sales": p.sales, // Use actual sales
        "stock": p.stock, // Use actual stock
        "isFavorite": false, // This remains a local UI placeholder for now
        "category": p.category.name,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF00C896)),
              )
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadData,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C896)),
                            child: const Text('Retry'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              NavigationHelper.goToLogin(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text('Go to Login'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      _buildHeader(),
                      _buildSearchBar(),
                      _buildCategoryPills(),
                      Expanded(
                        child: _buildProductsSection(),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_isLoggedIn) {
                NavigationHelper.goToProfile(context);
              } else {
                NavigationHelper.goToLogin(context);
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SvgPicture.asset(
                  'Icons/profile.svg',
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                  placeholderBuilder: (context) => const Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    children: [
                      const TextSpan(
                        text: "Hello, ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextSpan(
                        text: _userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(text: "!"),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "What are you looking for?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Home",
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          NavigationHelper.goToSearch(
            context,
            allProducts: _convertProductsToMapList(_allProducts),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              SvgPicture.asset(
                'Icons/search_icon.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                placeholderBuilder: (context) => const Icon(
                  Icons.search,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  "Search Product",
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
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = selectedCategoryName == category.name;

          return GestureDetector(
            onTap: () {
              _filterProductsByCategory(category.name);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00C896) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                category.name,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCategoryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  NavigationHelper.goToProducts(
                    context,
                    products: _convertProductsToMapList(_displayedProducts),
                  );
                },
                child: const Text(
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

        const SizedBox(height: 20),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _displayedProducts.length,
            itemBuilder: (context, index) {
              final product = _displayedProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    // Use product average rating if available, otherwise default
    final double averageRating = product.averageRating is num
        ? (product.averageRating as num).toDouble() : 0.0;
    final String formattedAverageRating = averageRating.toStringAsFixed(1);

    return GestureDetector(
      onTap: () => NavigationHelper.goToDetails(context, product: _convertProductToMap(product)), // Corrected call
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      product.image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      placeholderBuilder: (context) => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
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
                          // This 'isFavorite' state is local to UI
                          // If backend had a favorite endpoint, it would be called here
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          false ? Icons.favorite : Icons.favorite_border,
                          color: false ? Colors.red : Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.sales} Sales \u2022 $formattedAverageRating Rating', // Display actual sales and average rating
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
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
      ),
    );
  }

  // Helper method to convert a Product object back to a Map for navigation
  Map<String, dynamic> _convertProductToMap(Product p) {
    return {
      "id": p.id,
      "name": p.name,
      "image": p.image,
      "description": p.description,
      "price": p.price,
      "averageRating": p.averageRating,
      "sales": p.sales,
      "stock": p.stock,
      "isFavorite": false, // This is not stored in Product model, keep as dummy
      "category": p.category.name,
    };
  }

  Widget _buildBottomNavigation() {
    final List<Map<String, dynamic>> navItems = [
      {"icon": Icons.home, "label": "HOME", "index": 0, "routeName": AppRoutes.homeRouteName},
      {"icon": Icons.favorite_border, "label": "WISHLIST", "index": 1, "routeName": null}, // Wishlist functionality to be added
      {"icon": Icons.shopping_bag_outlined, "label": "CART", "index": 2, "routeName": AppRoutes.cartRouteName},
      {
        "icon": _isLoggedIn ? Icons.person_outline : Icons.login,
        "label": _isLoggedIn ? "PROFILE" : "LOGIN",
        "index": 3,
        "routeName": _isLoggedIn ? AppRoutes.profileRouteName : AppRoutes.loginRouteName,
      }
    ];

    return Container(
      height: 80,
      decoration: const BoxDecoration(
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
              setState(() {
                selectedNavIndex = item['index'];
              });
              if (item['routeName'] != null) { // Check if routeName is provided
                router.goNamed(item['routeName']);
              } else if (item['index'] == 0) { // Specific handling for Home (reload data)
                _loadData(); // Reload home data
              } else if (item['index'] == 1) { // Wishlist placeholder
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Wishlist functionality coming soon!'))
                 );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? const Color(0xFF00C896) : Colors.white54,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFF00C896) : Colors.white54,
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
