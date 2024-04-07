// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['id'] as String? ?? '',
      json['username'] as String? ?? 'GaoXin',
      json['password'] as String? ?? '',
      (json['favorites'] as List<dynamic>?)
          ?.map((e) => NetworkSongModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'favorites': instance.favorites,
    };
