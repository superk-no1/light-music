// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networkSongModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkSongModel _$NetworkSongModelFromJson(Map<String, dynamic> json) =>
    NetworkSongModel(
      json['id'] as String? ?? '',
      json['title'] as String? ?? '',
      json['album'] as String? ?? '',
      json['albumId'] as int? ?? 0,
      json['artist'] as String? ?? '',
      json['duration'] as int? ?? 0,
      json['data'] as String? ?? '',
      json['uri'] as String? ?? '',
      json['likeCount'] as int? ?? 0,
    );

Map<String, dynamic> _$NetworkSongModelToJson(NetworkSongModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'album': instance.album,
      'albumId': instance.albumId,
      'artist': instance.artist,
      'duration': instance.duration,
      'data': instance.data,
      'uri': instance.uri,
      'likeCount': instance.likeCount,
    };
