import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String kUniversityWebsiteUrl = 'https://preview--art-theology-connect-99.lovable.app/';

class UniversityTab extends StatelessWidget {
  const UniversityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {
        'name': 'Pastor Gideon Yahaya',
        'role': 'Head School of Theology',
        'phone': '+234 816 832 5906',
      },
      {
        'name': 'Mr Dan Ali',
        'role': 'Head School of Music',
        'phone': '+234 803 681 3272',
      },
      {
        'name': 'Dr Mrs Comfort Bulus',
        'role': 'Head, School of Media & Communication',
        'phone': '+234 803 587 3318',
      },
      {
        'name': 'Mr. Gershon Briska',
        'role': 'Head Theatre & Film. School',
        'phone': '+234 816 949 4741',
      },
      {
        'name': 'Mr. Ajibade',
        'role': 'Head, School of Visual Arts',
        'phone': '+234 805 868 6132',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ELRATAM University',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'ELRATAM University is a multidisciplinary institution dedicated to the advancement of arts, theology, media, music, and more. '
            'We offer a wide range of programs and are committed to transforming lives and advancing the Kingdom through education and creativity.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Key Contacts:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ...contacts.map((c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(c['name']!),
                    subtitle: Text('${c['role']}\n${c['phone']}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () async {
                        final uri = Uri.parse('tel:${c['phone']}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          Text(
            'More Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Visit our website for detailed information about our schools, programs, admissions, and more.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Go to ELRATAM University Website'),
            onPressed: () async {
              final uri = Uri.parse(kUniversityWebsiteUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Go to ELRATAM About Page'),
            onPressed: () async {
              const url = 'https://preview--art-theology-connect-99.lovable.app/about';
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Schools & Programs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '''
- School of Theology: Biblical studies, ministry, and leadership.
- School of Music: Worship, performance, and music production.
- School of Media & Communication: Journalism, film, and digital media.
- Theatre & Film School: Acting, directing, and production.
- School of Visual Arts: Fine arts, design, and creative expression.

We are committed to excellence in education, spiritual growth, and creative development.
            ''',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
