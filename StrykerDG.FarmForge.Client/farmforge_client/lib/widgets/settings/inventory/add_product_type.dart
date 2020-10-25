import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddProductType extends StatefulWidget {
  @override
  _AddProductTypeState createState() => _AddProductTypeState();
}

class _AddProductTypeState extends State<AddProductType> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _reorderLevelController = TextEditingController();
  List<ProductCategory> _productCategories;
  int _selectedCategory;

  void handleCategoryChange(int newValue) {
    setState(() {
      _selectedCategory = newValue;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _productCategories = Provider.of<DataProvider>(context).productCategories;
  }

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem<int>> categoryOptions = _productCategories.map((pc) => 
      DropdownMenuItem<int>(
        value: pc.productCategoryId,
        child: Text(pc.label),
      )
    ).toList();

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
                  controller: _reorderLevelController,
                  decoration: InputDecoration(
                    labelText: 'Re-order Level'
                  ),
                  validator: Validation.isEmptyOrNumeric,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: DropdownButtonFormField<int>(
                  value: _selectedCategory,
                  items: categoryOptions,
                  onChanged: handleCategoryChange,
                  decoration: InputDecoration(
                    labelText: 'Category'
                  ),
                  validator: Validation.isNotEmpty,
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