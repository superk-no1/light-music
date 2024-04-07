import 'dart:core';

import 'package:dio/dio.dart';
import 'package:meloplay/src/data/model/userModel.dart';
import 'package:meloplay/src/presentation/utils/global.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../data/model/commentModel.dart';

final apiManager = ApiManager();

class ApiManager {
  static Dio dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.71.106:3000/api',
      headers: {'token': Global.token}));

  Future<UserModel> userRegister(String username, String password) async {
    var resultData = await dio.post("/user/register",
        data: {'username': username, 'password': password});
    if (resultData.statusCode == 200) {
      return UserModel.fromJson(resultData.data);
    }
    return UserModel.fromJson({});
  }

  Future<String> userLogin(String username, String password) async {
    var resultData = await dio.post("/user/login",
        data: {'username': username, 'password': password});
    if (resultData.statusCode == 200) {
      return resultData.data['token'];
    }
    return '';
  }

  Future<UserModel> updateProfile() async {
    var resultData = await dio.get('/user/me');
    if (resultData.statusCode == 200) {
      return UserModel.fromJson(resultData.data);
    }
    return UserModel.fromJson({});
  }

  Future<List<SongModel>> getNetworkSongs() async {
    var resultData = await dio.get('/song/all');
    if (resultData.statusCode == 200) {
      return resultData.data;
    }
    return [];
  }

  Future<bool> syncLocalSongs(List<String> songIds) async {
    var resultData =
        await dio.post('/song/upload', data: {'localSongs': songIds});
    return resultData.statusCode == 200;
  }

  Future<bool> likeSong(String songId) async {
    var resultData = await dio.get('/song/like');
    return resultData.statusCode == 200;
  }

  Future<bool> unlikeSong(String songId) async {
    var resultData = await dio.get('/song/unlike');
    return resultData.statusCode == 200;
  }

  Future<List<String>> getSuggestSongs() async {
    var resultData = await dio.get('/song/suggest');
    if (resultData.statusCode == 200) {
      List<String> list = [];
      for (var item in resultData.data) {
        list.add(item.toString());
      }
      return list;
    }
    return [];
  }

  Future<List<CommentModel>> getComments(String songId) async {
    var resultData = await dio.get('/song/$songId');
    if (resultData.statusCode == 200) {
      List<CommentModel> list = [];
      for (var item in resultData.data['comments']) {
        list.add(CommentModel.fromJson(item));
      }
      return list;
    }
    return [];
  }

  Future<void> sendComment(String songId, CommentModel comment) async {
    await dio.post('/song/comment',
        data: {'songId': songId, 'name': comment.name, 'txt': comment.txt});
  }
}
