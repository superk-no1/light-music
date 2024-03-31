import 'package:dio/dio.dart';
import 'package:meloplay/src/data/model/userModel.dart';

final apiManager = ApiManager();

class ApiManager {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.88.101:3000/api',
  ));

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
}

class NetResult {}
