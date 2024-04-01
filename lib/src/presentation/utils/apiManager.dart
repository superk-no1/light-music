import 'package:dio/dio.dart';
import 'package:meloplay/src/data/model/networkSongModel.dart';
import 'package:meloplay/src/data/model/userModel.dart';
import 'package:meloplay/src/presentation/utils/global.dart';

final apiManager = ApiManager();

class ApiManager {
  static Dio dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.88.101:3000/api',
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

  Future<List<NetworkSongModel>> getNetworkSongs() async {
    var resultData = await dio.get('/song/all');
    if (resultData.statusCode == 200) {
      return resultData.data;
    }
    return [];
  }
}

class NetResult {}
