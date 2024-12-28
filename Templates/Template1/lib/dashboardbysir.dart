import 'package:flutter/material.dart';

/// Root Widget - Main Entry Point
class D2 extends StatelessWidget {
  const D2({super.key});

  static const appTitle = 'Soflution';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle), // Navigates to Home Page
    );
  }
}

/// Home Page with AppBar, Drawer, Body, and Bottom Navigation Bar
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// State Variables
  int _selectedDrawerIndex = -1; // Tracks the selected drawer item (-1 = none)
  int _selectedBottomIndex = 0; // Tracks the selected bottom navigation tab

  /// Updates the Selected Drawer Index
  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  /// Updates the Selected Bottom Navigation Index
  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
      _selectedDrawerIndex = -1; // Reset drawer selection on bottom nav change
    });
  }

  /// Builds the Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // AppBar Section
      body: _buildBody(), // Body Section
      drawer: _buildDrawer(context), // Drawer Section
      bottomNavigationBar: _buildBottomNavBar(), // Bottom Navigation Bar Section
    );
  }

  /// Section 1: AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurpleAccent,
      centerTitle: true, // Ensures the title/logo is centered
      title: SizedBox(
        height: 45, // Adjust height of the logo
        child: Image.asset('assets/images/logo.png'), // Replace with your image path
      ),
    );
  }

  /// Section 2: Body
  Widget _buildBody() {
    if (_selectedDrawerIndex != -1) {
      return _drawerOptions[_selectedDrawerIndex];
    }

    if (_selectedBottomIndex == 1) {
      return _buildGridView();
    }

    return _bottomOptions[_selectedBottomIndex];
  }

  /// Section 3: Drawer
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Removes padding
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            child: Text('Drawer Header', style: TextStyle(color: Colors.white)),
          ),
          _buildDrawerItem(context, 'Men', 0),
          _buildDrawerItem(context, 'Women', 1),
          _buildDrawerItem(context, 'Kids', 2),
        ],
      ),
    );
  }

  /// Helper to Build Drawer Items
  ListTile _buildDrawerItem(BuildContext context, String title, int index) {
    return ListTile(
      title: Text(title),
      selected: _selectedDrawerIndex == index, // Highlights selected option
      onTap: () {
        _onDrawerItemSelected(index); // Updates the selected index
        Navigator.pop(context); // Closes the drawer
      },
    );
  }

  /// Section 4: Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
      ],
      currentIndex: _selectedBottomIndex, // Highlights selected tab
      onTap: _onBottomNavTapped, // Updates the selected tab
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
    );
  }

  /// Helper Widgets for Drawer Sections
  Widget _buildMenSection() {
    return const Center(child: Text("Men's Section"));
  }

  Widget _buildWomenSection() {
    return const Center(child: Text("Women's Section"));
  }

  Widget _buildKidsSection() {
    return const Center(child: Text("Kids' Section"));
  }

  /// Helper Widgets for Bottom Navigation Sections
  Widget _buildHomeSection() {
    return const Center(child: Text("Home Page"));
  }

  Widget _buildSearchSection() {
    return _buildGridView();
  }

  Widget _buildWishlistSection() {
    return const Center(child: Text("Wishlist Page"));
  }

  /// Helper for Grid View (for Search Section)
  Widget _buildGridView() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return myBox(index + 1);
      },
    );
  }

  /// Section 5: Custom Widget for Items
  Widget myBox(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.deepOrange,
      alignment: Alignment.center,
      child: Text("$index"),
    );
  }

  /// Dummy Drawer Options
  List<Widget> _drawerOptions = [
    const Center(child: Text("Men's Section")),
    const Center(child: Text("Women's Section")),
    const Center(child: Text("Kids' Section")),
  ];

  /// Dummy Bottom Navigation Options
  List<Widget> _bottomOptions = [
    const Center(child: Text("Home Page")),
    const Center(child: Text("Search Page")),
    const Center(child: Text("Wishlist Page")),
  ];
}
