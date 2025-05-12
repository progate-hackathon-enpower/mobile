import 'package:flutter/material.dart';
import 'package:mobile/new_user.dart';
import 'package:mobile/tabs.dart';
import 'package:mobile/utils/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env["supabase_url"]!,
    anonKey: dotenv.env["anon_key"]!,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enpower',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 22, 22, 22)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool logined = false;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    uriLinkStream.listen((Uri? uri)async {
      if (uri != null && uri.scheme == "enpower" && !logined) {
        logined = true;
        // print("Received OAuth callback: ${uri.toString()}");
        final String? code = uri.queryParameters['code'];
        if (code != null) {
          try{
            final res = await Supabase.instance.client.auth.getSessionFromUrl(uri);
            
            // print(res.session);
            if (!res.session.isExpired) {
              final bool exist = await checkUserExists(res.session.user.userMetadata?["provider_id"]);
              if(exist){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageViewTabsScreen()),
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newUserPage()),
                );
              }

            } else {
              // print("Failed to authenticate user.");
            }
          } catch (e) {
            // print("Error during authentication: $e");
          }
        }
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
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null && !logined) {
      logined = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final bool exist = await checkUserExists(session.user.userMetadata?["provider_id"]);
        if(exist){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageViewTabsScreen()),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => newUserPage()),
          );
        }
      });
    }

    return Scaffold(
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
          onPressed: () async {
            try {
              await signInWithDiscord();
            } catch (e) {
              // print(e);
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
    );
  }
}
