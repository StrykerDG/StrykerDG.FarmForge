import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/suppliers/supplier.dart';
import 'package:farmforge_client/models/dto/add_inventory_dto.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';

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
  int _supplier;
  int _unitType;
  List<Supplier> _suppliers;
  List<Location> _locations;
  List<UnitType> _units;

  void loadData() {
    try {
      Future<FarmForgeResponse> supplierFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getSuppliers(includes: 'Products');
      Future<FarmForgeResponse> locationFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getLocations();
      Future<FarmForgeResponse> unitFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getUnitTypes();

      Future.wait([supplierFuture, locationFuture, unitFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setSuppliers(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
          Provider.of<DataProvider>(context, listen: false)
            .setUnitTypes(responses[2].data);
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

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        AddInventoryDTO newInventory = AddInventoryDTO(
          supplierId: _supplier,
          productTypeId: _productType,
          locationId: _location,
          unitTypeId: _unitType,
          quantity: int.parse(_quantityController.text)
        );

        FarmForgeResponse result = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .addInventory(newInventory);

        if(result.data != null) {
          FarmForgeResponse inventoryResponse = await Provider
            .of<CoreProvider>(context, listen: false)
            .farmForgeService
            .getInventory();

          if(inventoryResponse.data != null)
            Provider.of<DataProvider>(context, listen: false)
              .setInventory(inventoryResponse.data);
          else
            throw inventoryResponse.error;

          Navigator.pop(context);
        }
        else
          throw result.error;
      }
      catch(e) {

      }
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

  void handleSupplierSelect(int value) {
    setState(() {
      _supplier = value;
    });
  }

  void handleUnitSelect(int value) {
    setState(() {
      _unitType = value;
    });
  }

  DropdownButtonFormField<int> getSupplierDropDown() {
    List<DropdownMenuItem<int>> supplierOptions = _suppliers.map((s) => 
      DropdownMenuItem<int>(
        value: s.supplierId,
        child: Text(s.name.toString()),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _supplier,
      onChanged: handleSupplierSelect,
      items: supplierOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Supplier'
      ),
    );
  }
  
  DropdownButtonFormField<int> getProductTypeDropdown() {
    List<DropdownMenuItem<int>> productOptions = [];
    
    if(_supplier != null) {
      Supplier selectedSupplier = _suppliers.firstWhere(
        (s) => s.supplierId == _supplier,
        orElse: () => null
      );

      productOptions = selectedSupplier?.products?.map((p) => 
        DropdownMenuItem(
          value: p.productTypeId,
          child: Text(p.label)
        )
      )?.toList() ?? [];
    }

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

  DropdownButtonFormField<int> getUnitTypeDropdown() {
    List<DropdownMenuItem<int>> unitOptions = _units.map((u) => 
      DropdownMenuItem(
        value: u.unitTypeId,
        child: Text(u.label)
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _unitType,
      onChanged: handleUnitSelect,
      items: unitOptions, 
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Unit Type'
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
      _suppliers = Provider.of<DataProvider>(context).suppliers;
      _units = Provider.of<DataProvider>(context).unitTypes;
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
    DropdownButtonFormField<int> unitTypeDropdown = getUnitTypeDropdown();

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
                ),
                unitTypeDropdown
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