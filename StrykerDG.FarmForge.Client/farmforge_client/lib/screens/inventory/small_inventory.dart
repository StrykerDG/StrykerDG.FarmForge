import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/dto/inventory_dto.dart';

import 'package:farmforge_client/widgets/inventory/inventory_action_button.dart';

import 'package:farmforge_client/utilities/constants.dart';

class SmallInventory extends StatefulWidget {
  @override
  _SmallInventoryState createState() => _SmallInventoryState();
}

class _SmallInventoryState extends State<SmallInventory> {
  List<InventoryDTO> _inventory = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _inventory = Provider.of<DataProvider>(context).inventory;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double containerHeight = deviceHeight - kAppBarHeight;

    return Container(
      height: containerHeight,
      child: ListView.builder(
        itemCount: _inventory.length,
        itemBuilder: (context, index) {
          InventoryDTO currentInventory = _inventory.elementAt(index);

          String title = '${currentInventory.productType.label} - ' +
            '${currentInventory.unitType.label}';

          return ListTile(
            leading: CircleAvatar(
              child: Text(currentInventory.quantity.toString())
            ),
            title: Text(title),
            subtitle: Text(currentInventory.location.label),
            trailing: InventoryActionButton(inventory: currentInventory),
          );
        }
      ),
    );
  }
}