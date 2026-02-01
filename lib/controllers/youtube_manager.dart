import 'package:flutter/material.dart';
import 'package:limited_tube/models/video_item.dart';

/// Simple State Management to hold playlist links and mock data
class YoutubeManager extends ChangeNotifier {
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
