import 'package:flutter/material.dart';
import 'package:mobile/utils/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/tabs.dart';

class newUserPage extends StatefulWidget {
  const newUserPage({Key? key}) : super(key: key);
  @override
  _newUserPageState createState() => _newUserPageState();
}

class _newUserPageState extends State<newUserPage> {
  @override // 限界まで足掻いた人生は想像よりも狂っているらしい
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool editName = false;
  final session = Supabase.instance.client.auth.currentSession;
  final SupabaseClient supabase = Supabase.instance.client;
  String displayName = "";
  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Center(
        child: Text("アカウントの情報を取得できませんでした"),
      );
    }
    if(displayName.isEmpty) displayName = session?.user.userMetadata?["custom_claims"]["global_name"];

    // print(session?.user.userMetadata);
    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
          heroTag: "next_button",
          onPressed: ()async{
            await newUser(session?.user.userMetadata?["provider_id"], displayName, session?.user.userMetadata?["avatar_url"], null);
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => PageViewTabsScreen()),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128),
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Color.fromARGB(200, 255, 255, 255),
          ),
        ),
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: const Text(
            'ようこそ！',
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
            child:GestureDetector(
              onTap:(){
                setState(() {
                  editName = !editName;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect( // アイコン表示（角丸）
                    borderRadius: BorderRadius.circular(200),
                    child: Image.network(session?.user.userMetadata?["avatar_url"]),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: editName ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        Icon(Icons.edit)
                      ]
                    ): TextField(
                      onTapOutside: (_) {
                        print(displayName);
                        FocusScope.of(context).unfocus();
                        setState(() {editName = !editName;});
                      },
                      onChanged: (value) => {
                        displayName = value
                      },
                      controller: TextEditingController(text: displayName),
                      textAlign: TextAlign.center,
                      style:TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ),
                ],
              )
            )
          )
        )
      ),
    );
  }
}
