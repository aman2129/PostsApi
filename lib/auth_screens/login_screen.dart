import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts/animations/route_animation.dart';
import 'package:posts/auth_screens/register_screen.dart';
import 'package:posts/auth_screens/verify_email_view.dart';

import 'error_dialog_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isDeviceConnected;
  late bool isAlertSet;
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late final TextEditingController _email;
  late final TextEditingController _password;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    isDeviceConnected = false;
    isAlertSet = false;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent[100],
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    hintText: 'Enter valid email',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.lightBlueAccent,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email required';
                    } else if (!value.contains('@') && !value.contains('.')){
                      return 'Enter valid email';
                    }else {
                      return null;
                    }
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    hintText: 'Enter password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.lightBlueAccent,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }else if (!value.contains('@') && !value.contains('.')){
                      return 'Enter valid email';
                    }else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 55,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final String email = _email.text;
                          final String password = _password.text;
                          await firebaseAuth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          await Future.delayed(const Duration(seconds: 2),
                                  () {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                          final user = FirebaseAuth.instance.currentUser;
                          if (user!.emailVerified) {
                            await Navigator.of(context).pushReplacement(
                                RouteAnimation().createPostsRoute());
                          } else {
                            await user.sendEmailVerification();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const VerifyEmailView()),
                                    (route) => false);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            await showErrorDialog(
                                context, 'User not Found');
                            setState(() {
                              isLoading = false;
                            });
                          } else if (e.code == 'wrong-password') {
                            await showErrorDialog(
                                context, 'Wrong password');
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                            (route) => false);
                  },
                  child: const Text(
                    'Not registered yet? Register here',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
