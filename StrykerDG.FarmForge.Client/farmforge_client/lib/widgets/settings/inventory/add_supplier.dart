import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/dto/new_supplier_dto.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/suppliers/supplier.dart';

import 'package:farmforge_client/widgets/multi_select/multi_select_dialog.dart';
import 'package:farmforge_client/widgets/multi_select/multi_select_options.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class AddSupplier extends StatefulWidget {
  final Supplier supplier;

  AddSupplier({this.supplier});

  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ProductType> _productTypes = [];
  List<MultiSelectOption> _productTypeOptions = [];
  List<int> _selectedSupplierProducts = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _supplyController = TextEditingController();

  void loadSupplierProducts() async {
    try {
      FarmForgeResponse suppliedProducts = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getSupplierProducts(widget.supplier?.supplierId);

      if(suppliedProducts.data != null) {
        List<int> suppliedProductIds = [];
        suppliedProducts.data.forEach((productData) {
          suppliedProductIds.add(productData['ProductTypeId']);
        });

        setState(() {
          _selectedSupplierProducts = suppliedProductIds;
          _supplyController.text = '${_selectedSupplierProducts.length} ' +
          ' item(s) selected';
        });
      }
      else
        throw(suppliedProducts.error);
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  void handleMultiSelectTap() async {
    List<int> results = await showDialog(
      context: context,
      builder: (context) => MultiSelectDialog(
        options: _productTypeOptions,
        defaultValues: _selectedSupplierProducts,
      )
    );

    if(results != null)
      setState(() {
        _selectedSupplierProducts = results;
        _supplyController.text = '${_selectedSupplierProducts.length} ' +
          ' item(s) selected';
      });
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        Supplier newSupplier = Supplier(
          supplierId: widget.supplier?.supplierId ?? 0,
          address: _addressController.text,
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text
        );
        
        NewSupplierDTO supplierRequest = NewSupplierDTO(
          supplier: newSupplier,
          productIds: _selectedSupplierProducts
        );

        String method = widget.supplier == null
          ? 'POST'
          : 'PATCH';

        FarmForgeResponse supplierResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createOrUpdateSupplier(supplierRequest, method);

        if(supplierResponse.data != null) {
          if(widget.supplier == null)
            Provider.of<DataProvider>(context, listen: false)
              .addSupplier(supplierResponse.data);
          else 
            Provider.of<DataProvider>(context, listen: false)
              .updateSupplier(supplierResponse.data);

          Navigator.pop(context);
        }
        else
          throw supplierResponse.error;
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

    if(widget.supplier != null) {
      loadSupplierProducts();

      setState(() {
        _nameController.text = widget.supplier.name;
        _addressController.text = widget.supplier.address;
        _phoneController.text = widget.supplier.phone;
        _emailController.text = widget.supplier.email;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _supplyController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _productTypes = Provider.of<DataProvider>(context).productTypes;
      _productTypeOptions = _productTypes.map((t) =>
        MultiSelectOption(value: t.productTypeId, label: t.label)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'
                  ),
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  readOnly: true,
                  controller: _supplyController,
                  onTap: handleMultiSelectTap,
                  decoration: InputDecoration(
                    labelText: 'Supplies...'
                  ),
                ),
              )
            ],
          ),
        ),
        RaisedButton(
          child: Text('Save'),
          onPressed: handleSave
        )
      ],
    );
  }
}