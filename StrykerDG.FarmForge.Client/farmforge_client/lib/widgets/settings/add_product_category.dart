import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddProductCategory extends StatefulWidget {
  @override
  _AddProductCategoryState createState() => _AddProductCategoryState();
}

class _AddProductCategoryState extends State<AddProductCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
          onPressed: () {}
        )
      ],
    );
  }
}