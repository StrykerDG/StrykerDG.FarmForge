import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class AddProductCategory extends StatefulWidget {
  @override
  _AddProductCategoryState createState() => _AddProductCategoryState();
}

class _AddProductCategoryState extends State<AddProductCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        ProductCategory newCategory = ProductCategory(
          label: _labelController.text,
          description: _descriptionController.text
        );

        FarmForgeResponse addResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .addProductCategory(newCategory);

        if(addResponse.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addProductCategory(addResponse.data);

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
    _labelController.dispose();
    _descriptionController.dispose();
    
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
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: 'Label'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description'
                  ),
                  controller: _descriptionController,
                ),
              )
            ],
          ),
        ),
        RaisedButton(
          child: Text('Save'),
          onPressed: handleSave
        )
      ],
    );
  }
}