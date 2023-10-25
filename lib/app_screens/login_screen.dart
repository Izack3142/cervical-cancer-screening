import 'package:ccs/app_screens/people_list_screen.dart';
import 'package:ccs/app_services/user_reply_windows_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 10),
                child: _isLoading == false
                    ? Container()
                    : CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
              Expanded(child: Container()),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    label: Text("Enter email"), border: OutlineInputBorder()),
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    label: Text("Enter password"),
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.trim().isNotEmpty &&
                      _passwordController.text.trim().isNotEmpty) {
                    var email = _emailController.text.trim();
                    var pass = _passwordController.text.trim();
                    setState(() {
                      _isLoading = true;
                    });
                    print(_isLoading);
                    await _auth
                        .signInWithEmailAndPassword(
                            email: email, password: pass)
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      UserReplyWindows()
                          .navigateScreen(context, PeopleListScreen(), true);
                    }).catchError((e) {
                      setState(() {
                        _isLoading = false;
                      });
                      UserReplyWindows().showSnackBar(e.code, "error");
                    });
                  } else {
                    UserReplyWindows().showSnackBar(
                        "Email and password are required", "error");
                  }
                },
                child: Text("login"))
          ],
        ),
      ),
    );
  }
}
