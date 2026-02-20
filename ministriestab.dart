import 'package:flutter/material.dart';

class MinistriesTab extends StatelessWidget {
  const MinistriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    final List<_MinistrySection> sections = [
      const _MinistrySection(
        title: 'Education',
        details: 'Elratam Ministry provides educational programs in theology, arts, and leadership development. Our curriculum is designed to empower believers for creative ministry and effective discipleship.\n\nCourses Offered:\n- Theology\n- Christian Leadership\n- Creative Arts\n- Worship Leading\n- Drama & Performance\n\nOur education is hands-on, with mentorship and practical ministry opportunities.',
      ),
      const _MinistrySection(
        title: 'Elratam Institute',
        details: 'The Institute offers specialized training in drama, music, worship, and theology. Students are mentored by experienced leaders and participate in ministry projects and outreach.\n\nInstitute Highlights:\n- Certificate & Diploma Programs\n- Guest Lecturers\n- Annual Graduation Ceremony\n- Student Ministry Teams',
      ),
      const _MinistrySection(
        title: 'Worship Team',
        details: 'The Worship Team leads praise and worship at events and services. Musicians and singers are welcome to join and serve in various ministry opportunities.\n\nActivities:\n- Weekly Rehearsals\n- Worship Nights\n- Music Production\n- Outreach Events',
      ),
      const _MinistrySection(
        title: 'Theater',
        details: 'Our drama team performs gospel plays and skits to communicate biblical truths in creative ways. Actors, directors, and scriptwriters are invited to participate.\n\nRecent Productions:\n- The Narrow Way\n- Sacrifice\n- Crossroads\n- Echoes of Grace',
      ),
      const _MinistrySection(
        title: 'Films',
        details: 'Elratam Films produces short films, documentaries, and video content for outreach and discipleship. Our team includes directors, editors, and actors.\n\nWatch our films on YouTube and social media.',
      ),
      const _MinistrySection(
        title: 'Movies & Music',
        details: 'Our ministry produces gospel movies, music albums, and creative media to spread the message of Christ. Join our team or enjoy our productions online.\n\nFeatured Albums & Movies:\n- Devotional Intro Jingle\n- Worship Session: Spirit Flow\n- Official Trailer: Narrow Way',
      ),
      const _MinistrySection(
        title: 'Partnerships',
        details: 'We collaborate with churches, ministries, and organizations to advance the Kingdom of God. Contact us to partner with Elratam Ministry.\n\nCurrent Partners:\n- Local Churches\n- Christian NGOs\n- Worship Networks',
      ),
      const _MinistrySection(
        title: 'Memberships',
        details: 'Become a member of Elratam Ministry and join a community of passionate believers. Membership is open to all who desire to serve and grow.\n\nBenefits:\n- Training & Mentorship\n- Ministry Opportunities\n- Community Support',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          elevation: 2,
          child: ListTile(
            title: Text(
              section.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MinistryDetailPage(
                    section: section,
                    accentColor: accentColor, // Pass accent color here
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MinistryDetailPage extends StatelessWidget {
  // ignore: library_private_types_in_public_api
  final _MinistrySection section;
  final Color accentColor;
  // ignore: library_private_types_in_public_api
  const MinistryDetailPage({super.key, required this.section, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
        backgroundColor: accentColor, // Use accent color for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            section.details,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ),
      ),
    );
  }
}

class _MinistrySection {
  final String title;
  final String details;
  const _MinistrySection({required this.title, required this.details});
}

// Define the Ministries class to fix the error.
class Ministries {
  final String title;
  final String summary;
  final String details;

  const Ministries({
    required this.title,
    required this.summary,
    required this.details,
  });
}

// If you have any custom widgets named Text, Padding, or SizedBox, rename them to avoid conflicts.
// For example, rename your custom Text class to MinistryText, etc.

class MinistriesDetailPage extends StatelessWidget {
  final Ministries ministries;

  const MinistriesDetailPage({super.key, required this.ministries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ministries.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ministries.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ministries.summary,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 30, thickness: 1),
            Text(
              ministries.details,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
// Add this widget to wrap the image viewer logic and provide required variables.
class MinistryImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const MinistryImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        int currentIndex = initialIndex;
        final pageController = PageController(initialPage: initialIndex);
        return Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => currentIndex = i),
              itemBuilder: (context, index) {
                return Center(
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${images.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }
}
