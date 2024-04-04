import 'package:json_annotation/json_annotation.dart';
import 'package:meloplay/src/data/model/networkSongModel.dart';

part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: 'GaoXin')
  String username;
  @JsonKey(defaultValue: '')
  String password;
  List<NetworkSongModel>? favorites;

  UserModel(this.id, this.username, this.password, this.favorites);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
