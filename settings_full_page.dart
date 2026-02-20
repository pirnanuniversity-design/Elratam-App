import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
// Make sure to add app_settings to your pubspec.yaml dependencies:
// dependencies:
//   app_settings: ^5.0.0

class SettingsFullPage extends StatefulWidget {
  final Color accentColor;
  final ThemeMode themeMode;
  final void Function(Color)? onAccentColorChanged;
  final void Function(ThemeMode)? onThemeModeChanged;

  const SettingsFullPage({
    super.key,
    required this.accentColor,
    required this.themeMode,
    this.onAccentColorChanged,
    this.onThemeModeChanged, void Function(double)? onMessageFontSizeChanged, required double messageFontSize, required String fontFamily, void Function(String)? onFontFamilyChanged,
  });

  @override
  State<SettingsFullPage> createState() => _SettingsFullPageState();
}

class _SettingsFullPageState extends State<SettingsFullPage> {
  static const List<Color> accentChoices = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.pink,
    Colors.deepPurple,
  ];

  late Color _accentColor;
  late ThemeMode _themeMode;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _accentColor = widget.accentColor;
    _themeMode = widget.themeMode;
  }

  void _handleAccentColorChange(Color color) {
    setState(() {
      _accentColor = color;
    });
    if (widget.onAccentColorChanged != null) {
      widget.onAccentColorChanged!(color);
    }
  }

  void _handleThemeModeChange(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    if (widget.onThemeModeChanged != null) {
      widget.onThemeModeChanged!(mode);
    }
  }

  void _handleNotificationsToggle(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Open app settings (notification settings are not directly accessible on all platforms)
    AppSettings.openAppSettings();
  }

  void _openPrivacyPolicy() async {
    final uri = Uri.parse('https://your-privacy-policy-link.com');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Privacy Policy')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: _accentColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Themes'),
              Tab(text: 'About'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Themes Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accent Color:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: accentChoices.map((color) => GestureDetector(
                        onTap: () => _handleAccentColorChange(color),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _accentColor == color ? Colors.black : Colors.grey.shade300,
                              width: _accentColor == color ? 2.0 : 1.0,
                            ),
                          ),
                          child: _accentColor == color
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
                              : null,
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text('Theme:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Light'),
                          selected: _themeMode == ThemeMode.light,
                          onSelected: (selected) {
                            if (selected) _handleThemeModeChange(ThemeMode.light);
                          },
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('Dark'),
                          selected: _themeMode == ThemeMode.dark,
                          onSelected: (selected) {
                            if (selected) _handleThemeModeChange(ThemeMode.dark);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Enable Notifications', style: Theme.of(context).textTheme.bodyLarge),
                      value: _notificationsEnabled,
                      onChanged: _handleNotificationsToggle,
                      secondary: Icon(Icons.notifications_active, color: _accentColor),
                    ),
                  ],
                ),
              ),
            ),
            // About Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', width: 48, height: 48),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ELRATAM',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: _accentColor,
                              ),
                            ),
                            const Text(
                              'Transforming Lives, Advancing The Kingdom',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                                fontFamily: 'Cursive',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: _accentColor),
                        const SizedBox(width: 10),
                        Text('App Version: ', style: Theme.of(context).textTheme.bodyLarge),
                        const Text('1.0.0'),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Privacy Policy'),
                      onTap: _openPrivacyPolicy,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}