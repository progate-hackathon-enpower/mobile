import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkUserExists(String userId) async {
  final response = await Supabase.instance.client
      .from('users')
      .select('id')
      .eq('id', userId)
      .maybeSingle();

  return response != null; // 結果が空でなければ存在する
}

Future<void> newUser(String userId, String displayName, String avatarUrl, String? githubId) async {
  await Supabase.instance.client
      .from('users')
      .insert({
        'id': userId,
        'github_id': githubId,
        'icon_url': avatarUrl,
        'display_name': displayName,        
      });
}

Future<void> updateUser({String? userId, String? displayName, String? avatarUrl, String? githubId}) async {
  if(userId == null && displayName == null && avatarUrl == null && githubId == null){
    return;
  }
  await Supabase.instance.client
      .from('users')
      .update({
        displayName != null ? 'display_name' : displayName : null,
        avatarUrl != null ? 'icon_url' : avatarUrl : null,
        githubId != null ? 'github_id' : githubId : null,
      });
}

