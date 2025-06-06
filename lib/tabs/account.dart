import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile/utils/users.dart';
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

    var uuid = Uuid();

    // print(session.user.userMetadata);
    // print(session.user.userMetadata?["custom_claims"]["global_name"]);
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
            backgroundColor: const Color.fromARGB(255, 30, 22, 80),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/thumbnail.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(200, 0, 0, 0), BlendMode.darken),
                opacity: 0.5,
              )
            ),
            child:FutureBuilder(
            future: getUser(session.user.userMetadata?["provider_id"]),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
              return Center(
                child:Container(
                  padding: const EdgeInsets.all(30),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect( // アイコン表示（角丸）
                        borderRadius: BorderRadius.circular(200),
                        child: Image.network(session.user.userMetadata?["avatar_url"]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child:Column(
                          children:[
                            Text(
                              snapshot.data?["display_name"] ?? session.user.userMetadata?["custom_claims"]["global_name"],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(200, 255, 255, 255),
                              )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Image.asset("assets/images/png_logo.png", width: 25, height: 25),
                                Text(
                                  snapshot.data?["moku_point"].toString() ?? "取得中...",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(150, 255, 255, 255),
                                  )
                                ),
                              ]
                            ),
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children:[
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
                              onPressed: () async {
                                try {
                                  final Uri uri = Uri.parse("https://github.com/apps/mokuhub-apps/installations/new?state=${uuid.v4()}${kIsWeb ? "" : ",mobile"}&redirect_uri=https://mokuhub.vercel.app/redirect");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                } catch (e) {
                                  // print(e);
                                }
                              },
                              icon: const ImageIcon(
                                size:30,
                                AssetImage("assets/images/github.png"),
                                color: Color.fromARGB(255, 22, 22, 22),
                              ),
                              label: const Text('連携',
                                  style: (TextStyle(
                                      color: Color.fromARGB(255, 22, 22, 22),
                                      fontSize: 16))),
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
                                  MaterialPageRoute(builder: (context) => const MyApp(failed: false,)),
                                );
                              } catch (e) {
                                // print(e);
                              }
                            },
                            label: const Text('ログアウト',
                                style: (TextStyle(
                                    color: Color.fromARGB(255, 22, 22, 22),
                                    fontSize: 16))),
                              ),
                            ]
                          )
                      ),
                    ],
                  )
                )
              );}
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          )
        )
      ),
    );
  }
}
