import 'package:flutter/material.dart';

enum ResourceType {
  article,
  video,
  document,
  website,
  podcast,
  other
}

class Resource {
  final String id;
  final String title;
  final String description;
  final String url;
  final ResourceType type;
  final DateTime dateAdded;
  final String? imageUrl;
  
  const Resource({
    required this.id,
    required this.title, 
    required this.description,
    required this.url,
    required this.type,
    required this.dateAdded,
    this.imageUrl,
  });
  
  IconData get typeIcon {
    switch (type) {
      case ResourceType.article:
        return Icons.article;
      case ResourceType.video:
        return Icons.video_library;
      case ResourceType.document:
        return Icons.insert_drive_file;
      case ResourceType.website:
        return Icons.language;
      case ResourceType.podcast:
        return Icons.headset;
      case ResourceType.other:
        return Icons.more_horiz;
    }
  }
  
  String get typeLabel {
    return type.toString().split('.').last;
  }
}