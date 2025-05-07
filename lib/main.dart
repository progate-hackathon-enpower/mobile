import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env["supabase_url"]!,
    anonKey: dotenv.env["anon_key"]!,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signInWithDiscord() async {
    final authUrl = await supabase.auth.getOAuthSignInUrl(provider: OAuthProvider.discord);
    if (await canLaunch(authUrl.url)) {
      await launch(authUrl.url);
    } else {
      throw 'Could not launch ${authUrl.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Enpower",
      home: Scaffold(
        body: Center(
          child: ElevatedButton.icon(
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
                signInWithDiscord();
              } catch (e) {
                print(e);
              }
            },
            icon: const ImageIcon(
              size:30,
              AssetImage("assets/images/discord.png"),
              color: Color.fromARGB(255, 22, 22, 22),
            ),
            label: const Text('Discordでログイン',
                style: (TextStyle(
                    color: Color.fromARGB(255, 22, 22, 22),
                    fontSize: 16))),
          ),
        ),
      ),
    );
  }
}
