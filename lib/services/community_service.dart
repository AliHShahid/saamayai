import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCommunities() async {
    final response = await _supabase
        .from('communities')
        .select('*, community_members(count)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createCommunity(String name, String description) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _supabase.from('communities').insert({
      'name': name,
      'description': description,
      'owner_id': user.id,
    });
  }

  Future<List<String>> getJoinedCommunityIds() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('community_members')
        .select('community_id')
        .eq('user_id', user.id);
        
    return response.map((e) => e['community_id'] as String).toList();
  }

  Future<void> joinCommunity(String communityId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _supabase.from('community_members').insert({
      'community_id': communityId,
      'user_id': user.id,
    });
  }

  Future<void> leaveCommunity(String communityId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _supabase
        .from('community_members')
        .delete()
        .eq('community_id', communityId)
        .eq('user_id', user.id);
  }

  Future<void> sendMessage(String communityId, String content) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _supabase.from('community_messages').insert({
      'community_id': communityId,
      'user_id': user.id,
      'content': content,
    });
  }
}
