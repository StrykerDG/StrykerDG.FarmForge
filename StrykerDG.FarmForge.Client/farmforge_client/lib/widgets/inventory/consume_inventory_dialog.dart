import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/inventory/product.dart';

import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class ConsumeInventoryDialog extends StatefulWidget {
  final List<Product> products;

  ConsumeInventoryDialog({@required this.products});

  @override
  _ConsumeInventoryDialogState createState() => _ConsumeInventoryDialogState();
}

class _ConsumeInventoryDialogState extends State<ConsumeInventoryDialog> {
  List<FarmForgeDataTableColumn> _columns = [];
  List<int> _selectedItems = [];

  void onSelectChange(bool value, int index) {
    if(value == false)
      _selectedItems.removeWhere((e) => e == index);

    else {
      int element = _selectedItems.firstWhere(
        (e) => e == index,
        orElse: () => null
      );

      if(element == null) 
        _selectedItems.add(index);
    }
  }

  void handleConsume() async {
    try {
      List<int> productsToConsume = [];
      widget.products.asMap().forEach((index, product) { 
        if(_selectedItems.contains(index))
          productsToConsume.add(product.productId);
      });

      FarmForgeResponse result = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .consumeInventory(productsToConsume);

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
      UiUtility.handleError(
        context: context, 
        title: 'Save Error', 
        error: e.toString()
      );
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

  @override
  void initState() {
    super.initState();

    setState(() {
      _columns = generateColumns();
    });
  }

  @override
  Widget build(BuildContext context) {
    double dataTableHeight = widget.products.length * kRowHeight;
    if(dataTableHeight > kSmallListHeight)
      dataTableHeight = kSmallListHeight;

    return Column(
      children: [
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
          child: Text('Consume'),
          onPressed: handleConsume
        )
      ],
    );
  }
}