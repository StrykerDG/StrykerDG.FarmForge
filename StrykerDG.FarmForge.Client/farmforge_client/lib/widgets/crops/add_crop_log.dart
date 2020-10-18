import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/general/log_type.dart';
import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/dto/new_crop_log_dto.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddCropLog extends StatefulWidget {
  final Crop crop;

  AddCropLog({@required this.crop});

  @override
  _AddCropLogState createState() => _AddCropLogState();
}

class _AddCropLogState extends State<AddCropLog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<LogType> _logTypes = [];
  List<Status> _cropStatuses = [];
  List<UnitType> _unitTypes = [];
  int _cropStatus;
  int _logType;
  int _unitType;

  TextEditingController _notesController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  void loadData() async {
    try {
      Future<FarmForgeResponse> cropStatusFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService.getStatusesByType('Crop.Status');
      Future<FarmForgeResponse> logTypeFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService.getLogsByType('Crop.Log');
      Future<FarmForgeResponse> unitTypeFuture = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService.getUnitTypes();

      Future.wait([cropStatusFuture, logTypeFuture, unitTypeFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setStatuses(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLogTypes(responses[1].data);
          Provider.of<DataProvider>(context, listen: false)
            .setUnitTypes(responses[2].data);
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

  void handleTypeSelect(int newValue) {
    setState(() {
      _logType = newValue;
    });
  }

  void handleStatusSelect(int newValue) {
    setState(() {
      _cropStatus = newValue;
    });
  }

  void handleUnitSelect(int newValue) {
    setState(() {
      _unitType = newValue;
    });
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        NewCropLogDTO logDTO = NewCropLogDTO(
          cropId: widget.crop.cropId,
          logTypeId: _logType,
          cropStatusId: _cropStatus,
          notes: _notesController.text
        );

        LogType selectedLogType = _logTypes.firstWhere(
          (t) => t.logTypeId == _logType,
          orElse: () => null
        );

        if(selectedLogType?.name == "harvest") {
          logDTO.unitTypeId = _unitType;
          logDTO.quantity = int.parse(_quantityController.text);
        }

        FarmForgeResponse logResult = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createCropLog(logDTO);

        if(logResult.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .addLogToCrop(logResult.data);

          if(widget.crop.statusId != _cropStatus)
            Provider.of<DataProvider>(context, listen: false)
              .updateCropStatus(widget.crop.cropId, _cropStatus);

          Navigator.pop(context);
        }
        else
          throw logResult.error;
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

  @override
  void initState() {
    super.initState();

    _cropStatus = widget.crop.statusId;
    loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _quantityController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _logTypes = Provider.of<DataProvider>(context).logTypes
        .where((lt) => lt.entityType == 'Crop.Log').toList(); 
      _cropStatuses = Provider.of<DataProvider>(context).statuses
        .where((s) => s.entityType == 'Crop.Status').toList();
      _unitTypes = Provider.of<DataProvider>(context).unitTypes;
    });
  }

  DropdownButtonFormField<int> getTypeDropdown() {
    List<DropdownMenuItem<int>> typeOptions = _logTypes.map((t) => 
      DropdownMenuItem<int>(
        value: t.logTypeId,
        child: Text(t.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _logType,
      onChanged: handleTypeSelect,
      items: typeOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Log Type'
      ),
    );
  }

  Container getQuantityTextField() {
    return Container(
      width: kNarrowInput,
      child: Padding(
        padding: EdgeInsets.only(right: kMediumPadding),
        child: TextFormField(
          controller: _quantityController,
          validator: Validation.isNumeric,
          decoration: InputDecoration(
            labelText: 'Quantity'
          ),
        ),
      ),
    );
  }

  Container getUnitDropdown() {
    List<DropdownMenuItem<int>> unitOptions = _unitTypes.map((u) => 
      DropdownMenuItem<int>(
        value: u.unitTypeId,
        child: Text(u.label),
      )
    ).toList();

    return Container(
      width: kStandardInput,
      child: DropdownButtonFormField<int>(
        value: _unitType,
        onChanged: handleUnitSelect,
        items: unitOptions,
        validator: Validation.isNotEmpty,
        decoration: InputDecoration(
          labelText: 'Unit'
        ),
      ),
    );
  }

  DropdownButtonFormField<int> getStatusDropdown() {
    List<DropdownMenuItem<int>> statusOptions = _cropStatuses.map((s) => 
      DropdownMenuItem<int>(
        value: s.statusId,
        child: Text(s.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _cropStatus,
      onChanged: handleStatusSelect,
      items: statusOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Crop Status'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    LogType selectedLogType = _logTypes.firstWhere(
      (t) => t.logTypeId == _logType,
      orElse: () => null
    );

    Widget quantityWidget = Container();
    Widget unitWidget = Container();

    if(selectedLogType?.name == "harvest") {
      quantityWidget = getQuantityTextField();
      unitWidget = getUnitDropdown();
    }

    DropdownButtonFormField<int> logTypeDropdown = getTypeDropdown();
    DropdownButtonFormField<int> statusDropdown = getStatusDropdown();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: kStandardInput,
            child: logTypeDropdown
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              quantityWidget,
              unitWidget
            ],
          ),
          Container(
            width: kStandardInput,
            child: statusDropdown
          ),
          Container(
            padding: EdgeInsets.only(top: kSmallPadding),
            width: kStandardInput,
            child: TextFormField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(
                  //borderSide: BorderSide,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kMediumRadius)
                  )
                )
              ),
            ),
          ),
          RaisedButton(
            child: Text('Save'),
            onPressed: handleSave,
          )
        ],
      ),
    );
  }
}