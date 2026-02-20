import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {
  final void Function(int, int) onNavigateToEventsTab;

  const HomeTab({super.key, required this.onNavigateToEventsTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = isDark ? 'assets/app_icon.jpg' : 'assets/logo.png';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(logoAsset, width: 120, height: 120),
                const SizedBox(height: 18),
                const Text(
                  'Transforming Lives, Advancing The Kingdom',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Cursive',
                    color: Colors.red,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => onNavigateToEventsTab(2, 1), // Navigate to Events tab, then to the second tab within Events
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Featured Event: Graduation Ceremony', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Congratulations to all graduates! See photos and highlights in the Events tab.'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to ELRATAM Ministry! We use arts, media, and discipleship to advance the Kingdom of God. Scroll down for links and more info.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language_outlined, color: Colors.blue),
            title: const Text('Official Website'),
            onTap: () async {
              final uri = Uri.parse('https://preview--art-theology-connect-99.lovable.app/');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const Icon(Icons.ondemand_video, color: Colors.red),
            title: const Text('YouTube Channel'),
            onTap: () async {
              final uri = Uri.parse('https://youtube.com/@elratamministry8044?si=yMMA88YIjiXl43tO');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const Icon(Icons.facebook, color: Colors.blue),
            title: const Text('Facebook Page'),
            onTap: () async {
              final uri = Uri.parse('https://www.facebook.com/people/Elratam-Institute-of-Arts-and-Theology/61566480165758/');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.purple),
            title: const Text('Instagram'),
            onTap: () async {
              final uri = Uri.parse('https://www.instagram.com/elratamministry?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email, color: Colors.black),
            title: const Text('Twitter (X)'),
            onTap: () async {
              final uri = Uri.parse('https://x.com/ElratamMinistry?s=09');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
