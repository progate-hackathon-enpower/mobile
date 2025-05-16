import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final queryParameters = widget.uri.queryParameters;
    final state = queryParameters['state'] ?? '';
    final stateComponents = state.split(',');
    
    // ディープリンクURIの取得（state パラメータの2番目の要素）
    final String? openMode = stateComponents.length > 1 ? stateComponents[1] : null;
    if (kIsWeb && openMode == "mobile") {
      // モバイルアプリの場合は直接ディープリンクを開く
        setState(() {
          message = Text("ここまではきてる", style:TextStyle(color: Colors.white));
        });
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
