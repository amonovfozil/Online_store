import 'package:flutter/material.dart';
import 'package:online_market/providers/auth.dart';
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
  Map<String, String> AuthData = {'email': '', "password": ''};

  void _SaveFormText() {
    if (_TextForm.currentState!.validate()) {
      // malumotlani saqla
      _TextForm.currentState!.save();

      if (authmode == _Authmode.register) {
        //registratsiyan o`tish
        Provider.of<AuthProvider>(context, listen: false)
            .SignUp(AuthData['email']!, AuthData["password"]!);
      }
    }
  }

  _Authmode authmode = _Authmode.loginn;

  var blind1 = true;
  var blind2 = true;

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Form(
            key: _TextForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logo1.jpg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'email adrees:',
                  ),
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
                      obscureText: blind1,
                      decoration: const InputDecoration(
                        labelText: 'Parol',
                      ),
                      controller: _PasswordControl,
                      onFieldSubmitted: (newValue) =>
                          AuthData['password'] = newValue,
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
                ElevatedButton(
                  onPressed: _SaveFormText,
                  child: Text(
                    authmode == _Authmode.loginn
                        ? 'Kirish'
                        : 'Ro`yxatdan o`tish',
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20)),
                ),
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
