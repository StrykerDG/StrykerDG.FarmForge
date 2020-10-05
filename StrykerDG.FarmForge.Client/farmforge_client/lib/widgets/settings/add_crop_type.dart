import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/crops/crop_classification.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddCropType extends StatefulWidget {
  @override
  _AddCropTypeState createState() => _AddCropTypeState();
}

class _AddCropTypeState extends State<AddCropType> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  List<CropClassification> _classifications;
  int _classificationId;

  void loadData() async {
    try {
      FarmForgeResponse cropClassifications = await Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getCropClassifications();

      if(cropClassifications.data != null)
        Provider.of<DataProvider>(context, listen: false)
          .setCropClassifications(cropClassifications.data);
      else
        throw cropClassifications.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {

        FarmForgeResponse addResult = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createCropType(_nameController.text, _classificationId);

        if(addResult.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addCropType(addResult.data);

          Navigator.pop(context);
        }
        else
          throw(addResult.error);
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

  void handleClassificationChange(int newValue) {
    setState(() {
      _classificationId = newValue;
    });
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _classifications = Provider.of<DataProvider>(context).cropClassifications;
  }

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem<int>> classificationOptions = _classifications.map((c) => 
      DropdownMenuItem<int>(
        value: c.cropClassificationId,
        child: Text(c.label),
      )
    ).toList();

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              Container(
                width: kStandardInput,
                child: DropdownButtonFormField<int>(
                  value: _classificationId,
                  onChanged: handleClassificationChange,
                  items: classificationOptions,
                  decoration: InputDecoration(
                    labelText: 'Classification'
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