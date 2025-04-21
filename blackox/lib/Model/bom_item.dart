class BOMItem {
  final String itemCategory;
  final String itemName;
  final int qty;
  final double rate; // Changed to double to support fractional numbers
  final String uom;
  final double totalCost; // Changed to double to support fractional numbers
  final double subsidy; // Changed to double to support fractional numbers

  BOMItem({
    required this.itemCategory,
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.uom,
    required this.totalCost,
    required this.subsidy,
  });

  factory BOMItem.fromJson(Map<String, dynamic> json) {
    return BOMItem(
      itemCategory: json['item_category'],
      itemName: json['item_name'],
      qty: int.tryParse(json['quantity'].toString()) ?? 0,
      rate: double.tryParse(json['rate_per_unit'].toString()) ?? 0.0,
      uom: json['uom'],
      totalCost: double.tryParse(json['total_cost'].toString()) ?? 0.0,
      subsidy: double.tryParse(json['subsidyamount'].toString()) ?? 0.0,
    );
  }
}
