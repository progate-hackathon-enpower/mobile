import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage();

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool logined = false;
  // final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(ModalRoute.of(context)?.settings.name ?? '');
    final queryParam = uri.queryParameters['state'] ?? '';
    final url = queryParam.split(",")[1] ?? 'mokuhub.vercel.com';
    openUrl()async{
      if(kIsWeb){
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print("URLを開けません: $uri");
        }
      }
    }
    openUrl();
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 17, 17, 17),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              constraints: BoxConstraints(maxWidth:400 ),
            child:Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.5
            ),
            ),]
        )
      ),
    );
  }
}
