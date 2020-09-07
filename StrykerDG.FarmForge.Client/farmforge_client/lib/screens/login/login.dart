import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black
            ),
            borderRadius: BorderRadius.all(Radius.circular((20)))
          ),
          width: 300,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Username
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                  ),
                  // Password
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                  ),
                  RaisedButton(
                    child: Text("Sign In"),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular((20))
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}