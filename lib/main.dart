// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme_provider.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';

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
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  Session? _session;
  late final Stream<AuthState> _sub;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _session = auth.currentSession;
    _sub = auth.onAuthStateChange;
    _sub.listen((event) {
      setState(() => _session = event.session);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Unauthenticated → Welcome + AuthTabs; Authenticated → Home
    if (_session == null) {
      return const WelcomeScreen();
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

    // Wait 5 seconds, then go to AuthPage
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      }
    });
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
