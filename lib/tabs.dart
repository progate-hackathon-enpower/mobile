import 'package:flutter/material.dart';
import 'package:mobile/tabs/account.dart';
import 'package:mobile/tabs/home.dart';

class PageViewTabsScreen extends StatefulWidget {
  @override
  TabsScreen createState() => TabsScreen();
}

class TabsScreen extends State<PageViewTabsScreen> {
  TabsScreen();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: selectedIndex,
        enableFeedback: false,
        onTap: (value) {
          selectedIndex = value;
          setState(() {});
        },
        unselectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 200, 200, 200)),
        unselectedItemColor: const Color.fromARGB(255, 200, 200, 200),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'アカウント',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      ),
      body: IndexedStack(
        index:selectedIndex,
        children:[
          tabsHome(),
          tabsAccount()
        ]
      ),
    );
  }
}