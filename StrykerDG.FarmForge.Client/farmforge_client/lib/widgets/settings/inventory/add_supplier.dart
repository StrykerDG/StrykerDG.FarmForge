import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';

import 'package:farmforge_client/widgets/multi_select/multi_select_dialog.dart';
import 'package:farmforge_client/widgets/multi_select/multi_select_options.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ProductType> _productTypes = [];
  List<MultiSelectOption> _productTypeOptions = [];
  List<int> _selectedSupplierProducts = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _supplyController = TextEditingController();

  void handleMultiSelectTap() async {
    List<int> results = await showDialog(
      context: context,
      builder: (context) => MultiSelectDialog(
        options: _productTypeOptions,
        defaultValues: _selectedSupplierProducts,
      )
    );

    if(results != null)
      setState(() {
        _selectedSupplierProducts = results;
        _supplyController.text = '${_selectedSupplierProducts.length} ' +
          ' item(s) selected';
      });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _supplyController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _productTypes = Provider.of<DataProvider>(context).productTypes;
      _productTypeOptions = _productTypes.map((t) =>
        MultiSelectOption(value: t.productTypeId, label: t.label)
      ).toList();
    });
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  readOnly: true,
                  controller: _supplyController,
                  onTap: handleMultiSelectTap,
                  decoration: InputDecoration(
                    labelText: 'Supplies...'
                  ),
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