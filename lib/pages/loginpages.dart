import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../provider/userprovider.dart';
import '../utils/helper_function.dart';
import 'launcherpage.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errMsg = '';
  bool isLogin = true;

  @override
  void initState() {
    passController.text = '123456';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login Page',
              style: TextStyle(fontSize: 26),
            ),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Your Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                BorderSide(color: Colors.blue, width: 1))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                BorderSide(color: Colors.blue, width: 1))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            isLogin = true;
                            _authenticate();
                          },
                          child: Text('Login'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            isLogin = false;
                            _authenticate();
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      errMsg,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _authenticate() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if(_formKey.currentState!.validate()) {
      final email = emailController.text;
      final pass = passController.text;
      final user = await provider.getUserByEmail(email);
      if(isLogin) {
        //login btn is clicked
        if(user == null) {
          _setErrorMsg('User does not exist');
        } else {
          //check password
          if(pass == user.password) {
            await setLoginStatus(true);
            await setUserId(user.userId!);
            if(mounted) Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          } else {
            //password did not match
            _setErrorMsg('Wrong password');
          }
        }
      } else {
        //register btn is clicked
        if(user != null) {
          //email already exists in table
          _setErrorMsg('User already exists');
        } else {
          //insert new user
          final user = UserModel(
            email: email,
            password: pass,
            isAdmin: false,
          );
          final rowId = await provider.insertNewUser(user);
          await setLoginStatus(true);
          await setUserId(rowId);
          if(mounted) Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      }
    }
  }

  _setErrorMsg(String msg) {
    setState(() {
      errMsg = msg;
    });
  }
}
