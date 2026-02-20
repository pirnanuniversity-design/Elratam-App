import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as fb_core;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as fb_firestore;
import 'package:permission_handler/permission_handler.dart';

// Import split widget files:
import 'firebase_options.dart';
import 'hometab.dart';
import 'ministriestab.dart' as ministries_tab;
import 'events_tab.dart' as events_tab;
import 'mediatab.dart';
import 'messages_list_tab.dart' as messages_tab;
import 'abouttab.dart';
import 'settings_full_page.dart';
import 'chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await _requestPermissions();
  await fb_core.Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ElratamApp());
}

Future<void> _requestPermissions() async {
  await Permission.storage.request();
}

// --- CONSTANTS ---
const String kAppName = 'Elratam';
const String kLogoAssetPath = 'assets/logo.png';
const String kAppIconAssetPath = 'assets/app_icon.png';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class ElratamApp extends StatefulWidget {
  const ElratamApp({super.key});

  @override
  State<ElratamApp> createState() => _ElratamAppState();
}

class _ElratamAppState extends State<ElratamApp> {
  Color _accentColor = Colors.green;
  ThemeMode _themeMode = ThemeMode.light;
  String _fontFamily = 'OpenSans';
  double _messageFontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await fb_firestore.FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _accentColor = Color((data['accentColor'] ?? Colors.green.value) as int);
          final themeIndex = data['themeMode'];
          if (themeIndex is int && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
            _themeMode = ThemeMode.values[themeIndex];
          }
          _fontFamily = (data['fontFamily'] as String?) ?? _fontFamily;
          final mf = data['messageFontSize'];
          if (mf is num) _messageFontSize = mf.toDouble();
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await fb_firestore.FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'accentColor': _accentColor.value,
        'themeMode': _themeMode.index,
        'fontFamily': _fontFamily,
        'messageFontSize': _messageFontSize,
      }, fb_firestore.SetOptions(merge: true));
    }
  }

  void _updateAccentColor(Color color) {
    setState(() => _accentColor = color);
    _saveUserData();
  }

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _saveUserData();
  }

  void _updateFontFamily(String family) {
    setState(() => _fontFamily = family);
    _saveUserData();
  }

  void _updateMessageFontSize(double size) {
    setState(() => _messageFontSize = size);
    _saveUserData();
  }

  TextTheme _buildTextTheme(TextTheme base, String family, double size) {
    return base.copyWith(
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: family, fontSize: size),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: family, fontSize: size - 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseLightTheme = ThemeData.light();
    final baseDarkTheme = ThemeData.dark();

    final ThemeData lightTheme = baseLightTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.light),
      textTheme: _buildTextTheme(baseLightTheme.textTheme, _fontFamily, _messageFontSize),
    );

    final ThemeData darkTheme = baseDarkTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark),
      textTheme: _buildTextTheme(baseDarkTheme.textTheme, _fontFamily, _messageFontSize),
    );

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: AuthGate(
        accentColor: _accentColor,
        themeMode: _themeMode,
        fontFamily: _fontFamily,
        messageFontSize: _messageFontSize,
        onAccentColorChanged: _updateAccentColor,
        onThemeModeChanged: _updateThemeMode,
        onFontFamilyChanged: _updateFontFamily,
        onMessageFontSizeChanged: _updateMessageFontSize,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  final Color accentColor;
  final ThemeMode themeMode;
  final String fontFamily;
  final double messageFontSize;
  final void Function(Color) onAccentColorChanged;
  final void Function(ThemeMode) onThemeModeChanged;
  final void Function(String) onFontFamilyChanged;
  final void Function(double) onMessageFontSizeChanged;

  const AuthGate({
    super.key,
    required this.accentColor,
    required this.themeMode,
    required this.fontFamily,
    required this.messageFontSize,
    required this.onAccentColorChanged,
    required this.onThemeModeChanged,
    required this.onFontFamilyChanged,
    required this.onMessageFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb_auth.User?>(
      stream: fb_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(
            accentColor: accentColor,
            themeMode: themeMode,
            fontFamily: fontFamily,
            messageFontSize: messageFontSize,
            onAccentColorChanged: onAccentColorChanged,
            onThemeModeChanged: onThemeModeChanged,
            onFontFamilyChanged: onFontFamilyChanged,
            onMessageFontSizeChanged: onMessageFontSizeChanged,
          );
        }
        return const SignInPage();
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final userCredential = await fb_auth.FirebaseAuth.instance.signInAnonymously();
      if (userCredential.user != null) {
        await fb_firestore.FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'isAdmin': false,
          'createdAt': fb_firestore.FieldValue.serverTimestamp(),
        }, fb_firestore.SetOptions(merge: true));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest sign in failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kAppIconAssetPath, width: 100, height: 100),
            const SizedBox(height: 24),
            Text('Welcome to Elratam', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_outline),
              label: const Text('Continue as Guest'),
              onPressed: () => _signInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Color accentColor;
  final ThemeMode themeMode;
  final String fontFamily;
  final double messageFontSize;
  final void Function(Color) onAccentColorChanged;
  final void Function(ThemeMode) onThemeModeChanged;
  final void Function(String) onFontFamilyChanged;
  final void Function(double) onMessageFontSizeChanged;

  const HomePage({
    super.key,
    required this.accentColor,
    required this.themeMode,
    required this.fontFamily,
    required this.messageFontSize,
    required this.onAccentColorChanged,
    required this.onThemeModeChanged,
    required this.onFontFamilyChanged,
    required this.onMessageFontSizeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int? _eventsTabIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _eventsTabIndex = null; // Reset when changing main tabs
    });
  }

  void _navigateToEventsTab(int mainTabIndex, int eventsTabIndex) {
    setState(() {
      _selectedIndex = mainTabIndex;
      _eventsTabIndex = eventsTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(onNavigateToEventsTab: _navigateToEventsTab),
      ministries_tab.MinistriesTab(),
      events_tab.EventsTab(initialTabIndex: _eventsTabIndex),
      const MediaTab(),
      const messages_tab.MessagesListTab(),
      const AboutTab(),
    ];

    final pageTitles = [
      kAppName,
      'Ministries',
      'Events',
      'Media',
      'Messages',
      'About',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[_selectedIndex]),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: widget.accentColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogoAssetPath, height: 60),
                  const SizedBox(height: 8),
                  Text(kAppName, style: const TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: () => _onItemTapped(0)),
            ListTile(leading: const Icon(Icons.groups), title: const Text('Ministries'), onTap: () => _onItemTapped(1)),
            ListTile(leading: const Icon(Icons.event), title: const Text('Events'), onTap: () => _onItemTapped(2)),
            ListTile(leading: const Icon(Icons.play_circle_fill), title: const Text('Media'), onTap: () => _onItemTapped(3)),
            ListTile(leading: const Icon(Icons.message), title: const Text('Messages'), onTap: () => _onItemTapped(4)),
            ListTile(leading: const Icon(Icons.info), title: const Text('About'), onTap: () => _onItemTapped(5)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsFullPage(
                    accentColor: widget.accentColor,
                    themeMode: widget.themeMode,
                    onAccentColorChanged: widget.onAccentColorChanged,
                    onThemeModeChanged: widget.onThemeModeChanged,
                    onFontFamilyChanged: widget.onFontFamilyChanged,
                    onMessageFontSizeChanged: widget.onMessageFontSizeChanged,
                    fontFamily: widget.fontFamily,
                    messageFontSize: widget.messageFontSize,
                  ),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.of(context).pop();
                fb_auth.FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Ministries'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Media'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
