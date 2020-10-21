import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/dto/inventory_dto.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';

import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';

class LargeInventory extends StatefulWidget {
  @override
  _LargeInventoryState createState() => _LargeInventoryState();
}

class _LargeInventoryState extends State<LargeInventory> {
  List<FarmForgeDataTableColumn> _columns;
  List<InventoryDTO> _inventory = [];

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
        propertyFunc: (InventoryDTO s) => 
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () { print('Providing options'); },
          )
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