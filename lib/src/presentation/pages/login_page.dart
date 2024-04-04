import 'package:flutter/material.dart';
import 'package:meloplay/src/presentation/utils/apiManager.dart';
import 'package:meloplay/src/presentation/utils/global.dart';

enum LoginType { register, login }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool pwdShow = false;
  LoginType pageType = LoginType.login;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final bool _nameAutoFocus = true;

  bool get isLogin => pageType == LoginType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.account_circle),
          title: Text(isLogin ? '登录' : '注册')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: _nameAutoFocus,
                  controller: _unameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    hintText: '用户名',
                    prefixIcon: Icon(Icons.person),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : '用户名不允许为空';
                  }),
              TextFormField(
                controller: _pwdController,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '密码',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : '密码不允许为空';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    // color: Theme.of(context).primaryColor,
                    onPressed: isLogin ? _onLogin : _onRegister,
                    // textColor: Colors.white,
                    child: Text(isLogin ? '登录' : '注册'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      pageType = isLogin ? LoginType.register : LoginType.login;
                      setState(() {});
                    },
                    child: Text(
                      isLogin ? '注册新账号' : '返回登录',
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _onRegister() async {
    //先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      var resultDate = await apiManager.userRegister(
          _unameController.text, _pwdController.text);
      if (resultDate.id.isNotEmpty) {
        Global.profile = resultDate;
        pageType = LoginType.login;
        //kk todo 添加toast
        setState(() {});
      } else {

      }
    }
  }

  void _onLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      var resultDate = await apiManager.userLogin(
          _unameController.text, _pwdController.text);
      if (resultDate.isNotEmpty) {
        Global.token = resultDate;
        Navigator.of(context).pop();
      } else {
        //kk todo 登录失败
      }
    }
  }
}
