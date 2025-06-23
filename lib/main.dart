import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';
import 'services/category_service.dart';
import 'services/product_service.dart';
import 'services/auth_service.dart'; // To check user login status
import 'models/category.dart';
import 'models/product.dart';

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
  // Services
  final AuthService _authService = AuthService();
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();

  // Data
  List<Category> _categories = [];
  List<Product> _allProducts = []; // Stores all products fetched
  List<Product> _displayedProducts = []; // Products for the currently selected category

  String selectedCategoryName = "Best Seller"; // Default to a static "Best Seller" category initially, will update if backend provides it
  int selectedNavIndex = 0;
  bool _isLoading = true;
  String _errorMessage = '';
  String _userName = 'GoodyFx'; // Default for UI, will be updated from auth

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
      // Check user status
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        _userName = currentUser.name;
        // Also ensure token is valid. If not, maybe navigate to login.
      } else {
        // If not logged in, data fetching might fail for authenticated endpoints.
        // For this demo, we'll try to fetch anyway, but alert user.
        print("User not logged in. Data fetching might require authentication.");
      }

      // Fetch categories
      final fetchedCategories = await _categoryService.readAllCategories();
      if (fetchedCategories != null && fetchedCategories.isNotEmpty) {
        _categories = fetchedCategories;
        // Optionally, set the first category as selected or try to find "Best Seller"
        if (_categories.any((c) => c.name == "Best Seller")) {
          selectedCategoryName = "Best Seller";
        } else {
          selectedCategoryName = _categories.first.name;
        }
      } else {
        _errorMessage = 'Failed to load categories. Please ensure backend is running and you are logged in.';
        print(_errorMessage);
      }

      // Fetch products
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
        orElse: () => Category(id: -1, name: "Unknown"), // Fallback
      );

      // Filter products by category ID. Backend Product entity links to Category ID.
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
        "image": p.image, // This is expected to be an asset path or URL
        "price": 310.0, // Placeholder, as price is not in backend Product entity
        "sales": "1200 Sales", // Placeholder, not in backend Product entity
        "rating": "4.5 Ratings", // Placeholder, not in backend Product entity
        "isFavorite": false, // Local UI state
        "category": p.category.name, // Used for search page filtering
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
                          Icon(Icons.error_outline, color: Colors.red, size: 48),
                          SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: Text('Retry'),
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C896)),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              NavigationHelper.goToLogin(context);
                            },
                            child: Text('Go to Login'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
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
                'Icons/profile.svg', // Static for now
                fit: BoxFit.cover,
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
                        text: "Hello, ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextSpan(
                        text: _userName,
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
                  "What are you looking for?",
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              SvgPicture.asset(
                'Icons/search_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                placeholderBuilder: (context) => Icon(
                  Icons.search,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
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
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = selectedCategoryName == category.name;

          return GestureDetector(
            onTap: () {
              _filterProductsByCategory(category.name);
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF00C896) : Color(0xFF2A2A2A),
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCategoryName,
                style: TextStyle(
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
                    // Pass the already filtered products for this category
                    // If you want to load all for "see all", pass _allProducts
                    // For now, it will show products for the currently selected category.
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

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
    // Add dummy sales/rating data as these are not in the backend Product entity
    final dummySales = "1200 Sales";
    final dummyRating = "4.5 Ratings";
    final dummyPrice = "\$310"; // Hardcoded as price is not in backend Product entity

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
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    product.image, // Use backend image path
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
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
                        // This 'isFavorite' state is local to UI
                        // If backend had a favorite endpoint, it would be called here
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        false ? Icons.favorite : Icons.favorite_border, // Hardcoded false for now
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
            padding: EdgeInsets.all(15),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "$dummySales • $dummyRating",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  dummyPrice,
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
              setState(() {
                selectedNavIndex = item['index'];
              });
              if (item['index'] == 3) { // LOGIN tab
                NavigationHelper.goToLogin(context);
              } else if (item['index'] == 0) { // HOME tab
                // Already on home, maybe refresh or do nothing
                _loadData(); // Refresh data on home click
              }
              // Other tabs are static as per previous instruction
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