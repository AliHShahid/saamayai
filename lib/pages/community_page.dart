import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/community_service.dart';
import 'community_chat_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final CommunityService _communityService = CommunityService();
  final String? _currentUserId = Supabase.instance.client.auth.currentUser?.id;

  bool _isLoading = true;
  List<Map<String, dynamic>> _communities = [];
  Set<String> _joinedCommunityIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final communities = await _communityService.getCommunities();
      final joinedIds = await _communityService.getJoinedCommunityIds();

      if (mounted) {
        setState(() {
          _communities = communities;
          _joinedCommunityIds = joinedIds.toSet();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading communities: $e")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _showCreateCommunityDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isCreating = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Create Community"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Community Name"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isCreating ? null : () async {
                  if (nameController.text.trim().isEmpty) return;
                  
                  setDialogState(() => isCreating = true);
                  try {
                    await _communityService.createCommunity(
                      nameController.text.trim(),
                      descController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      _loadData(); // Refresh list
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  } finally {
                    setDialogState(() => isCreating = false);
                  }
                },
                child: isCreating 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Create"),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _toggleJoin(Map<String, dynamic> community) async {
    final communityId = community['id'] as String;
    final isJoined = _joinedCommunityIds.contains(communityId);

    // Optimistically calculate local state for the members count
    final commIndex = _communities.indexWhere((e) => e['id'] == communityId);
    int currentCount = 0;
    if (commIndex != -1) {
      final comm = _communities[commIndex];
      if (comm['community_members'] != null && comm['community_members'].isNotEmpty) {
        currentCount = comm['community_members'][0]['count'] ?? 0;
      }
    }

    try {
      if (isJoined) {
        await _communityService.leaveCommunity(communityId);
        setState(() {
          _joinedCommunityIds.remove(communityId);
          if (commIndex != -1) {
             _communities[commIndex]['community_members'] = [{'count': (currentCount > 0 ? currentCount - 1 : 0)}];
          }
        });
      } else {
        await _communityService.joinCommunity(communityId);
        setState(() {
          _joinedCommunityIds.add(communityId);
          if (commIndex != -1) {
             _communities[commIndex]['community_members'] = [{'count': currentCount + 1}];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating membership: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: Text(
          "Communities",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFDF5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showCreateCommunityDialog,
            tooltip: "Create Community",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _communities.isEmpty
              ? Center(
                  child: Text(
                    "No communities found.\nBe the first to create one!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _communities.length,
                  itemBuilder: (context, index) {
                    final comm = _communities[index];
                    final isOwner = comm['owner_id'] == _currentUserId;
                    final isJoined = _joinedCommunityIds.contains(comm['id']);
                    
                    int membersCount = 0;
                    if (comm['community_members'] != null) {
                      if (comm['community_members'] is List) {
                        final list = comm['community_members'] as List;
                        if (list.isNotEmpty && list.first['count'] != null) {
                          membersCount = list.first['count'];
                        }
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        if (!isJoined && !isOwner) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: const Text("Join the community first to access the chat."),
                               action: SnackBarAction(
                                 label: "Join",
                                 onPressed: () => _toggleJoin(comm),
                                 textColor: Colors.white,
                               ),
                             ),
                           );
                           return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommunityChatPage(
                              communityId: comm['id'],
                              communityName: comm['name'] ?? 'Unnamed',
                            )
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    comm['name'] ?? 'Unnamed',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isOwner)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Owner",
                                      style: TextStyle(fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comm['description'] ?? 'No description provided.',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "$membersCount Member${membersCount == 1 ? '' : 's'}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                                if (!isOwner) 
                                  ElevatedButton(
                                    onPressed: () => _toggleJoin(comm),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isJoined ? Colors.red.shade50 : const Color(0xFF1B4332),
                                      foregroundColor: isJoined ? Colors.red : Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      minimumSize: const Size(0, 36),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      elevation: 0,
                                    ),
                                    child: Text(isJoined ? "Leave" : "Join"),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  },
                ),
    );
  }
}
