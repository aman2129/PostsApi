import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:posts/animations/route_animation.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late final TextEditingController _email;
  late final TextEditingController _password;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 50, color: Colors.white),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email required';
                    }
                    return null;
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 55.0,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        final String email = _email.text;
                        final String password = _password.text;
                        await firebaseAuth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            RouteAnimation().createLoginRoute(),
                            (route) => false);
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Register',
                      style: TextStyle(color: Colors.white),),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text(
                    'Already Registered? Login here',
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
