import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:limited_tube/controllers/youtube_manager.dart';

/// PROFILE SCREEN: Where users add YouTube Playlist Links
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Playlist ID'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'e.g. PLirX0Y39Y_pSpE8f5n-jM3iQ9A9v8b-9j',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<YoutubeManager>().addPlaylist(_controller.text);
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<YoutubeManager>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            const Text(
              'Dev User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              '@dev_user • View channel',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Playlist Management Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Managed Playlists',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Add New'),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  if (state.playlistLinks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No playlists added yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.playlistLinks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.playlist_play,
                            color: Colors.red,
                          ),
                          title: Text(
                            state.playlistLinks[index],
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: const Text('YouTube Public Playlist'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            onPressed: () => state.removePlaylist(index),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
