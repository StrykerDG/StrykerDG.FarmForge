import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/screens/inventory/large_inventory.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/inventory/add_inventory_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';


class Inventory extends StatefulWidget {
  static const String title = 'Inventory';
  static const IconData fabIcon = Icons.add;
  static const Function fabAction = handleAddInventory;

  static void handleAddInventory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add Inventory',
        content: AddInventoryDialog(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  
  void loadData() async {
    try {
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
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }
  
  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        
        // We need to use Mediaquery because the constraints is the size of
        // our "Content" width, not the screen 
        double deviceWidth = MediaQuery.of(context).size.width;

        return deviceWidth < kSmallWidthMax
          ? Container()
          : deviceWidth < kMediumWidthMax
            ? Container()
            : LargeInventory();
      },
    );
  }
}