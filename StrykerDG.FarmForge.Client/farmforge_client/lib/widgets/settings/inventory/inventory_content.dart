import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/suppliers/supplier.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/settings/inventory/add_product_category.dart';
import 'package:farmforge_client/widgets/settings/inventory/add_product_type.dart';
import 'package:farmforge_client/widgets/settings/inventory/add_supplier.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class InventoryContent extends StatefulWidget {
  @override
  _InventoryContentState createState() => _InventoryContentState();
}

class _InventoryContentState extends State<InventoryContent> {
  List<ProductType> _productTypes = [];
  List<ProductCategory> _productCategories = [];
  List<Supplier> _suppliers = [];
  List<DropdownMenuItem<int>> _supplierOptions = [];
  List<DropdownMenuItem<int>> _categoryOptions = [];
  List<DropdownMenuItem<int>> _typeOptions = [];
  int _selectedProductType;
  int _selectedProductCategory;
  int _selectedSupplier;

  void handleSupplierSelection(int newValue) {
    setState(() {
      _selectedSupplier = newValue;
    });
  }

  void handleDeleteSupplier() {
    
  }

  void handleAddSupplier() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Supplier',
        content: AddSupplier(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  void handleProductCategorySelection(int newValue) {
    setState(() {
      _selectedProductCategory = newValue;
    });
  }

  void handleDeleteProductCategory() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteProductCategory(_selectedProductCategory);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteProductCategory(_selectedProductCategory);

        setState(() {
          _selectedProductCategory = null;
        });
      }
      else
        throw deleteResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Delete Error', 
        error: e.toString()
      );
    }
  }

  void handleAddProductCategory() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Product Category',
        content: AddProductCategory(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  void handleProductTypeSelection(int newValue) {
    setState(() {
      _selectedProductType = newValue;
    });
  }

  void handleDeleteProductType() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteProductType(_selectedProductType);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteProductType(_selectedProductType);

        setState(() {
          _selectedProductType = null;
        });
      }
      else
        throw deleteResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Delete Error', 
        error: e.toString()
      );
    }
  }

  void handleAddProductType() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Product Type',
        content: AddProductType(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  Widget getSupplierContent() {
    Function supplierDeleteAction = _selectedSupplier == null
      ? null
      : handleDeleteSupplier;

    return Padding(
      padding: EdgeInsets.all(kSmallPadding),
      child: Wrap(
        children: [
          Container(
            width: kStandardInput,
            child: DropdownButtonFormField<int>(
              value: _selectedSupplier,
              items: _supplierOptions,
              onChanged: handleSupplierSelection,
              decoration: (InputDecoration(
                labelText: 'Supplier'
              )),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: supplierDeleteAction,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: handleAddSupplier
          )
        ],
      ),
    );
  }

  Widget getCategoryContent() {
    Function categoryDeleteAction = _selectedProductCategory == null
      ? null
      : handleDeleteProductCategory;

    return Padding(
      padding: EdgeInsets.all(kSmallPadding),
      child: Wrap(
        children: [
          Container(
            width: kStandardInput,
            child: DropdownButtonFormField<int>(
              value: _selectedProductCategory,
              items: _categoryOptions,
              onChanged: handleProductCategorySelection,
              decoration: (InputDecoration(
                labelText: 'Product Category'
              )),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: categoryDeleteAction,
          ),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: handleAddProductCategory
          )
        ],
      ),
    );
  }

  Widget getTypeContent() {
    Function typeDeleteAction = _selectedProductType == null
      ? null
      : handleDeleteProductType;

    return Padding(
      padding: EdgeInsets.all(kSmallPadding),
      child: Wrap(
        children: [
          Container(
            width: kStandardInput,
            child: DropdownButtonFormField<int>(
              value: _selectedProductType,
              items: _typeOptions,
              onChanged: handleProductTypeSelection,
              decoration: (InputDecoration(
                labelText: 'Product Type'
              )),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: typeDeleteAction,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: handleAddProductType
          )
        ],
      )
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _suppliers = Provider.of<DataProvider>(context).suppliers;
      _productCategories = Provider.of<DataProvider>(context).productCategories;
      _productTypes = Provider.of<DataProvider>(context).productTypes;

      _supplierOptions = _suppliers.map((supplier) => 
        DropdownMenuItem<int>(
          value: supplier.supplierId,
          child: Text(supplier.name),
        )
      ).toList();

      _categoryOptions = _productCategories.map((category) => 
        DropdownMenuItem<int>(
          value: category.productCategoryId,
          child: Text(category.label),
        )
      ).toList();

      _typeOptions = _productTypes.map((type) => 
        DropdownMenuItem<int>(
          value: type.productTypeId,
          child: Text(type.label),
        )
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget supplierContent = getSupplierContent();
    Widget categoryContent = getCategoryContent();
    Widget typeContent = getTypeContent();

    return Column(
      children: [
        supplierContent,
        categoryContent,
        typeContent,
      ],
    );
  }
}