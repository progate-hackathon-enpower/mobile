import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/utils/github.dart';
import 'package:mobile/utils/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwitchPage extends StatefulWidget {
  final Uri uri;
  const SwitchPage(this.uri);

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  // final SupabaseClient supabase = Supabase.instance.client;
  Widget message = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );

  @override
  void initState() {
    super.initState();
    handleRedirect();
  }

  void handleRedirect() async {
    final session = Supabase.instance.client.auth.currentSession;
    final queryParameters = widget.uri.queryParameters;
    final state = queryParameters['state'] ?? '';
    final stateComponents = state.split(',');
    
    // ディープリンクURIの取得（state パラメータの2番目の要素）
    final String? openMode = stateComponents.length > 1 ? stateComponents[1] : null;
    if (kIsWeb) {
      if(openMode == "mobile"){
        // モバイルアプリの場合は直接ディープリンクを開く
        final Uri uri = Uri(scheme: "enpower",path:widget.uri.path,queryParameters: widget.uri.queryParameters);
        try{
          setState((){
            message = ElevatedButton(
              onPressed: () async {
                await launchUrl(uri);
              },
              child: Text('アプリを開く'),
            );
          });
        }catch(e){
          setState(() {
            message = Text("リダイレクトに失敗しました:$uri,$e", style:TextStyle(color: Colors.white));
          });
        }
      }else{
        if (widget.uri.path == "/redirect") {
          final queryParameters = widget.uri.queryParameters;
          print("パラメーター");
          print(queryParameters['code']);
          final res = await getGitHubAccessToken(code: queryParameters['code'] ?? '', redirectUri: "https://mokuhub.vercel.app/redirect");
          print(res);
          try{
            if(res != null){
              final user = await getGitHubUser(res);
              print(user?.id);
              print(user?.login);
              await updateUser(
                userId:session?.user.userMetadata?["provider_id"],
                githubId: user?.id.toString(),
                githubUsername: user?.login,
              );
              setState((){
                message=Column(
                  children:[
                    Text("GitHubアカウント「${user?.name}」と連携が完了しました。",style:TextStyle(color:Colors.white)),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/');
                      }, 
                      child: Text("ホームに戻る")
                    )
                  ]
                );
              });
            }
          }catch(e){
            print(e);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.5
              ),
            ),
            message
          ]
        )
      ),
    );
  }
}
