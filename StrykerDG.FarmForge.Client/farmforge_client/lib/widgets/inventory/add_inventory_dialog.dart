import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddInventoryDialog extends StatefulWidget {
  @override
  _AddInventoryDialogState createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _quantityController = TextEditingController();
  int _location;
  int _productType;
  List<Location> _locations;
  List<ProductType> _productTypes;

  void loadData() {
    try {
      Future<FarmForgeResponse> productTypeFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getProductTypes();
      Future<FarmForgeResponse> locationFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getLocations();

      Future.wait([productTypeFuture, locationFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setProductTypes(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
        });
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  void handleSave() {
    if(_formKey.currentState.validate()) {
      print('would be saving...');
    }
  }

  void handleLocationSelect(int value) {
    setState(() {
      _location = value;
    });
  }

  void handleProductTypeSelect(int value) {
    setState(() {
      _productType = value;
    });
  }

  DropdownButtonFormField<int> getSupplierDropDown() {
    List<DropdownMenuItem<int>> locationOptions = [0, 1, 2].map((l) => 
      DropdownMenuItem<int>(
        value: l,
        child: Text(l.toString()),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: 0,
      onChanged: (int newValue) { },
      items: locationOptions,
      // validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Supplier'
      ),
    );
  }
  
  DropdownButtonFormField<int> getProductTypeDropdown() {
    List<DropdownMenuItem<int>> productOptions = _productTypes.map((pt) => 
      DropdownMenuItem<int>(
        value: pt.productTypeId,
        child: Text(pt.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _productType,
      onChanged: handleProductTypeSelect,
      items: productOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Product Type'
      ),
    );
  }

  DropdownButtonFormField<int> getLocationDropdown() {
    List<DropdownMenuItem<int>> locationOptions = _locations.map((l) => 
      DropdownMenuItem<int>(
        value: l.locationId,
        child: Text(l.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _location,
      onChanged: handleLocationSelect,
      items: locationOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Location'
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _locations = Provider.of<DataProvider>(context).locations;
      _productTypes = Provider.of<DataProvider>(context).productTypes;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    DropdownButtonFormField<int> supplierDropdown = getSupplierDropDown();
    DropdownButtonFormField<int> productTypeDropdown = getProductTypeDropdown();
    DropdownButtonFormField<int> locationDropdown = getLocationDropdown();

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: kStandardInput,
            child: Column(
              children: [
                supplierDropdown,
                productTypeDropdown,
                locationDropdown,
                TextFormField(
                  controller: _quantityController,
                  validator: Validation.isNumeric,
                  decoration: InputDecoration(
                    labelText: ('Quantity')
                  ),
                )
              ],
            ),
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