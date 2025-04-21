class GetUnit {
  final double cropUnitArea;
  final String cropUnitMeasure;

  GetUnit({
    required this.cropUnitArea,
    required this.cropUnitMeasure,
  });

  factory GetUnit.fromJson(Map<String, dynamic> json) {
    return GetUnit(
      cropUnitArea: double.tryParse(json['cropunitarea'].toString()) ?? 0.0,
      cropUnitMeasure: json['cropuom'],
    );
  }
}
