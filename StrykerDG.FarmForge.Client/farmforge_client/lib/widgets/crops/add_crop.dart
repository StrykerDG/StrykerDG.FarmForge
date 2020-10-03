import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/dto/new_crop_dto.dart';

import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';

class AddCrop extends StatefulWidget {
  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Location> _locations = [];
  List<CropType> _cropTypes = [];
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  int _cropType;
  int _cropVariety;
  int _cropLocation;

  void loadData() async {
    try {
      Future<FarmForgeResponse> cropTypeFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getCropTypes(includes: 'Varieties');
      Future<FarmForgeResponse> locationFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getLocations();
      
      Future.wait([cropTypeFuture, locationFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setCropTypes(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
        });
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
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
      firstDate: DateTime(kFirstDateYear, kFirstDateMonth), 
      lastDate: DateTime(kLastDateYear, kLastDateMonth)
    );

    try {
      final String formattedDate = DateTimeUtility.formatDateTime(chosenDate);

      setState(() {
        _dateController.text = formattedDate;
      });
    }
    catch(e) {}
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        NewCropDTO crop = NewCropDTO(
          cropTypeId: _cropType,
          varietyId: _cropVariety,
          locationId: _cropLocation,
          date: DateTime.parse(_dateController.text),
          quantity: int.parse(_quantityController.text)
        );

        FarmForgeResponse result = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createCrop(crop);

        if(result.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addCrop(result.data);

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
  }

  void handleCropTypeSelect(int newValue) {
    setState(() {
      _cropType = newValue;
    });
  }

  void handleVarietySelect(int newValue) {
    setState(() {
      _cropVariety = newValue;
    });
  }

  void handleLocationSelect(int newValue) {
    setState(() {
      _cropLocation = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _cropTypes = Provider.of<DataProvider>(context).cropTypes;
      _locations = Provider.of<DataProvider>(context).locations;
    });
  }

  DropdownButtonFormField<int> getTypeDropdown() {
    List<DropdownMenuItem<int>> cropTypeOptions = _cropTypes.map((ct) => 
      DropdownMenuItem<int>(
        value: ct.cropTypeId,
        child: Text(ct.label),
      )
    ).toList();
    
    return DropdownButtonFormField<int>(
      value: _cropType,
      onChanged: handleCropTypeSelect,
      items: cropTypeOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Type'
      ),
    );
  }

  DropdownButtonFormField<int> getVarietyDropdown() {
    String labelText = _cropType != null
      ? 'Variety'
      : '';

    Widget disabledHint = _cropType != null
      ? null
      : Text('Choose a Type');

    CropType selectedCropType = _cropTypes
      .firstWhere(
        (ct) => ct.cropTypeId == _cropType,
        orElse: () => null
      );

    List<DropdownMenuItem<int>> varieties = selectedCropType?.varieties?.map((v) => 
      DropdownMenuItem<int>(
        value: v.cropVarietyId,
        child: Text(v.label),
      )
    )?.toList();

    return DropdownButtonFormField<int>(
      value: _cropVariety,
      onChanged: handleVarietySelect,
      items: varieties,
      validator: Validation.isNotEmpty,
      disabledHint: disabledHint,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  DropdownButtonFormField<int> getLocationDropdown() {
    List<DropdownMenuItem<int>> locationOptions = _locations.map((l) => 
      DropdownMenuItem<int>(
        value: l.locationId,
        child: Text(l.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _cropLocation,
      onChanged: handleLocationSelect,
      items: locationOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Location'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    DropdownButtonFormField<int> cropTypeDropdown = getTypeDropdown();
    DropdownButtonFormField<int> cropVarietyDropdown = getVarietyDropdown();
    DropdownButtonFormField<int> locationDropdown = getLocationDropdown();

    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              width: kStandardInput,
              child: Column(
                children: [
                  cropTypeDropdown,
                  cropVarietyDropdown,
                  locationDropdown,

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
          ),

          // Save Button
          RaisedButton(
            onPressed: handleSave,
            child: Text("Save"),
          )
        ],
      ),
    );
  }
}