import 'package:json_annotation/json_annotation.dart';

part 'networkSongModel.g.dart';

@JsonSerializable()
class NetworkSongModel {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String album;
  @JsonKey(defaultValue: 0)
  int albumId;
  @JsonKey(defaultValue: '')
  String artist;
  @JsonKey(defaultValue: 0)
  int duration;
  @JsonKey(defaultValue: '')
  String data;
  @JsonKey(defaultValue: '')
  String uri;
  @JsonKey(defaultValue: 0)
  int likeCount;

  NetworkSongModel(this.id, this.title, this.album, this.albumId, this.artist,
      this.duration, this.data, this.uri, this.likeCount);

  factory NetworkSongModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkSongModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkSongModelToJson(this);
}
