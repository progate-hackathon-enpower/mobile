import 'package:flutter/material.dart';
import 'package:mobile/utils/users.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/utils/github.dart';

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
    Future<String> getGitHubStats() async {
      final session = Supabase.instance.client.auth.currentSession;
      final userId = session?.user.userMetadata?["provider_id"];
      final userProfile = await getUser(userId);
      print(userProfile);
      print(userProfile?["github_username"]);
      final stats = await getStats(userProfile?["github_username"]);
      print(stats);
      return stats;
    }
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
          heroTag: "add_button",
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '活動を記録する',
                                style:TextStyle(fontSize: 16)
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
        body: FutureBuilder(
            future: getGitHubStats(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                final data = jsonDecode(snapshot.data!) as List<dynamic>;
                return data.length == 0 ? Center(child: Text("活動がありません")) : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(data[index]['type'] ?? 'Unknown Event'),
                    subtitle: Text('Repository: ${data[index]['repo']['name'] ?? 'Unknown'}'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data[index]['actor']['avatar_url']),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        )
      ),
    );
  }
}
