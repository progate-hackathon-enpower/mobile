import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/utils/github.dart';
import 'package:mobile/utils/users.dart';
class SwitchPage extends StatefulWidget {
  final Uri uri;
  const SwitchPage(this.uri);

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  // final SupabaseClient supabase = Supabase.instance.client;
  String message = "";

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
    final String? deepLinkUri = stateComponents.length > 1 ? stateComponents[1] : null;
    final res = await getGitHubAccessToken(code: queryParameters['code'] ?? '', redirectUri: "https://mokuhub.vercel.app/redirect");
    try{
      if(res != null){
        final user = await getGitHubUser(res);
        updateUser(
          githubId: user?.id.toString(),
        );
      }
    }catch(e){
      setState(() {
        message = "認証に失敗:$e";
      });
    }
    if (!kIsWeb && deepLinkUri != null) {
      // モバイルアプリの場合は直接ディープリンクを開く
      final Uri uri = Uri.parse("enpower://redirect");
      try{
        await launchUrl(uri);
      }catch(e){
        setState(() {
          message = "リダイレクトに失敗しました:$uri,$e";
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
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(color: Colors.white)
              ),
            if (message.isEmpty)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ]
        )
      ),
    );
  }
}
