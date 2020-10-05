class FarmForgeDataTableColumn {
  String label;
  String property;
  Function propertyFunc;
  bool canSort;
  bool canFilter;
  bool canEdit;

  FarmForgeDataTableColumn({
    this.label,
    this.property,
    this.propertyFunc,
    this.canSort = true,
    this.canFilter = true,
    this.canEdit = false
  });
}