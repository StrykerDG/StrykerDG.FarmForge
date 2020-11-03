import 'package:flutter/material.dart';

import 'package:farmforge_client/models/dto/inventory_dto.dart';
import 'package:farmforge_client/models/enums.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/inventory/consume_inventory_dialog.dart';
import 'package:farmforge_client/widgets/inventory/move_inventory_dialog.dart';
import 'package:farmforge_client/widgets/inventory/split_inventory_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

class InventoryActionButton extends StatelessWidget {
  final InventoryDTO inventory;

  InventoryActionButton({@required this.inventory});

  void handleActionSelect(BuildContext context, InventoryAction action, InventoryDTO inventory) {
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
        showDialog(
          context: context,
          builder: (context) => FarmForgeDialog(
            title: 'Split Inventory',
            content: SplitInventory(
              products: inventory.products,
              productType: inventory.productType,
              unitType: inventory.unitType,
              location: inventory.location
            ),
            width: kSmallDesktopModalWidth,
          )
        );
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
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<InventoryAction>(
      onSelected: (selection) => 
        handleActionSelect(context, selection, inventory),
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
}