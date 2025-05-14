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
  String message = "";

  @override
  void initState() {
    super.initState();
        print("ついに戻ってキタァァぁぁ！！！！！！");
    final queryParameters = widget.uri.queryParameters;
    final queryParam = queryParameters['state'] ?? '';
    print(queryParam.split(","));
    final customUri = Uri.parse(queryParam.split(",")[1]);
    final url = queryParam.split(",").length == 2 
    ? 
    Uri(
      host: customUri.host,
      queryParameters: queryParameters,
      path:widget.uri.path,
      scheme: customUri.scheme
    ).toString()
    :
    Uri(
      host: "mokuhub.vercel.app",
      queryParameters: queryParameters,
      path:widget.uri.path,
      scheme:"https"
    ).toString();

    openUrl()async{
      if(kIsWeb){
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          setState((){
          message="リダイレクトに失敗しました";
          });
        }
      }
    }
    openUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
            ),
            Text(message,style:TextStyle(color:Colors.white))]
        )
      ),
    );
  }
}
