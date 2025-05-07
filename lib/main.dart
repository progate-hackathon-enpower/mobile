import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env["supabase_url"]!,
    anonKey: dotenv.env["anon_key"]!,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == "enpower") {
        print("Received OAuth callback: ${uri.toString()}");
      }
    });
  }

  Future<void> signInWithDiscord() async {
    await supabase.auth.signInWithOAuth(
    OAuthProvider.discord,
    redirectTo: kIsWeb ? null : 'enpower://auth', // Optionally set the redirect link to bring back the user via deeplink.
    authScreenLaunchMode:
        kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
  );
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
