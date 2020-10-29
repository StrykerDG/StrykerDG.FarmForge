import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class AddProductType extends StatefulWidget {
  final ProductType productType;

  AddProductType({this.productType});

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

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        ProductType newType = ProductType(
          productTypeId: widget.productType?.productTypeId,
          label: _labelController.text,
          reorderLevel: int.tryParse(_reorderLevelController.text),
          productCategoryId: _selectedCategory
        );

        // Create
        if(widget.productType == null) {
          FarmForgeResponse addResponse = await Provider
            .of<CoreProvider>(context, listen: false)
            .farmForgeService
            .addProductType(newType);

          if(addResponse.data != null) {
            Provider.of<DataProvider>(context, listen: false)
              .addProductType(addResponse.data);

            Navigator.pop(context);
          }
          else
            throw(addResponse.error);
        }
        // Update
        else {
          FarmForgeResponse updateResponse = await Provider
            .of<CoreProvider>(context, listen: false)
            .farmForgeService
            .updateProductType(newType);

          if(updateResponse.data != null) {
            Provider.of<DataProvider>(context, listen: false)
              .updateProductType(updateResponse.data);

            Navigator.pop(context);
          }
          else
            throw updateResponse.error;
        }

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
  void initState() {
    super.initState();

    if(widget.productType != null) { 
      setState(() {
        _labelController.text = widget.productType.label;
        _reorderLevelController.text = widget.productType.reorderLevel?.toString();
        _selectedCategory = widget.productType.productCategoryId;
      });
    }
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
          onPressed: handleSave
        )
      ],
    );
  }
}