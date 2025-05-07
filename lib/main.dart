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
      home: Scaffold(
        appBar: AppBar(title: Text('Discord OAuth with Supabase')),
        body: Center(
          child: ElevatedButton(
            onPressed: signInWithDiscord,
            child: Text('Sign in with Discord'),
          ),
        ),
      ),
    );
  }
}
