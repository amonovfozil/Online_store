import 'package:flutter/material.dart';
import 'package:online_market/providers/auth.dart';
import 'package:online_market/servises/http_exteption.dart';
import 'package:provider/provider.dart';

enum _Authmode { loginn, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _TextForm = GlobalKey<FormState>();
  final _PasswordControl = TextEditingController();
  Map<String, String> AuthData = {'email': '', "passwords": ''};
  var _isLoading = false;
  void _showError(String message) {
    showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            title: Center(
              child: Text(
                'XATOLIK',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            content: Text(message),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK'),
                style: ElevatedButton.styleFrom(minimumSize: Size(200, 40)),
              ),
            ],
          );
        }));
  }

  Future<void> _SaveFormText() async {
    if (_TextForm.currentState!.validate()) {
      // malumotlani saqla
      _TextForm.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (authmode == _Authmode.loginn) {
          //login o`tish
          await Provider.of<AuthProvider>(context, listen: false).login(
            AuthData['email']!,
            AuthData['passwords']!,
          );
        } else {
          //registratsiyadan o`tish
          await Provider.of<AuthProvider>(context, listen: false).SignUp(
            AuthData['email']!,
            AuthData['passwords']!,
          );
        }
      } on HttpException catch (error) {
        print(error);
        var message = 'Xatolik Sodir bo`ldi';
        if (error.message.contains('EMAIL_EXISTS')) {
          message = 'Bu email manzil ro`yxatdan o`tgan';
        } else if (error.message.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          message = 'nodatiy urunushlar ko`pligi tufayli bloklandi';
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          message = 'Email manzilingiz ro`yxatdan o`tmagan';
        } else if (error.message.contains('INVALID_PASSWORD')) {
          message = 'Noto`g`ri parol kiritdingiz';
        } else if (error.message.contains('USER_DISABLED')) {
          message = 'Bu hisob adminstrator tomonidan cheklangan ';
        }
        _showError(message);
      } catch (error) {
        print(error);

        var message = 'Xatolik sodir bo`ldi, Iltimos qayta urinib ko`ring';
        _showError(message);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _Authmode authmode = _Authmode.loginn;
  void ClickRegistr() {
    if (authmode == _Authmode.loginn) {
      setState(() {
        authmode = _Authmode.register;
      });
    } else {
      setState(() {
        authmode = _Authmode.loginn;
      });
    }
  }

  var blind1 = true;
  var blind2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Form(
            key: _TextForm,
            child: Column(
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'assets/images/logo1.jpg',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'email adrees:',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => AuthData['email'] = newValue!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'iltimos Email manzilingizni kirgizing!';
                    } else if (!value.contains('@')) {
                      return 'iltimos to`g`ri Email manzil kiriting!';
                    }
                  },
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      obscureText: blind1,
                      decoration: const InputDecoration(
                        labelText: 'Parol',
                      ),
                      controller: _PasswordControl,
                      onSaved: (newValue) => AuthData['passwords'] = newValue!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'iltimos parolingizni kiriting!';
                        } else if (value.length < 6) {
                          return 'iltimos 6 ta simbldan kam kiritingiz';
                        }
                      },
                    ),
                    Positioned(
                      right: 0,
                      top: 12,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            blind1 = !blind1;
                          });
                        },
                        icon: Icon(
                          blind1
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                authmode == _Authmode.register
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                obscureText: blind2,
                                decoration: const InputDecoration(
                                  labelText: 'Parolni tasdiqlang',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'iltimos parolingizni tasdiqlang!';
                                  } else if (value.length < 6) {
                                    return 'iltimos 6 ta simbldan kam kiritingiz';
                                  } else if (value != _PasswordControl.text) {
                                    return 'Parol tasdiqlanmadi';
                                  }
                                },
                              ),
                              Positioned(
                                right: 0,
                                top: 12,
                                child: IconButton(
                                  onPressed: () {
                                    {
                                      setState(() {
                                        blind2 = !blind2;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    blind2
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.remove_red_eye,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const SizedBox(height: 40),
                !_isLoading
                    ? ElevatedButton(
                        onPressed: _SaveFormText,
                        child: Text(
                          authmode == _Authmode.loginn
                              ? 'Kirish'
                              : 'Ro`yxatdan o`tish',
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 55)),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: ClickRegistr,
                  child: Text(
                    authmode == _Authmode.loginn
                        ? 'Ro`yxatdan o`tish'
                        : 'Kirish',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
