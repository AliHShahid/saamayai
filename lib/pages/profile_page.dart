import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import '../widgets/full_screen_image_viewer.dart';

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

    if (!mounted) return;

    setState(() {
      userProfile = response ?? {};
      _avatarUrl = userProfile?['avatar_url'];
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false, // clear all previous routes
            );
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
            // const Divider(),
          ],
        ),
      ),
    );
  }
}
