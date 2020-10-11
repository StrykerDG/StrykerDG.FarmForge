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
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: 'Username'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
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
        Row(
          children: [
            Expanded(
              child: Container(),
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: handleSave,
            )
          ],
        )
      ],
    );
  }
}