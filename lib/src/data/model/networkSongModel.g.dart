// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networkSongModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkSongModel _$NetworkSongModelFromJson(Map<String, dynamic> json) =>
    NetworkSongModel(
      json['id'] as String? ?? '',
      json['title'] as String? ?? '',
      json['artist'] as String? ?? '',
      json['sourceUrl'] as String? ?? '',
      json['likeCount'] as int? ?? 0,
    );

Map<String, dynamic> _$NetworkSongModelToJson(NetworkSongModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'sourceUrl': instance.sourceUrl,
      'likeCount': instance.likeCount,
    };
