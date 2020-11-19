import 'package:flutter/material.dart';

import 'package:farmforge_client/models/farm_forge_data_table_column.dart';

import 'package:farmforge_client/screens/customers/large_customers.dart';
import 'package:farmforge_client/screens/customers/medium_customers.dart';
import 'package:farmforge_client/screens/customers/small_customers.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

class Customers extends StatefulWidget {
  static const String title = 'Customers';
  static const IconData fabIcon = Icons.add;
  static const Function fabAction = handleAddCustomer;

  static void handleAddCustomer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add new Customer',
        content: Container(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<FarmForgeDataTableColumn> _columns;

  void loadData() async {

  }

  List<FarmForgeDataTableColumn> generateColumns() {
    return [
      FarmForgeDataTableColumn(
        label: 'Name',
        property: 'FullName'
      ),
      FarmForgeDataTableColumn(
        label: 'Company',
        property: 'Company'
      ),
      FarmForgeDataTableColumn(
        label: 'Phone',
        property: 'Phone'
      ),
      FarmForgeDataTableColumn(
        label: 'Email',
        property: 'Email'
      )
    ];
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        
        // We need to use Mediaquery because the constraints is the size of
        // our "Content" width, not the screen 
        double deviceWidth = MediaQuery.of(context).size.width;

        return deviceWidth < kSmallWidthMax
          ? SmallCustomers()
          : deviceWidth <= kMediumWidthMax
            ? MediumCustomers()
            : LargeCustomers();
      },
    );
  }
}