class CropDetails {
  final String cropName;
  final String soilcode;

  CropDetails({
    required this.cropName,
    required this.soilcode,
  });

  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails(
      cropName: json['cropcultivated'],
      soilcode: json['soilcode'],
    );
  }
}
