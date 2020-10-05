import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddCropVarieity extends StatefulWidget {
  final int cropTypeId;

  AddCropVarieity({@required this.cropTypeId});

  @override
  _AddCropVarieityState createState() => _AddCropVarieityState();
}

class _AddCropVarieityState extends State<AddCropVarieity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        FarmForgeResponse addResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createCropVariety(_nameController.text, widget.cropTypeId);

        if(addResponse.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addCropTypeVariety(widget.cropTypeId, addResponse.data);

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: kStandardInput,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name'
              ),
              validator: Validation.isNotEmpty,
            ),
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