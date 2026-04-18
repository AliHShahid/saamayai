import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/full_screen_image_viewer.dart';
import '../services/preference_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic>? userProfile;
  String? _avatarUrl;
  bool _isLoading = true;
  Set<String> _activeDates = {};
  int _currentStreak = 0;
  int _longestStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Load profile data once when page opens
  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    final prefService = PreferenceService();
    final streakStats = await prefService.getStreakStats();
    final history = await prefService.getHistory();
    final active = <String>{};
    for (var item in history) {
      if (item['date'] != null) {
        try {
          final parsed = DateTime.parse(item['date'].toString()).toLocal();
          active.add('${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}');
        } catch (e) {
          // ignore
        }
      }
    }

    if (!mounted) return;

    setState(() {
      userProfile = response ?? {};
      _avatarUrl = userProfile?['avatar_url'];
      _activeDates = active;
      _currentStreak = streakStats['current'] ?? 0;
      _longestStreak = streakStats['longest'] ?? 0;
      _isLoading = false;
    });
  }

  /// Pick image from gallery & upload to Supabase
  Future<void> _pickAndUploadAvatar() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final fileBytes = await pickedFile.readAsBytes();
      final fileExt = pickedFile.path.split('.').last;
      final fileName = '${user.id}/avatar.$fileExt';

      // Upload to Supabase storage (avatars bucket)
      await supabase.storage.from('avatars').uploadBinary(
            fileName,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get public URL
      final avatarUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      // Update in DB
      await supabase.from('profiles').update({
        'avatar_url': avatarUrl,
      }).eq('id', user.id);

      if (!mounted) return;
      setState(() {
        _avatarUrl = avatarUrl;
      });
    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  /// Edit name popup
  Future<void> _editNameDialog() async {
    final controller =
        TextEditingController(text: userProfile?['display_name'] ?? "");
    final userId = supabase.auth.currentUser!.id;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Enter your name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await supabase
                    .from('profiles')
                    .update({'display_name': newName}).eq('id', userId);

                if (mounted) {
                  setState(() {
                    userProfile?['display_name'] = newName;
                  });
                }

                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar with edit button
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FullScreenImageViewer(
                          imageUrl: _avatarUrl!,
                          heroTag:
                              'profile-avatar-${supabase.auth.currentUser?.id}',
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  } else {
                    // Optionally open full-screen even for default asset:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imageUrl:
                              '', // empty means use default asset inside viewer
                          heroTag:
                              'profile-avatar-${supabase.auth.currentUser?.id}',
                          useAssetIfEmpty: true,
                        ),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // blurred background circle (slightly bigger)
                      // ClipOval(
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      //     child: Container(
                      //       width: 140,
                      //       height: 140,
                      //       color: Colors.black.withOpacity(0.15),
                      //     ),
                      //   ),
                      // ),

                      // gradient ring
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 42, 221, 170),
                              Color.fromARGB(255, 175, 52, 91),
                              Color.fromARGB(255, 255, 255, 255),
                            ],
                          ),
                        ),
                      ),

                      // inner white border and avatar
                      Container(
                        width: 110,
                        height: 110,
                        padding:
                            const EdgeInsets.all(4), // white border thickness
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Hero(
                          tag:
                              'profile-avatar-${supabase.auth.currentUser?.id}',
                          child: ClipOval(
                            child: Container(
                              color: Colors.grey[200],
                              child: _avatarUrl != null &&
                                      _avatarUrl!.isNotEmpty
                                  ? Image.network(
                                      _avatarUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/default_avatar.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/default_avatar.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      // camera icon (edit)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton(
                          mini: true,
                          elevation: 2,
                          backgroundColor: Colors.white,
                          onPressed: _pickAndUploadAvatar,
                          child: const Icon(Icons.camera_alt,
                              color: Colors.blue, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Name
            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: Text(
            //     userProfile?['display_name'] ?? "No Name",
            //     style: const TextStyle(fontSize: 18),
            //   ),
            //   subtitle: const Text("Name"),
            //   trailing: IconButton(
            //     icon: const Icon(Icons.edit),
            //     onPressed: _editNameDialog,
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                userProfile?['display_name'] ?? "No Name",
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: const Text("Name"),
              onTap: _editNameDialog, // 👈 tap anywhere to edit
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey[100], // optional for touch feedback
              trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                  color: Colors.grey),
            ),

            // const Divider(),

            // Email
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user.email ?? "No email"),
              subtitle: const Text("Email"),
            ),
            // const Divider(),

            // Date Joined
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                DateTime.parse(user.createdAt)
                        .toLocal()
                        .toString()
                        .split(' ')[0],
              ),
              subtitle: const Text("Date Joined"),
            ),
            const SizedBox(height: 32),
            _buildActivityGrid(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGrid() {
    // Generate the last 140 days (20 weeks)
    final today = DateTime.now();
    final days = List.generate(140, (i) => today.subtract(Duration(days: 139 - i)));
    
    List<Widget> columns = [];
    for (int i = 0; i < 140; i += 7) {
      List<Widget> columnCells = [];
      for (int j = 0; j < 7; j++) {
        if (i + j < 140) {
          final date = days[i + j];
          final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final isActive = _activeDates.contains(dateStr);
          
          columnCells.add(
            Tooltip(
              message: dateStr,
              child: Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFFFD54F) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )
          );
        }
      }
      columns.add(Column(children: columnCells));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recitation Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Image.asset('assets/cap.png', width: 18, height: 18),
                const SizedBox(width: 4),
                Text(
                  " $_currentStreak Day Streak",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Focuses right side (most recent)
            child: Row(
              children: columns,
            ),
          ),
        ),
      ],
    );
  }
}
