import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaItem {
  final String title;
  final String url;

  const MediaItem({
    required this.title,
    required this.url,
  });
}

class MediaTab extends StatefulWidget {
  const MediaTab({super.key});

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  List<FileSystemEntity> _downloadedFiles = [];

  static final Map<String, List<MediaItem>> categorizedMedia = {
    'Elratam Jingles': [
      const MediaItem(title: '2025/2026 ADMISSIONS - ELRATAM INSTITUTE OF Arts & Theology', url: 'https://www.youtube.com/watch?v=9GIy-cx_hP4'),
      const MediaItem(title: 'Elratam Institute of Arts & Theology - 2024/2025 ADMISSIONS', url: 'https://www.youtube.com/watch?v=R86b-4S77uI'),
      const MediaItem(title: 'Elratam Institute of Arts & Theology - Media & Comm., Theatre and Film, Visual Arts, Theology ', url: 'https://www.youtube.com/watch?v=rqp7cwFt_PE&pp=0gcJCccJAYcqIYzv'),
      const MediaItem(title: 'Elratam Institute of Arts & Theology Jingle', url: 'https://www.youtube.com/watch?v=Dtn7m08zb_c'),
      const MediaItem(title: 'Breaking News (EIAT Debut Video)', url: 'https://www.youtube.com/watch?v=yBtqW28Bt0A'),
    ],
    'Elratam Movies and Trailers': [
      const MediaItem(title: 'BOX CARRIER | Elratam Short Film', url: 'https://www.youtube.com/watch?v=vSETskbGnX0'),
      const MediaItem(title: 'A lady in my room | Elratam Short Film', url: 'https://www.youtube.com/watch?v=YqtarE2XyxA'),
      const MediaItem(title: 'The Narrow Way – Official Movie', url: 'https://www.youtube.com/watch?v=EPVuK4HF2Ew'),
      const MediaItem(title: 'The Call | Elratam Short Film', url: 'https://www.youtube.com/watch?v=fCjgcINwTrQ'),
      const MediaItem(title: 'Seaside Encounter | Elratam Short Film', url: 'https://www.youtube.com/watch?v=seaside'),
      const MediaItem(title: 'Reckoning | Elratam Short Film', url: 'https://www.youtube.com/watch?v=gG19lJ1NIfU&pp=0gcJCccJAYcqIYzv'),
      const MediaItem(title: 'Echoes of Grace | Elratam Short Film', url: 'https://www.youtube.com/watch?v=xNSuEYnMPa8'),
      const MediaItem(title: 'The Test | Elratam Short Film', url: 'https://www.youtube.com/watch?v=pvZDFCRA95o'),
      const MediaItem(title: 'Narrow Way – Official Trailer', url: 'https://www.youtube.com/watch?v=Yn_OJzS9Zdk'),
      const MediaItem(title: 'Grace Unfolded – Official Trailer 2', url: 'https://www.youtube.com/watch?v=_FcW4GWHD48'),
    ],
    'Worship Sessions': [
      const MediaItem(title: 'Spirit Flow | Worship Session', url: 'https://www.youtube.com/watch?v=zI3IKZZoxXA'),
      const MediaItem(title: 'Night of Fire | Elratam Worship', url: 'https://www.youtube.com/watch?v=q-hULeqJqBc'),
      const MediaItem(title: 'Broken Before You | Worship Clip', url: 'https://www.youtube.com/watch?v=S6BcfZ-JKbU&pp=0gcJCccJAYcqIYzv'),
      const MediaItem(title: 'Overflowing Cup | Live Worship', url: 'https://www.youtube.com/watch?v=1BeN4ZM5gPc'),
      const MediaItem(title: 'Draw Me Nearer | Worship Moment', url: 'https://www.youtube.com/watch?v=QYmuaAUhXYM'),
      const MediaItem(title: 'I Will Sing | Praise Session', url: 'https://www.youtube.com/watch?v=yqfOQt2weHs'),
      const MediaItem(title: 'I Surrender All | Worship Clip', url: 'https://www.youtube.com/watch?v=PDBeeS4r9LM'),
    ],
    'Animations & Logo': [
      const MediaItem(title: 'Elratam Animated Logo', url: 'https://www.youtube.com/watch?v=1BdB2xKJRLs'),
      const MediaItem(title: 'Ministry Logo Reveal (2024)', url: 'https://www.youtube.com/watch?v=yg8Wn0ojRDA'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadDownloadedFiles();
  }

  Future<void> _loadDownloadedFiles() async {
    try {
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        final items = directory.listSync();
        setState(() {
          _downloadedFiles = items;
        });
      }
    } catch (e) {
      // Handle errors, e.g., if the directory doesn't exist
    }
  }

  Future<void> _attemptLaunchUrl(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabTitles = categorizedMedia.keys.toList() + ['Downloads'];

    return DefaultTabController(
      length: tabTitles.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: tabTitles.map((title) => Tab(text: title)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ...categorizedMedia.values.map((mediaList) {
                  return ListView.builder(
                    itemCount: mediaList.length,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (context, index) {
                      final item = mediaList[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.play_circle_outline),
                          title: InkWell(
                            onTap: () => _attemptLaunchUrl(context, item.url),
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                _buildDownloadsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadsTab() {
    return RefreshIndicator(
      onRefresh: _loadDownloadedFiles,
      child: _downloadedFiles.isEmpty
          ? const Center(child: Text('No downloaded files yet. Pull to refresh.'))
          : ListView.builder(
              itemCount: _downloadedFiles.length,
              itemBuilder: (context, index) {
                final file = _downloadedFiles[index];
                final fileName = file.path.split('/').last;
                final isVideo = fileName.endsWith('.mp4');

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: isVideo ? const Icon(Icons.videocam) : const Icon(Icons.image),
                    title: Text(fileName),
                  ),
                );
              },
            ),
    );
  }
}
