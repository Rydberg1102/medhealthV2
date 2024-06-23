import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medhealth/Admin/admin_history_page.dart';
import 'package:medhealth/Admin/admin_home_page.dart';
import 'package:medhealth/Admin/admin_info_page.dart';
import 'package:medhealth/Admin/admin_profile_page.dart';

class AdminMainPages extends StatefulWidget {
  const AdminMainPages({super.key});

  @override
  State<AdminMainPages> createState() => _AdminMainPagesState();
}

class _AdminMainPagesState extends State<AdminMainPages> {
  int _selectIndex = 0;

  final _pageList = [
    AdminHomePage(),
    AdminHistoryPage(),
    AdminInfoPage(),
    AdminProfilePage(),
  ];

  onTappedItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.history,
                text: 'History',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
            selectedIndex: _selectIndex,
            onTabChange: (index) {
              onTappedItem(index);
            },
          ),
        ),
      ),
    );
  }
}
