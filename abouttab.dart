import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String kAppName = 'ELRATAM';
const String kAppSlogan = 'Transforming Lives, Advancing The Kingdom';
const String kContactEmail = 'elratamministry@gmail.com';
const String kContactPhone = '+234 903 122 9132';
const String kWebsiteUrl = 'https://preview--art-theology-connect-99.lovable.app/';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  Widget _buildContactItem(BuildContext context, IconData icon, String title, String value, {bool isLink = false, String? url, bool showActual = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                showActual
                  ? Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4))
                  : isLink
                    ? InkWell(
                        onTap: () async {
                          final Uri uri = Uri.parse(url ?? value);
                          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not open $value')),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Click here',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue.shade700,
                                fontSize: 13,
                              ),
                        ),
                      )
                    : Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'About $kAppName Ministry',
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'ELRATAM Ministry is dedicated to using arts, media, and discipleship to advance the Kingdom of God. We train, mentor, and empower believers through education, worship, drama, music, and leadership development. Our vision is to transform lives and communities by spreading the gospel creatively and passionately.',
            style: textTheme.bodyLarge?.copyWith(height: 1.5, letterSpacing: 0.1),
          ),
          const Divider(height: 40, thickness: 1),
          Text(
            'Contact Us:',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildContactItem(context, Icons.email_outlined, 'Email Address', kContactEmail, showActual: true),
          _buildContactItem(context, Icons.phone_outlined, 'Phone Number', kContactPhone, showActual: true),
          _buildContactItem(context, Icons.language_outlined, 'Official Website', kWebsiteUrl, isLink: true),
          const SizedBox(height: 20),
          Text('Social Media Links:', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          _buildContactItem(context, Icons.ondemand_video, 'YouTube Channel', 'https://youtube.com/@elratamministry8044?si=yMMA88YIjiXl43tO', isLink: true),
          _buildContactItem(context, Icons.facebook, 'Facebook Page', 'https://www.facebook.com/people/Elratam-Institute-of-Arts-and-Theology/61566480165758/', isLink: true),
          _buildContactItem(context, Icons.camera_alt, 'Instagram', 'https://www.instagram.com/elratamministry?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==', isLink: true),
          _buildContactItem(context, Icons.alternate_email, 'Twitter (X)', 'https://x.com/ElratamMinistry?s=09', isLink: true),
        ],
      ),
    );
  }
}

