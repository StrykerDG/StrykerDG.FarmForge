import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/dto/split_inventory_dto.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/inventory/product.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';
import 'package:farmforge_client/models/inventory/unit_type_conversion.dart';

import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class SplitInventory extends StatefulWidget {
  final List<Product> products;
  final ProductType productType;
  final UnitType unitType;
  final Location location;

  SplitInventory({
    @required this.products,
    this.productType,
    this.unitType,
    this.location
  });

  @override
  _SplitInventoryState createState() => _SplitInventoryState();
}

class _SplitInventoryState extends State<SplitInventory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _conversion;
  List<int> _selectedItems = [];
  List<FarmForgeDataTableColumn> _columns = [];
  List<UnitTypeConversion> _unitConversions = [];

  void loadData() async {
    try {
      FarmForgeResponse unitConversion = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getConversionsByUnit(widget.unitType.unitTypeId);

      if(unitConversion.data != null)
        Provider.of<DataProvider>(context, listen: false)
          .setUnitTypeConversions(unitConversion.data);
      else
        throw unitConversion.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  // Make sure that the number of selected items is a multiple of 
  // the "From Quantity" on the selected conversion
  bool validateConversion() {
    int itemsSelected = _selectedItems.length;
    UnitTypeConversion selectedConversion = _unitConversions.firstWhere((c) => 
      c.unitTypeConversionId == _conversion,
      orElse: () => null
    );
    int minimumItems = selectedConversion?.fromQuantity;

    return 
      minimumItems != null && 
      itemsSelected > 0 &&
      itemsSelected % minimumItems == 0
        ? true
        : false;
  }

  void handleConversionSelect(int value) {
    setState(() {
      _conversion = value;
    });
  }

  void onSelectChange(bool value, int index) {
    Product selectedItem = widget.products.elementAt(index);

    if(value == false)
      _selectedItems.removeWhere((e) => e == selectedItem.productId);

    else {
      int element = _selectedItems.firstWhere(
        (e) => e == selectedItem.productId,
        orElse: () => null
      );

      if(element == null)
        _selectedItems.add(selectedItem.productId);
    }
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        if(validateConversion()) {
          SplitInventoryDTO request = SplitInventoryDTO(
            productIds: _selectedItems,
            unitTypeConversionId: _conversion,
            locationId: widget.location.locationId
          );

          FarmForgeResponse result = await Provider
            .of<CoreProvider>(context, listen: false)
            .farmForgeService
            .splitInventory(request);

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
        else
          throw 'You have an invalid number of items selected to perform the ' +
            'selected conversion';
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

  DropdownButtonFormField<int> getConversionDropdown() {
    List<DropdownMenuItem<int>> conversionOptions = _unitConversions.map((c) {
      String label = '${c.fromQuantity} ${c.fromUnit.label} to ' +
        '${c.toQuantity} ${c.toUnit.label}';

      return DropdownMenuItem(
        value: c.unitTypeConversionId,
        child: Text(label)
      );
    }).toList();

    String label = conversionOptions.length > 0
      ? 'Conversion'
      : '';

    return DropdownButtonFormField<int>(
      value: _conversion,
      onChanged: handleConversionSelect,
      items: conversionOptions, 
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: label,
      ),
      disabledHint: Text('No conversions available'),
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
      _unitConversions = Provider.of<DataProvider>(context).unitTypeConversions;
    });
  }

  @override
  Widget build(BuildContext context) {
    DropdownButtonFormField<int> conversionDropdown = getConversionDropdown();

    double dataTableHeight = widget.products.length * kRowHeight;
    if(dataTableHeight > kSmallListHeight)
      dataTableHeight = kSmallListHeight;

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: kStandardInput,
            child: conversionDropdown,
          )
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