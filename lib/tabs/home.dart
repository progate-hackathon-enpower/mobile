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
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio: 1,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close)
                                    )
                                  ),
                                ],
                              ),
                            ]
                          )
                        )
                      );
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(128), //角の丸み
                ),
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(200, 255, 255, 255),
                ),
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
