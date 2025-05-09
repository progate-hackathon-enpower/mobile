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
