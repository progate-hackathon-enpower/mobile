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
    
    if (deepLinkUri != null) {
      // モバイルアプリの場合は直接ディープリンクを開く
      if (!kIsWeb) {
        final Uri uri = Uri.parse(deepLinkUri).replace(
          queryParameters: {
            ...queryParameters, // 既存のクエリパラメータをすべて含める
            'original_path': widget.uri.path, // 元のパスも保持
          }
        );
        
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          if (mounted) {
            Navigator.of(context).pop(); // リダイレクト後にページを閉じる
          }
        } else {
          setState(() {
            message = "アプリを開けませんでした";
          });
        }
      } else {
        // Web環境の場合
        final Uri uri = Uri.parse("enpower://redirect");
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          setState(() {
            message = "リダイレクトに失敗しました";
          });
        }
      }
    } else {
      // ディープリンクURIがない場合はそのまま認証
      final res = await getGitHubAccessToken(code: queryParameters['code'] ?? '', redirectUri: "https://mokuhub.vercel.app/redirect");
      if(res != null){
        final user = await getGitHubUser(res);
        updateUser(
          githubId: user?.id.toString(),
        );
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
