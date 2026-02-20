import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EventsTab extends StatefulWidget {
  final int? initialTabIndex;
  const EventsTab({super.key, this.initialTabIndex});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, List<String>> _media = {
    'Easter Camp': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(1).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(10).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(11).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(12).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(13).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(14).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(15).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(2).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(3).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(4).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(5).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(6).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(7).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(8).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20(9).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20Camp%20Reunion.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Easter%20camp.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/easter%20camp%201.jpg',
    ],
    '2024 & 2025 Graduation': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(1).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(2).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(3).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(4).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(5).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(6).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(7).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2024&2025%20graduation%20(8).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Grad%205.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Graduation%202.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/grad%201.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/grad%204.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/graduation.jpg',
    ],
    '2025 & 2026 Matriculation': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(1).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(10).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(11).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(12).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(13).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(14).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(15).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(16).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(17).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(18).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(19).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(2).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(21).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(22).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(23).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(24).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(3).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(4).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(5).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(6).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(7).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(8).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/2025&2026%20matriculation%20(9).jpg',
    ],
    'Institute of Arts & Theology': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(1).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(10).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(11).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(2).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(3).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(4).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(5).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(6).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(7).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(8).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%20(9).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%201.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%202.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT%203.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/EIAT.jpg',
    ],
    'Thursday Fellowship': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(1).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(2).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(3).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(4).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(5).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(6).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(7).jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Thursday%20Fellowship%20(8).jpg',
    ],
    'Arts 4 Hearts': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20Hearts%202.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20Hearts%203.JPG',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20Hearts%204.JPG',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20Hearts%205.JPG',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20Hearts3.jpg',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Arts%204%20hearts%206.JPG',
    ],
    'Videos': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Lakeside%20couple%20trailer.mp4',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Lakkeside%20couple%20trailer%202.mp4',
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/WhatsApp%20Video%202025-12-09%20at%2012.58.37_0d5f74dc.mp4',
    ],
    'More': [
      'https://raw.githubusercontent.com/elratamapp-art/elratam-media/main/Media.JPG',
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _media.keys.length,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _downloadMedia(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final downloadsDirectory = await getDownloadsDirectory();
        if (downloadsDirectory == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not find downloads directory')));
          return;
        }

        final fileName = Uri.decodeComponent(url.split('/').last);
        final savePath = '${downloadsDirectory.path}/$fileName';

        await Dio().download(url, savePath);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded $fileName')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Events'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _media.keys.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _media.keys.map((title) {
          final urls = _media[title]!;
          return ListView.builder(
            itemCount: urls.length,
            itemBuilder: (context, index) {
              final url = urls[index];
              final isVideo = url.endsWith('.mp4');
              final fileName = Uri.decodeComponent(url.split('/').last);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (!isVideo)
                      Image.network(url, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50)),
                    if (isVideo)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text(fileName),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => _downloadMedia(url),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
