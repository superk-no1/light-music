import 'package:json_annotation/json_annotation.dart';

part 'commentModel.g.dart';

@JsonSerializable()
class CommentModel {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: 'Anonymous')
  String name;
  @JsonKey(defaultValue: '')
  String txt;

  CommentModel(this.id, this.name, this.txt);

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
