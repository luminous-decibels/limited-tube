import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:limited_tube/controllers/youtube_manager.dart';
import 'package:limited_tube/models/video_item.dart';

/// HOME SCREEN: Displays the merged feed of Videos and Shorts
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<YoutubeManager>();

    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg',
          height: 20,
          errorBuilder: (context, error, stackTrace) => const Text('YouTube'),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: state.feedItems.isEmpty
          ? const Center(
              child: Text(
                'Add YouTube Playlists in Profile to see content',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: state.feedItems.length,
              itemBuilder: (context, index) {
                final item = state.feedItems[index];
                if (item.isShort) {
                  return _buildShortsSection(item);
                }
                return _buildVideoCard(item);
              },
            ),
    );
  }

  Widget _buildVideoCard(VideoItem item) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              item.thumbnail,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: Colors.black87,
                child: const Text('10:04', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(backgroundColor: Colors.grey, radius: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${item.author} • ${item.views} • 2 days ago',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortsSection(VideoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.bolt, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Shorts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/seed/short$index/300/500',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        'Short video title example $index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
