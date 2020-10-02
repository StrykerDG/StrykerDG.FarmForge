import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        FarmForgeResponse addResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createUser(_userController.text, _passwordController.text);

        if(addResponse.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addUser(addResponse.data);

          Navigator.pop(context);
        }
        else 
          throw(addResponse.error);
      }
      catch(e) {
        UiUtility.handleError(
          context: context, 
          title: 'Save Error', 
          error: e.toString()
        );
      }
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSmallDesktopModalWidth,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kSmallPadding
            ),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisSize:  MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: 'Username'
                      ),
                      validator: Validation.isNotEmpty,
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.visibility),
                          onTap: toggleObscurePassword,
                        )
                      ),
                      validator: Validation.isNotEmpty,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(kSmallPadding),
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: handleSave,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}