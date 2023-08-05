import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../animations/route_animation.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: const Text('Verify email'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text(
              'We have sent you an email to verify email address. Please verify! '
              '\If you haven\'t received a mail, click the button below',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(

              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Send a verification email'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    RouteAnimation().createLoginRoute());
              },
              child: const Text('Verified email? Login here'),
            )
          ],
        ),
      ),
    );
  }
}
