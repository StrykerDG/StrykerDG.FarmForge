import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_classification.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/general/log_type.dart';
import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/models/general/crop_log.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/general/user.dart';
import 'package:farmforge_client/models/dto/inventory_dto.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';
import 'package:farmforge_client/models/suppliers/supplier.dart';

class DataProvider extends ChangeNotifier {
  DateTime defaultDate = DateTime.now().subtract(Duration(days: 60));
  List<Crop> crops = [];
  List<CropType> cropTypes = [];
  List<CropClassification> cropClassifications = [];
  List<InventoryDTO> inventory = [];
  List<Location> locations = [];
  List<LogType> logTypes = [];
  List<ProductType> productTypes = [];
  List<ProductCategory> productCategories = [];
  List<Status> statuses = [];
  List<Supplier> suppliers = [];
  List<UnitType> unitTypes = [];
  List<User> users = [];

  // Crops
  void setCrops(List<dynamic> newCrops) {
    crops.clear();
    newCrops.forEach((cropData) { 
      crops.add(Crop.fromMap(cropData));
    });
    notifyListeners();
  }

  void addCrop(Map<String, dynamic> newCrop) {
    crops.add(Crop.fromMap(newCrop));
    notifyListeners();
  }

  void setCropTypes(List<dynamic> newCropTypes) {
    cropTypes.clear();
    newCropTypes.forEach((cropTypeData) { 
      cropTypes.add(CropType.fromMap(cropTypeData));
    });
    notifyListeners();
  }

  void addCropType(Map<String, dynamic> newType) {
    cropTypes.add(CropType.fromMap(newType));
    notifyListeners();
  }

  void addCropTypeVariety(int cropTypeId, Map<String, dynamic> varietyData) {
    CropVariety newVariety = CropVariety.fromMap(varietyData);
    cropTypes.firstWhere(
      (t) => t.cropTypeId == cropTypeId,
      orElse: () => null
    )?.varieties?.add(newVariety);
    notifyListeners();
  }

  void deleteCropTypVariety(int cropTypeId, int varietyId) {
    cropTypes.firstWhere(
      (t) => t.cropTypeId == cropTypeId,
      orElse: () => null
    )
    ?.varieties
    ?.removeWhere(
      (v) => v.cropVarietyId == varietyId
    );
    notifyListeners();
  }

  void deleteCropType(int id) {
    cropTypes.removeWhere((c) => c.cropTypeId == id);
    notifyListeners();
  }

  void setCropClassifications(List<dynamic> newClassifications) {
    cropClassifications.clear();
    newClassifications.forEach((classificationData) {
      cropClassifications.add(CropClassification.fromMap(classificationData));
    });
    notifyListeners();
  }

  void addLogToCrop(Map<String, dynamic> log) {
    CropLog newLog = CropLog.fromMap(log);
    crops.firstWhere(
      (c) => c.cropId == newLog.cropId,
      orElse: () => null
    )?.logs?.add(newLog);
    notifyListeners();
  }

  void updateCrop(Map<String, dynamic> newCrop) {
    Crop updatedCrop = Crop.fromMap(newCrop);
    int index = -1;
    
    for(int i = 0; i < crops.length; i++) {
      if(crops[i].cropId == updatedCrop.cropId) {
        index = i;
        break;
      }
    }

    if(index >= 0) {
      crops[index] = updatedCrop;
      notifyListeners();
    }
  }

  void updateCropStatus(int cropId, int newStatusId) {
    Status newStatus = statuses
      .firstWhere(
        (s) => s.statusId == newStatusId,
        orElse: () => null
      );

    if(newStatus != null) {
      crops.firstWhere(
        (c) => c.cropId == cropId,
        orElse: () => null
      )?.statusId = newStatusId;

      crops.firstWhere(
        (c) => c.cropId == cropId,
        orElse: () => null
      )?.status = newStatus;
      notifyListeners();
    }    
  }

  void updateCropLocation(int cropId, int newLocationId) {
    Location newLocation = locations
      .firstWhere(
        (l) => l.locationId == newLocationId,
        orElse: () => null
      );

      if(newLocation != null) {
        crops.firstWhere(
          (c) => c.cropId == cropId,
          orElse: () => null
        )?.locationId = newLocationId;

        crops.firstWhere(
          (c) => c.cropId == cropId,
          orElse: () => null
        )?.location = newLocation;
        notifyListeners();
      }
  }

  // Locations
  void setLocations(List<dynamic> newLocations) {
    locations.clear();
    newLocations.forEach((locationData) { 
      locations.add(Location.fromMap(locationData));
    });
    notifyListeners();
  }

  void addLocation(dynamic newLocation) {
    locations.add(Location.fromMap(newLocation));
    notifyListeners();
  }

  void updateLocation(dynamic location) {
    Location locationToUpdate = Location.fromMap(location);

    int locationIndex = locations.indexWhere(
      (l) => l.locationId == locationToUpdate.locationId,
    );

    if(locationIndex != -1) {
      locations[locationIndex] = locationToUpdate;
      notifyListeners();
    }
  }

  void deleteLocation(int id) {
    locations.removeWhere((l) => l.locationId == id);
    notifyListeners();
  }

  // Log Types
  void setLogTypes(List<dynamic> newLogTypes) {
    logTypes.clear();
    newLogTypes.forEach((logTypeData) { 
      logTypes.add(LogType.fromMap(logTypeData));
    });
    notifyListeners();
  }

  // Statuses
  void setStatuses(List<dynamic> newStatuses) {
    statuses.clear();
    newStatuses.forEach((statusData) {
      statuses.add(Status.fromMap(statusData));
    });
    notifyListeners();
  }

  // Users
  void setUsers(List<dynamic> newUsers) {
    users.clear();
    newUsers.forEach((userData) { 
      users.add(User.fromMap(userData));
    });
    notifyListeners();
  }

  void addUser(dynamic newUser) {
    users.add(User.fromMap(newUser));
    notifyListeners();
  }

  void deleteUser(int id) {
    users.removeWhere((u) => u.userId == id);
    notifyListeners();
  }

  // Inventory
  void setUnitTypes(List<dynamic> newUnitTypes) {
    unitTypes.clear();
    newUnitTypes.forEach((unitData) { 
      unitTypes.add(UnitType.fromMap(unitData));
    });
    notifyListeners();
  }

  void setInventory(List<dynamic> newInventory) {
    inventory.clear();
    newInventory.forEach((inventoryData) { 
      inventory.add(InventoryDTO.fromMap(inventoryData));
    });
    notifyListeners();
  }

  void setProductTypes(List<dynamic> newProductTypes) {
    productTypes.clear();
    newProductTypes.forEach((productData) { 
      productTypes.add(ProductType.fromMap(productData));
    });
    notifyListeners();
  }

  void addProductType(dynamic newType) {
    productTypes.add(ProductType.fromMap(newType));
    notifyListeners();
  }

  void updateProductType(dynamic updatedType) {
    ProductType typeToUpdate = ProductType.fromMap(updatedType);

    int typeIndex = productTypes.indexWhere(
      (pt) => pt.productTypeId == typeToUpdate.productTypeId,
    );

    if(typeIndex != -1) {
      productTypes[typeIndex] = typeToUpdate;
      notifyListeners();
    }
  }

  void deleteProductType(int id) {
    productTypes.removeWhere((t) => t.productTypeId == id);
    notifyListeners();
  }

  void setProductCategories(List<dynamic> newProductCategories) {
    productCategories.clear();
    newProductCategories.forEach((categoryData) {
      productCategories.add(ProductCategory.fromMap(categoryData));
    });
    notifyListeners();
  }

  void addProductCategory(dynamic newCategory) {
    productCategories.add(ProductCategory.fromMap(newCategory));
    notifyListeners();
  }

  void deleteProductCategory(int id) {
    productCategories.removeWhere((c) => c.productCategoryId == id);
    notifyListeners();
  }

  void setSupliers(List<dynamic> newSuppliers) {
    suppliers.clear();
    newSuppliers.forEach((supplierData) { 
      suppliers.add(Supplier.fromMap(supplierData));
    });
    notifyListeners();
  }

  void addSupplier(dynamic newSupplier) {
    suppliers.add(Supplier.fromMap(newSupplier));
    notifyListeners();
  }

  void updateSupplier(dynamic updatedSupplier) {
    Supplier supplierToUpdate = Supplier.fromMap(updatedSupplier);

    int supplierIndex = suppliers.indexWhere(
      (s) => s.supplierId == supplierToUpdate.supplierId,
    );

    if(supplierIndex != -1) {
      suppliers[supplierIndex] = supplierToUpdate;
      notifyListeners();
    }
  }

  void deleteSupplier(int id) {
    suppliers.removeWhere((s) => s.supplierId == id);
    notifyListeners();
  }
}