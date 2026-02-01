import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:limited_tube/controllers/youtube_manager.dart';
import 'package:limited_tube/views/youtube_clone_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => YoutubeManager(),
      child: const YouTubeCloneApp(),
    ),
  );
}
