import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final session = Supabase.instance.client.auth.currentSession;
    final SupabaseClient supabase = Supabase.instance.client;
    if (session == null) {
      return const Center(
        child: Text("アカウントの情報を取得できませんでした"),
      );
    }

    print(session.user.userMetadata);
    print(session.user.userMetadata?["custom_claims"]["global_name"]);
    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
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
              body: Center(
                child:Container(
                  padding: const EdgeInsets.all(30),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect( // アイコン表示（角丸）
                        borderRadius: BorderRadius.circular(200),
                        child: Image.network(session.user.userMetadata?["avatar_url"]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child:Text(
                          session.user.userMetadata?["custom_claims"]["global_name"], 
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 231, 231, 231),
                          foregroundColor: Colors.black,
                          shape: const StadiumBorder(),
                          elevation: 0, // Shadow elevation
                          shadowColor: const Color.fromARGB(
                              255, 255, 255, 255), // Shadow color
                        ),
                        onPressed: () {
                          try {
                            supabase.auth.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        label: const Text('ログアウト',
                            style: (TextStyle(
                                color: Color.fromARGB(255, 22, 22, 22),
                                fontSize: 16))),
                      ),
                    ],
                  )
                )
              )
            ),
    );
  }
}
