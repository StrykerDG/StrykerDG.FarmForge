import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';

import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void handleSignIn() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        FarmForgeResponse tokenResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .login(_usernameController.text, _passwordController.text);

        if(tokenResponse.data != null) {
          Map<String, dynamic> tokenInfo = Utility.parseJwt(tokenResponse.data);

          print('Login? $tokenInfo');
          // Set user in state
          // Navigate to home
        }
        else {
          UiUtility.handleError(
            context: context, 
            title: 'Login Error', 
            error: tokenResponse.error
          );
        }
      }
      catch(e) {
        UiUtility.handleError(
          context: context, 
          title: 'Login Error', 
          error: e.toString()
        );
      }
      finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
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
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Username
                  TextFormField(
                    controller: _usernameController,
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
                    validator: Validation.isNotEmpty,
                  ),

                  // Password
                  TextFormField(
                    controller: _passwordController,
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
                    validator: Validation.isNotEmpty,
                  ),

                  // Login button
                  isLoading == true
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text("Sign In"),
                        onPressed: handleSignIn,
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