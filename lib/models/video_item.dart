// Items to populated from Playlist entries
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
