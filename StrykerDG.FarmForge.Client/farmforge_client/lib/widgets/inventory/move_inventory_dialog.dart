import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/inventory/product.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';

import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';


class MoveInventoryDialog extends StatefulWidget {
  final List<Product> products;

  MoveInventoryDialog({@required this.products});

  @override
  _MoveInventoryDialogState createState() => _MoveInventoryDialogState();
}

class _MoveInventoryDialogState extends State<MoveInventoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _location;
  List<Location> _locations = [];
  List<FarmForgeDataTableColumn> _columns;
  List<int> _selectedItems = [];

  void onSelectChange(bool value, int index) {
    if(value == false)
      _selectedItems.removeWhere((element) => element == index);
    
    else {
      int element = _selectedItems.firstWhere(
        (e) => e == index,
        orElse: () => null
      );

      if(element == null)
        _selectedItems.add(index);
    }
  }

  void loadData() async {
    try {
      FarmForgeResponse locations = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getLocations();

      if(locations.data != null)
        Provider.of<DataProvider>(context, listen: false)
          .setLocations(locations.data);
      else 
        throw locations.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  void handleLocationSelect(int newValue) {
    setState(() {
      _location = newValue;
    });
  }

  String isValidLocation(int value) {
    String result = Validation.isNotEmpty(value);
    if(result == null)
      result = value != widget.products?.first?.locationId
        ? null
        : 'Item is currently at this location';

    return result;
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        List<int> productsToUpdate = [];
        
        widget.products.asMap().forEach((index, product) { 
          if(_selectedItems.contains(index))
            productsToUpdate.add(product.productId);
        });

        FarmForgeResponse result = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .moveInventoryToLocation(productsToUpdate, _location);

        if(result.data != null) {
          // Reload Inventory
          FarmForgeResponse inventoryResponse = await Provider
            .of<CoreProvider>(context, listen: false)
            .farmForgeService
            .getInventory();

          if(inventoryResponse.data != null) {
            Provider.of<DataProvider>(context, listen: false)
              .setInventory(inventoryResponse.data);
          }
          else
            throw inventoryResponse.error;

          // Pop the modal
          Navigator.pop(context);
        }
        else
          throw result.error;
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

  List<FarmForgeDataTableColumn> generateColumns() {
    return [
      FarmForgeDataTableColumn(
        label: 'Product',
        property: 'ProductType.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Created',
        property: 'Created'
      )
    ];
  }

  DropdownButtonFormField<int> getLocationDropdown() {
    List<DropdownMenuItem<int>> locationOptions = _locations.map((l) => 
      DropdownMenuItem<int>(
        value: l.locationId,
        child: Text(l.label)
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _location,
      onChanged: handleLocationSelect,
      items: locationOptions, 
      validator: isValidLocation,
      decoration: InputDecoration(
        labelText: 'Move to'
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadData();
    setState(() {
      _columns = generateColumns();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _locations = Provider.of<DataProvider>(context).locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    DropdownButtonFormField<int> locationDropdown = getLocationDropdown();

    double dataTableHeight = widget.products.length * kRowHeight;
    if(dataTableHeight > kSmallListHeight)
      dataTableHeight = kSmallListHeight;

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: kStandardInput,
            child: locationDropdown,
          ),
        ),
        SizedBox(height: kSmallPadding),
        Container(
          height: dataTableHeight,
          child: SingleChildScrollView(
            child: FarmForgeDataTable<Product>(
              columns: _columns,
              data: widget.products,
              showCheckBoxes: true,
              onSelectChange: onSelectChange,
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