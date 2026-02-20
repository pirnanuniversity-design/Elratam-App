import 'package:flutter/material.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_EventGalleryTab> eventTabs = [
      _EventGalleryTab('Graduation', [
        'assets/images/20250726_145553.jpg',
        'assets/images/20250726_145447.jpg',
        'assets/images/20250726_145135.jpg',
        'assets/images/20250726_145036.jpg',
        'assets/images/20250726_144741.jpg',
        'assets/images/20250726_144739.jpg',
        'assets/images/20250726_144658.jpg',
        'assets/images/20250726_144555.jpg',
        'assets/images/20250726_143920.jpg',
        'assets/images/20250726_143909.jpg',
        'assets/images/20250726_143900.jpg',
        'assets/images/20250726_143838.jpg',
        'assets/images/20250726_135752.jpg',
      ], 'Graduation Ceremony for Elratam Institute. Congratulations to all graduates!'),
      _EventGalleryTab('Nations in Worship', [
        // Add images for Nations in Worship
      ], 'Nations in Worship event highlights.'),
      _EventGalleryTab('We Wait', [
        // Add images for We Wait
      ], 'We Wait event highlights.'),
      _EventGalleryTab('Matriculation', [
        // Add images for Matriculation
      ], 'Matriculation event highlights.'),
      _EventGalleryTab('Easter Camp', [
        // Add images for Easter Camp
      ], 'Easter Camp event highlights.'),
    ];

    return DefaultTabController(
      length: eventTabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: eventTabs.map((e) => Tab(text: e.title)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: eventTabs.map((e) => _EventInfoTab(tab: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventGalleryTab {
  final String title;
  final List<String> images;
  final String details;
  _EventGalleryTab(this.title, this.images, this.details);
}

class _EventInfoTab extends StatelessWidget {
  final _EventGalleryTab tab;
  const _EventInfoTab({required this.tab});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              tab.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(tab.details, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(height: 16),
          if (tab.images.isNotEmpty)
            SizedBox(
              height: 400,
              child: _GalleryGrid(images: tab.images),
            ),
        ],
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  final List<String> images;
  const _GalleryGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final imgPath = images[index];
        return GestureDetector(
          onTap: () => _openImageGallery(context, images, index, accentColor),
          child: Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imgPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openImageGallery(BuildContext context, List<String> images, int initialIndex, Color accentColor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: StatefulBuilder(
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
                      return InteractiveViewer(
                        child: Center(
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          ),
        );
      },
    );
  }
}