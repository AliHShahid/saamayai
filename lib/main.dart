// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme_provider.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'pages/update_password_page.dart';
import 'package:provider/provider.dart';
import 'services/stt_service.dart';

const supabaseUrl = 'https://advrtbxulkdblpxuflbk.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkdnJ0Ynh1bGtkYmxweHVmbGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzMzkzMzgsImV4cCI6MjA3NTkxNTMzOH0.5lsmWboDYkUoLLIM481yKJqdpw95SDf_16TOLWLljzI';

// For mobile OAuth and password reset flows, set this to your custom scheme.
// Example Android/iOS scheme: io.supabase.saamay://auth-callback
const mobileRedirectUri = 'io.supabase.saamay://auth-callback';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const SaamayApp(),
    ),
  );
}

class SaamayApp extends StatelessWidget {
  const SaamayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Saamay',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      // Start with Splash Screen for ALL users (Logged in or not)
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startWarmupSequence();
  }

  Future<void> _startWarmupSequence() async {
    // Wait for at least 2 seconds (for branding/animation) 
    // AND for the backend warmup to complete.
    final minWait = Future.delayed(const Duration(seconds: 2));
    final backendWarmup = _triggerWarmup();

    await Future.wait([minWait, backendWarmup]);

    if (mounted) {
      // Navigate to AuthGate to decide where to go (Home vs Login)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    }
  }

  Future<void> _triggerWarmup() async {
    try {
      debugPrint("🔥 Triggering Backend Warmup...");
      await STTService.warmup();
      debugPrint("✅ Backend Warmup Complete");
    } catch (e) {
      debugPrint("❌ Warmup Failed (ignoring): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 4),
              Text(
                'Memorize and recite\nQuran easily',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/Start.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              // Optional loading indicator
              const SizedBox(
                width: 24, 
                height: 24, 
                child: CircularProgressIndicator(strokeWidth: 2)
              ),
              const SizedBox(height: 16),
              Text('Saamay',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: primary)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decides if user is logged in or not
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session;
  late final Stream<AuthState> _sub;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _session = auth.currentSession;
    debugPrint("Initial Session: ${_session?.user.email}");
    _sub = auth.onAuthStateChange;
    _sub.listen((event) {
      debugPrint("Auth Event: ${event.event} | Session: ${event.session?.user.email}");
      
      if (event.event == AuthChangeEvent.passwordRecovery) {
        debugPrint("Navigate to UpdatePasswordPage");
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const UpdatePasswordPage()),
        );
      }
      setState(() => _session = event.session);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Unauthenticated → AuthPage; Authenticated → Home
    // Splash screen is handled before this widget.
    if (_session == null) {
      return const AuthPage();
    }
    return const HomePage();
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _startWarmupSequence();
  }

  Future<void> _startWarmupSequence() async {
    // Wait for at least 2 seconds (for branding/animation) 
    // AND for the backend warmup to complete.
    // This ensures the model is hot when the user reaches the main app.
    final minWait = Future.delayed(const Duration(seconds: 2));
    final backendWarmup = _triggerWarmup();

    await Future.wait([minWait, backendWarmup]);

    if (mounted) {
      if (Supabase.instance.client.auth.currentSession != null) {
          // If already logged in, go strictly to Home
          // We can't use 'pushReplacement' on '_AuthGate' directly easily from here 
          // because WelcomeScreen is returned BY AuthGate.
          // Actually, AuthGate logic below handles the routing. 
          // We just need to signal we are done.
          // But wait, WelcomeScreen is ONLY shown if _session == null.
          // So we always go to AuthPage.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthPage()),
          );
      } else {
         Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthPage()),
          );
      }
    }
  }

  Future<void> _triggerWarmup() async {
    try {
      debugPrint("🔥 Triggering Backend Warmup...");
      await STTService.warmup();
      debugPrint("✅ Backend Warmup Complete");
    } catch (e) {
      debugPrint("❌ Warmup Failed (ignoring): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 4),
              Text(
                'Memorize and recite\nQuran easily',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // const SizedBox(height: 24),
              // const Text(
              //   "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black87,
              //     fontFamily: 'Arial', // you can change font family
              //   ),
              // ),

              // Illustration from the provided source URL
              // const SizedBox(height: 24),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    // Source URL as requested
                    'assets/Start.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // const Spacer(),
              // SizedBox(
              //   width: double.infinity,
              //   child: FilledButton(
              //     onPressed: () => Navigator.of(context).push(
              //       MaterialPageRoute(builder: (_) => const AuthPage()),
              //     ),
              //     child: const Text('Get Started'),
              //   ),
              // ),
              // const SizedBox(height: 8),
              const Spacer(),
              Text('Saamay',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: primary)),
            ],
          ),
        ),
      ),
    );
  }
}
