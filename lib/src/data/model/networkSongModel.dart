import 'package:json_annotation/json_annotation.dart';

part 'networkSongModel.g.dart';

@JsonSerializable()
class NetworkSongModel {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String artist;
  @JsonKey(defaultValue: '')
  String sourceUrl;
  @JsonKey(defaultValue: 0)
  int likeCount;

  NetworkSongModel(
      this.id, this.title, this.artist, this.sourceUrl, this.likeCount);

  factory NetworkSongModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkSongModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkSongModelToJson(this);
}
