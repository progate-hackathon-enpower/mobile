import 'package:flutter/material.dart';
import 'package:mobile/new_user.dart';
import 'package:mobile/switch_redirect.dart';
import 'package:mobile/tabs.dart';
import 'package:mobile/utils/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';
import 'package:mobile/utils/github.dart';
import 'package:url_strategy/url_strategy.dart';

bool logined = false;
void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    const baseUrl = String.fromEnvironment("SUPABASE_URL");
    const anonKey = String.fromEnvironment("SUPABASE_ANON_KEY");
    if(baseUrl.isNotEmpty && anonKey.isNotEmpty){
      await Supabase.initialize(
        url: baseUrl,
        anonKey: anonKey,
      );
    }else{
      runApp(MyApp(failed:true));
      return;
    }
  }else{
    await dotenv.load();
    final baseUrl = dotenv.env["SUPABASE_URL"];
    final anonKey = dotenv.env["ANON_KEY"];
    if(baseUrl != null && anonKey != null){
      await Supabase.initialize(
        url: baseUrl,
        anonKey: anonKey,
      );
    }else{
      runApp(MyApp(failed:true));
      return;
    }
  }

  runApp(MyApp(failed:false));
}

class MyApp extends StatelessWidget {
  final bool failed;
  const MyApp({Key? key,required this.failed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enpower',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '');
        if (uri.path == '/redirect') {
          logined = true;
          return MaterialPageRoute(builder: (context) => SwitchPage(uri));
        }
        return MaterialPageRoute(builder: (context) => HomePage());
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if(!kIsWeb){
      final session = Supabase.instance.client.auth.currentSession;
      uriLinkStream.listen((Uri? uri)async {
        print(uri?.scheme);
        print(uri?.path);
        if (uri != null && uri.scheme == "enpower" && uri.path == "/redirect") {
          final queryParameters = uri.queryParameters;
          final res = await getGitHubAccessToken(code: queryParameters['code'] ?? '', redirectUri: "https://mokuhub.vercel.app/redirect");
          print(res);
          try{
            if(res != null){
              final user = await getGitHubUser(res);
              print(user?.id);
              updateUser(
                userId:session?.user.userMetadata?["provider_id"],
                githubId: user?.id.toString(),
              );
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("連携完了"),
                    content: Text("GitHubアカウント「${user?.name}」との連携が完了しました"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            }
          }catch(e){
            print(e);
          }
        }else{
          print("対応してないよーん");
        }
      });
    }
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
      backgroundColor: Colors.black,
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
            Supabase.instance.client.auth.currentSession == null ? ElevatedButton.icon(
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
            ):Container(),
          ]
        )
      ),
    );
  }
}
