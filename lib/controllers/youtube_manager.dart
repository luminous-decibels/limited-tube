import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_explode_dart/src/videos/video.dart';

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
  Future<void> _syncFeed() async {
    if (_playlistLinks.isEmpty) {
      _feedItems = [];
    } else {
      final sampleURL = 'PLQxbZDjEGGkmGROBWOtG_K-2sc6wAZfVi'; //DCE's let's code
      final _videos = await _get_playlist_feed(sampleURL);
      print('COUNT: ${_videos.length}');
      _feedItems = List.generate(_videos.length, (idx) {
        bool isShort = false;
        return VideoItem(
          id: '${_videos[idx].id}',
          title: '${_videos[idx].title}',
          author: '${_videos[idx].author}',
          views: '${(idx + 1) * 12}K views',
          thumbnail: '${_videos[idx].thumbnails.standardResUrl}',
          //'https://picsum.photos/seed/yt$idx/600/350',
          isShort: isShort,
        );
      });

      // Mocking different content types for the UI
      _feedItems += List.generate(_playlistLinks.length * 3, (index) {
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

  Future<List<Video>> _get_playlist_feed(url) async {
    var yt = YoutubeExplode();
    var pls = await yt.playlists.get(url);
    print("[+] ${pls.title} by ${pls.author}");
    print("\t${pls.description}\n\t${pls.videoCount} videos");

    return yt.playlists.getVideos(pls.id).toList();
  }
}
