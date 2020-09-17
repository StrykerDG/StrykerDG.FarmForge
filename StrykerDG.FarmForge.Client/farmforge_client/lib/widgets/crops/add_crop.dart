import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/provider/core_provider.dart';
import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/constants.dart';
import 'package:provider/provider.dart';

class AddCrop extends StatefulWidget {
  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  String _cropType;
  String _cropVariety;
  String _cropLocation;

  void loadData() async {
    // List<Future<FarmForgeResponse>> requestFutures = [
    //   Provider.of<CoreProvider>(context, listen: false)
    //     .farmForgeService.getCropTypes(includes: 'Varieties'),
    //   Provider.of<CoreProvider>(context, listen: false)
    //     .farmForgeService.getLocations()
    // ];

    // List<FarmForgeResponse> responses = [
    //   await requestFutures[0],
    //   await requestFutures[1]
    // ];

    Future<FarmForgeResponse> cropTypeFuture = Provider.of<CoreProvider>(context, listen: false)
      .farmForgeService.getCropTypes(includes: 'Varieties');
    Future<FarmForgeResponse> locationFuture = Provider.of<CoreProvider>(context, listen: false)
      .farmForgeService.getLocations();
    
    Future.wait([cropTypeFuture, locationFuture])
    .then((value) => 
      value.asMap()
      .forEach((index, response) { 
        print('Index: $index');
        print('Response: ${response.data}');

        // If index = 1 ...
        // If index = 2 ...
      })
    );

    // cropTypeFuture.then((value) => print('value: ${value.data}'));
    // locationFuture.then((value) => print('value: ${value.data}'));

    // Provider.of<CoreProvider>(context, listen: false)
    //   .farmForgeService.getCropTypes(includes: 'Varieties')
    //   .then((value) => print('value: ${value.data}'));
    // Provider.of<CoreProvider>(context, listen: false)
    //   .farmForgeService.getLocations()
    //   .then((value) => print('value: ${value.data}'));


  }

  String isValidQuantity(String value) {
    String result = Validation.isNotEmpty(value);
    if(result == null)
      result = Validation.isNumeric(value);

    return result;
  }

  void handleDatePicker(BuildContext context) async {
    final DateTime chosenDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015, 1), 
      lastDate: DateTime(2100, 12)
    );

    try {
      final String formattedMonth = chosenDate.month > 9
        ? chosenDate.month.toString()
        : '0${chosenDate.month}';

      final String formattedDay = chosenDate.day > 9
        ? chosenDate.day.toString()
        : '0${chosenDate.day}';

      final String formattedDate = '${chosenDate.year}-$formattedMonth-$formattedDay';
      setState(() {
        _dateController.text = formattedDate;
      });
    }
    catch(e) {}
  }

  void handleSave() {
    if(_formKey.currentState.validate()) {
      print('Would be saving');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSmallDesktopModalWidth,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: kLargePadding),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Type
                  DropdownButtonFormField<String>(
                    value: _cropType,
                    onChanged: (String newValue) {
                      setState(() {
                        _cropType = newValue;
                      });
                    },
                    items: <String>["First","second","third"]
                      .map<DropdownMenuItem<String>>((e) => 
                        DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        )
                      ).toList(),
                    validator: Validation.isNotEmpty,
                    decoration: InputDecoration(
                      labelText: "Type"
                    ),
                  ),

                  // Variety
                  DropdownButtonFormField<String>(
                    value: _cropVariety,
                    onChanged: (String newValue) {
                      setState(() {
                        _cropVariety = newValue;
                      });
                    },
                    items: <String>["First","second","third"]
                      .map<DropdownMenuItem<String>>((e) => 
                        DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        )
                      ).toList(),
                    validator: Validation.isNotEmpty,
                    decoration: InputDecoration(
                      labelText: "Variety"
                    ),
                  ),
                  
                  // Location
                  DropdownButtonFormField<String>(
                    value: _cropLocation,
                    onChanged: (String newValue) {
                      setState(() {
                        _cropLocation = newValue;
                      });
                    },
                    items: <String>["First","second","third"]
                      .map<DropdownMenuItem<String>>((e) => 
                        DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        )
                      ).toList(),
                    validator: Validation.isNotEmpty,
                    decoration: InputDecoration(
                      labelText: "Location"
                    ),
                  ),

                  // Plant Date
                  Padding(
                    padding: EdgeInsets.only(top: kSmallPadding),
                    child: TextFormField(
                      onTap: () {
                        handleDatePicker(context);
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Plant Date",
                      ),
                      validator: Validation.isValidDate
                    ),
                  ),

                  // Quantity
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: "Quantity",
                    ),
                    validator: isValidQuantity
                  )
                ],
              ),
            ),

            // Save Button
            RaisedButton(
              onPressed: handleSave,
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}