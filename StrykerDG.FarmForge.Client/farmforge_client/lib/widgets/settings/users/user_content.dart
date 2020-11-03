import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/user.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/settings/users/add_user.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class UserContent extends StatefulWidget {
  @override
  _UserContentState createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  List<User> _users = [];
  List<DropdownMenuItem<int>> _userOptions;
  int _selectedUser;

  void handleUserSelection(int newValue) {
    setState(() {
      _selectedUser = newValue;
    });
  }

  void handleAddUser() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New User',
        content: AddUser(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  void handleDeleteUser() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteUser(_selectedUser);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteUser(_selectedUser);

        setState(() {
          _selectedUser = null;
        });
      }
      else
        throw deleteResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Delete Error', 
        error: e.toString()
      );
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _users = Provider.of<DataProvider>(context).users;

    _userOptions = _users.map((user) => 
      DropdownMenuItem<int>(
        value: user.userId, 
        child: Text(user.username),
      )
    ).toList();
  }
  
  @override
  Widget build(BuildContext context) {

    Function deleteAction = _selectedUser == null
      ? null
      : handleDeleteUser;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(kSmallPadding),
          child: Wrap(
            children: [
              Container(
                width: kStandardInput,
                child: DropdownButtonFormField<int>(
                  value: _selectedUser,
                  items: _userOptions,
                  onChanged: handleUserSelection,
                  decoration: InputDecoration(
                    labelText: 'User'
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: deleteAction,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: handleAddUser,
              ),
            ],
          ),
        )
      ]
    );
  }
}