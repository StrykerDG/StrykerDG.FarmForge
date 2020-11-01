import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/dto/inventory_dto.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';

import 'package:farmforge_client/widgets/farm_forge_data_table.dart';
import 'package:farmforge_client/widgets/inventory/move_inventory_dialog.dart';
import 'package:farmforge_client/widgets/inventory/consume_inventory_dialog.dart';
import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

enum InventoryAction {
  MOVE,
  SPLIT,
  CONSUME
}

class LargeInventory extends StatefulWidget {
  @override
  _LargeInventoryState createState() => _LargeInventoryState();
}

class _LargeInventoryState extends State<LargeInventory> {
  List<FarmForgeDataTableColumn> _columns;
  List<InventoryDTO> _inventory = [];

  void handleActionSelect(InventoryAction action, InventoryDTO inventory) {
    switch(action) {
      case InventoryAction.MOVE:
        showDialog(
          context: context,
          builder: (context) => FarmForgeDialog(
            title: 'Move Inventory',
            content: MoveInventoryDialog(products: inventory.products),
            width: kSmallDesktopModalWidth,
          )
        );
        break;
      case InventoryAction.SPLIT:
        break;
      case InventoryAction.CONSUME:
        showDialog(
          context: context,
          builder: (context) => FarmForgeDialog(
            title: 'Consume Inventory',
            content: ConsumeInventoryDialog(products: inventory.products),
            width: kSmallDesktopModalWidth,
          )
        );
        break;
    }
  }

  Widget getColumnActionButton(InventoryDTO inventory) {
    return PopupMenuButton<InventoryAction>(
      onSelected: (selection) => handleActionSelect(selection, inventory),
      itemBuilder: (context) => <PopupMenuEntry<InventoryAction>>[
        PopupMenuItem<InventoryAction>(
          value: InventoryAction.MOVE,
          child: Text('Move')
        ),
        PopupMenuItem<InventoryAction>(
          value: InventoryAction.SPLIT,
          child: Text('Split')
        ),
        PopupMenuItem<InventoryAction>(
          value: InventoryAction.CONSUME,
          child: Text('Consume')
        )
      ]
    );
  }

  List<FarmForgeDataTableColumn> generateColumns() {
    return [
      FarmForgeDataTableColumn(
        label: 'Product',
        property: 'ProductType.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Quantity',
        property: 'Quantity'
      ),
      FarmForgeDataTableColumn(
        label: 'Unit',
        property: 'UnitType.Label',
      ),
      FarmForgeDataTableColumn(
        label: 'Location',
        property: 'Location.Label'
      ),
      FarmForgeDataTableColumn(
        label: '',
        propertyFunc: (InventoryDTO s) => getColumnActionButton(s)
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _inventory = Provider.of<DataProvider>(context).inventory;
    });
  }

  @override
  Widget build(BuildContext context) {

    double dataTableHeight = MediaQuery.of(context).size.height - kAppBarHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: dataTableHeight,
          child: SingleChildScrollView(
            child: FarmForgeDataTable<InventoryDTO>(
              columns: _columns,
              data: _inventory,
              showCheckBoxes: false,
            )
          ),
        )
      ],
    );
  }
}