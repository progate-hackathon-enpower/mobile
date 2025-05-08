import 'package:flutter/material.dart';

class tabsHome extends StatefulWidget {
  const tabsHome({Key? key}) : super(key: key);
  @override
  _tabsHomeState createState() => _tabsHomeState();
}

class _tabsHomeState extends State<tabsHome>{
  @override // 限界まで足掻いた人生は想像よりも狂っているらしい
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: const Text(
                  'ホーム',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 20
                ),
                backgroundColor: const Color.fromARGB(255, 40, 40, 40),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                ],
              )
            ),
    );
  }
}
