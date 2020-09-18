import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:farmforge_client/screens/base/desktop/base_desktop.dart';

import 'package:farmforge_client/widgets/crops/add_crop.dart';
import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

class DesktopCrops extends StatelessWidget {
  final DateTime searchBegin;
  final DateTime searchEnd;

  DesktopCrops({@required this.searchBegin, this.searchEnd});

  void handleAddCrop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Crop',
        content: AddCrop(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _searchController = TextEditingController();
    String _searchStartString = DateFormat.yMd().format(searchBegin);
    String _searchEndString = DateFormat.yMd().format(searchEnd);

    return BaseDesktop(
      title: 'Crops',
      action: handleAddCrop,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: kSmallPadding),
            child: Row(
              children: [
                // Search box
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
                  child: Container(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search)
                        ),
                      ),
                    )
                  ),
                ),
                // Filter button
                GestureDetector(
                  child: Icon(Icons.filter_list),
                  onTap: () { print('Displaying filter options'); },
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  child: Icon(Icons.calendar_today),
                  onTap: () { print('Displaying calendar options'); },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
                  child: Text('$_searchStartString - $_searchEndString'),
                )
              ],
            ),
          ),
          // Listview
          Center(
            child: Text("List goes here"),
          )
        ],
      )
    );
  }
}