import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkUserExists(String userId) async {
  final response = await Supabase.instance.client
      .from('users')
      .select('id')
      .eq('id', userId)
      .maybeSingle();

  return response != null; // 結果が空でなければ存在する
}

Future<void> newUser(String userId, String displayName, String avatarUrl, String? githubId, String? github_username) async {
  await Supabase.instance.client
      .from('users')
      .insert({
        'id': userId,
        'github_id': githubId,
        'icon_url': avatarUrl,
        'display_name': displayName,
        'github_username': github_username,
      });
}

Future<void> updateUser({required String userId, String? displayName, String? avatarUrl, String? githubId, String? githubUsername}) async {
  if(displayName == null && avatarUrl == null && githubId == null && githubUsername == null){
    return;
  }
  await Supabase.instance.client
      .from('users')
      .update({
        if(displayName != null) 'display_name' : displayName,
        if(avatarUrl != null) 'icon_url' : avatarUrl,
        if(githubId != null) 'github_id' : githubId,
        if(githubUsername != null) 'github_username' : githubUsername,
      }).eq('id', userId);
      print("更新しました");
}

Future<Map<String, dynamic>?> getUser(String userId) async {
  final response = await Supabase.instance.client
      .from('users')
      .select('*')
      .eq('id', userId)
      .maybeSingle();
  return response;
}