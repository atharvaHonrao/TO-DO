import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/ThemeProvider.dart';
import 'package:to_do_app/providers/User_Provider.dart';

import '../services/firebase_auth_methods.dart';
import '../widgets/appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, value1, Widget? child) =>
          Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget? child) => Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Study Budy',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter UserName or email id",
                      label: Text("Username or Email id")),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Password",
                    label: Text("Password"),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // Text(value.email),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuthMethods(FirebaseAuth.instance).login(
                      email: _usernameController.text,
                      password: _passwordController.text,
                      context: context);
                  value.updateUsername(_usernameController.text);
                },
                child: Text("Login"),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => {Navigator.pushNamed(context, '/signup')},
                  child: Text("Go to Sign Up Page"))
            ],
          ),
        )),
      ),
    );
  }
}
