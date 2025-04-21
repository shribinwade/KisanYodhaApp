class BusinessDetails {
  final String? uName;
  final String? uNumber;
  final String? uEmail;
  final String? bName;
  final String? bAddress;
  final int? bPinCode;
  final String? bCity;
  final String? gstNO;
  final String? categoryType;
  final String? productName;
  final int? rate;
  final String? ratePer;
  final String? discountRate;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? registerDate;
  final String? imageUrl;

  BusinessDetails({
     this.uName,
     this.uNumber,
     this.uEmail,
     this.bName,
     this.bAddress,
     this.bPinCode,
     this.bCity,
     this.gstNO,
     this.categoryType,
     this.productName,
     this.rate,
     this.ratePer,
     this.discountRate,
     this.startDate,
     this.endDate,
     this.registerDate,
     this.imageUrl,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      uName: json['u_name']?? '',
      uNumber: json['u_number']?? '',
      uEmail: json['u_email']?? '',
      bName: json['b_name']?? '',
      bAddress: json['b_address']?? '',
      bPinCode: json['b_pincode'] ?? 0,
      bCity: json['b_city']?? '',
      gstNO: json['gstno']?? '',
      categoryType: json['category_type'] ?? '',
      productName: json['product_name'] ?? '',
      rate: json['rate'] ?? 0,
      ratePer: json['rate_per'] ?? '',
      discountRate: json['discount_rate'] ?? '',
      startDate: DateTime.parse(json['start_date']) ?? DateTime.now(),
      endDate: DateTime.parse(json['end_date']) ?? DateTime.now(),
      registerDate: DateTime.parse(json['register_date']) ?? DateTime.now(),
      imageUrl: json['image_url'] ?? '',
    );
  }
}
