import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const YouTubeCloneApp(),
    ),
  );
}

/// Simple State Management to hold playlist links and mock data
class AppState extends ChangeNotifier {
  final List<String> _playlistLinks = [];
  List<VideoItem> _feedItems = [];

  List<String> get playlistLinks => _playlistLinks;
  List<VideoItem> get feedItems => _feedItems;

  void addPlaylist(String url) {
    if (url.isNotEmpty && !_playlistLinks.contains(url)) {
      _playlistLinks.add(url);
      _syncFeed();
      notifyListeners();
    }
  }

  void removePlaylist(int index) {
    _playlistLinks.removeAt(index);
    _syncFeed();
    notifyListeners();
  }

  /// In a real app, this would call the YouTube Data API v3
  /// Here we generate mock data based on the presence of playlists
  void _syncFeed() {
    if (_playlistLinks.isEmpty) {
      _feedItems = [];
    } else {
      // Mocking different content types for the UI
      _feedItems = List.generate(_playlistLinks.length * 3, (index) {
        bool isShort = index % 3 == 0;
        return VideoItem(
          id: 'v$index',
          title: isShort
              ? 'Trending Short #$index'
              : 'Amazing Video Content $index',
          author: 'Creator Channel',
          views: '${(index + 1) * 12}K views',
          thumbnail: 'https://picsum.photos/seed/yt$index/600/350',
          isShort: isShort,
        );
      });
    }
  }
}

class VideoItem {
  final String id;
  final String title;
  final String author;
  final String views;
  final String thumbnail;
  final bool isShort;

  VideoItem({
    required this.id,
    required this.title,
    required this.author,
    required this.views,
    required this.thumbnail,
    this.isShort = false,
  });
}

class YouTubeCloneApp extends StatelessWidget {
  const YouTubeCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.white,
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomeScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'You',
          ),
        ],
      ),
    );
  }
}

/// HOME SCREEN: Displays the merged feed of Videos and Shorts
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

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
              context.read<AppState>().addPlaylist(_controller.text);
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
    final state = context.watch<AppState>();

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
