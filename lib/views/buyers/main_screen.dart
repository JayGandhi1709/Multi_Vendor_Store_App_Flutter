import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/account_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/cart_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/category_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/home_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/search_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    CartScreen(),
    SearchScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // unselectedFontSize: 0,
        // selectedFontSize: 0,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: GlobalVariables.primaryColor,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/explore.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _pageIndex == 1 ? GlobalVariables.primaryColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: 'CATEGORIES',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _pageIndex == 2 ? GlobalVariables.primaryColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: 'SHORE',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/cart.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _pageIndex == 3 ? GlobalVariables.primaryColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _pageIndex == 4 ? GlobalVariables.primaryColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: 'SEARCH',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/account.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _pageIndex == 5 ? GlobalVariables.primaryColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: 'ACCOUNT',
          ),
        ],
      ),
    );
  }
}
