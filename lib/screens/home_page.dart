import 'package:cpmadproject/screens/contactus_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebaseauth_service.dart';
import 'package:badges/badges.dart' as badges;
import '../screens/login_page.dart';
import 'profile_page.dart';
import 'drawer.dart';
import 'detail_page.dart';
import 'cartprovider.dart';
import 'history.dart';
import 'cart_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Home'; 
  int index = 0; 
  final List<Widget> pages = [
    const HomePageContent(), 
    const Profile(), 
  const Contact(),
  const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFD8900A),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150.0,
              width: 40.0,
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                badgeContent: Text(
                  cartProvider.count.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                badgeColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: cartProvider.cartCount > 0 ? Colors.white : Colors.black.withOpacity(0.25),
                  ),
                  onPressed: cartProvider.cartCount > 0
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
                          );
                        }
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: pages[index], 
      drawer: MyDrawer(
        onTap: (context, i, txt) {
          setState(() {
            index = i; 
            title = txt; 
            Navigator.pop(context); 
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD8900A),
        tooltip: 'Sign Out',
        onPressed: () async {
          await FirebaseAuthService().signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredNoodles = [];
  final Set<String> _selectedFilters = {}; // Stores selected filters

  final List<Map<String, String>> _noodles = [
    {"name": "MUSHROOM MINCED MEAT NOODLE", "price": "\$17.00", "type": "Dry", "image": "images/food1.PNG"},
    {"name": "LAKSA", "price": "\$16.50", "type": "Spicy", "image": "images/food2.PNG"},
    {"name": "HANDMADE FISHBALL SOUP", "price": "\$15.50", "type": "Soup", "image": "images/food3.PNG"},
    {"name": "FISHBALL NOODLE DRY", "price": "\$14.80", "type": "Dry", "image": "images/food4.PNG"},
    {"name": "SIGNATURE MEE SUA DRY", "price": "\$13.50", "type": "Dry", "image": "images/food5.PNG"},
    {"name": "FRIED HOKKIEN PRAWN NOODLE", "price": "\$16.00", "type": "Spicy", "image": "images/food6.PNG"},
  ];

  final List<String> _categories = ["Dry", "Soup", "Spicy"];

  @override
  void initState() {
    super.initState();
    _filteredNoodles = _noodles; 
    _searchController.addListener(_filterNoodles);
  }

  void _filterNoodles() {
    setState(() {
      _filteredNoodles = _noodles
          .where((noodle) =>
              noodle["name"]!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();

      if (_selectedFilters.isNotEmpty) {
        _filteredNoodles = _filteredNoodles
            .where((noodle) => _selectedFilters.contains(noodle["type"]))
            .toList();
      }
    });
  }

 
  void _toggleFilter(String category) {
    setState(() {
      if (_selectedFilters.contains(category)) {
        _selectedFilters.remove(category);
      } else {
        _selectedFilters.add(category);
      }
      _filterNoodles(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for noodles...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.all(8.0), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0), 
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedFilters.contains(category),
                      onSelected: (_) => _toggleFilter(category),
                      selectedColor: Colors.orange,
                      backgroundColor: Colors.grey[300],
                    ),
                  );
    }).toList(),
  ),
),

            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/logo.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
              ),
              itemCount: _filteredNoodles.length,
              itemBuilder: (context, index) {
                var noodle = _filteredNoodles[index];
                return _buildGridCard(
                   noodle["image"]!,
                  noodle["name"]!,
                  noodle["price"]!,
                  index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(String imgpath, String noodleName, String noodlePrice, int index) {
    return Card(
      color: Colors.lightBlueAccent[50],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: imgpath,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imgpath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
            child: Column (
              children: [
                Text(
                  noodleName,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  noodlePrice,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(child: Row
          (
            mainAxisAlignment: MainAxisAlignment. center,
            children: [
            Builder(
                  builder: (context) => IconButton(
                      icon: const Icon(Icons.add_circle),
                      iconSize: 30,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              imgPath: imgpath,
                              noodleName: noodleName,
                              noodlePrice: noodlePrice,
                              index: index,
                            ),),);
                      },
                    ),
                ),
          ],))
         
        ],
      ),
    ),
  );
}
}
