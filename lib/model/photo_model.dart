// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class PhotoModel {
  String id;
  String imageUrl;
  int views;
  int likes;
  List<String> tags;
  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.views,
    required this.likes,
    required this.tags,
  });

  PhotoModel copyWith({
    String? id,
    String? imageUrl,
    int? views,
    int? likes,
    List<String>? tags,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'views': views,
      'likes': likes,
      'tags': tags,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
        id: map['id'] as String,
        imageUrl: map['imageUrl'] as String,
        views: map['views'] as int,
        likes: map['likes'] as int,
        tags: List<String>.from(
          (map['tags'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory PhotoModel.fromJson(String source) =>
      PhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhotoModel(id: $id, imageUrl: $imageUrl, views: $views, likes: $likes, tags: $tags)';
  }

  @override
  bool operator ==(covariant PhotoModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.imageUrl == imageUrl &&
        other.views == views &&
        other.likes == likes &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        views.hashCode ^
        likes.hashCode ^
        tags.hashCode;
  }
}
