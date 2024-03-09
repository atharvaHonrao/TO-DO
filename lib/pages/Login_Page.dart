import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
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

  signup() async {
    
  }

  login() async {}

  @override
  Widget build(BuildContext context) {
    var _passwordVisible = false;
    return Consumer<UserProvider>(
      builder: (BuildContext context, value, Widget? child) => Scaffold(
          appBar: PreferredSize(
            child: AppbarWidget("Login Page"),
            preferredSize: const Size.fromHeight(50),
          ),
          body: Column(
            children: [
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Password",
                      label: Text("Password"),suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(value.email),
              ElevatedButton(
                onPressed: () {
                  // Call updateEmail method to update email value
                  FirebaseAuthMethods(FirebaseAuth.instance).login(
                      email: _usernameController.text,
                      password: _passwordController.text,
                      context: context);
                  value.updateUsername(_usernameController.text);
                },
                child: Text("Login"),
              )
            ],
          )),
    );
  }
}
