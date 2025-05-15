import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

// GitHubユーザー情報を格納するクラス
class GitHubUser {
  final int id;
  final String login;
  final String avatarUrl;
  final String? name;
  final String? email;
  final String? bio;
  final int publicRepos;
  final int followers;
  final int following;

  GitHubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    this.name,
    this.email,
    this.bio,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      publicRepos: json['public_repos'] as int,
      followers: json['followers'] as int,
      following: json['following'] as int,
    );
  }
}

Future<String?> getGitHubAccessToken({
  required String code,
  required String redirectUri,
}) async {
  try {
    // 環境変数から認証情報を取得
    final String? clientId = kIsWeb 
      ? const String.fromEnvironment("GITHUB_CLIENT_ID")
      : dotenv.env["GITHUB_CLIENT_ID"];
    final String? clientSecret = kIsWeb
      ? const String.fromEnvironment("GITHUB_CLIENT_SECRET")
      : dotenv.env["GITHUB_CLIENT_SECRET"];

    if (clientId == null || clientSecret == null) {
      throw Exception('GitHub credentials not found in environment variables');
    }

    // GitHubのアクセストークンエンドポイントにPOSTリクエスト
    final response = await http.post(
      Uri.parse('https://github.com/login/oauth/access_token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['access_token'] as String?;
    } else {
      throw Exception('Failed to get access token: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting GitHub access token: $e');
    return null;
  }
}

// GitHubユーザー情報を取得する関数
Future<GitHubUser?> getGitHubUser(String accessToken) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return GitHubUser.fromJson(data);
    } else {
      throw Exception('Failed to get user info: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting GitHub user: $e');
    return null;
  }
}

