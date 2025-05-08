import 'package:flutter/material.dart';

class tabsAccount extends StatefulWidget {
  const tabsAccount({Key? key}) : super(key: key);
  @override
  _tabsAccountState createState() => _tabsAccountState();
}

class _tabsAccountState extends State<tabsAccount> {
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
        child: 
            Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: const Text(
                  'アカウント',
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
