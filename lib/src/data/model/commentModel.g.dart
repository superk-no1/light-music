// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      json['id'] as String? ?? '',
      json['name'] as String? ?? 'Anonymous',
      json['txt'] as String? ?? '',
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'txt': instance.txt,
    };
