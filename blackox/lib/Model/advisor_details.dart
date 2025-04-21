class AdvisorDetails {
  final String name;
  final String address;
  final String mobile;
  final String email;
  final String pincode;
  final String country;
  final String state;
  final String city;
  final String area;
  final String license;
  final String workingDays;
  final String timeSlots;
  final String imageURL;
  final int advisorID;
  final String companyName;
  final String designation;
  final String gender;
  final DateTime dateOfBirth;
  final String password;
  final String website;

  AdvisorDetails({
    required this.name,
    required this.address,
    required this.mobile,
    required this.email,
    required this.pincode,
    required this.country,
    required this.state,
    required this.city,
    required this.area,
    required this.license,
    required this.workingDays,
    required this.timeSlots,
    required this.imageURL,
    required this.advisorID,
    required this.companyName,
    required this.gender,
    required this.designation,
    required this.dateOfBirth,
    required this.password,
    required this.website,
  });
  factory AdvisorDetails.fromJson(Map<String, dynamic> json) {
    return AdvisorDetails(
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      license: json['license']?.toString() ?? '',
      workingDays: json['working_days']?.toString() ?? '',
      timeSlots: json['timeslot']?.toString() ?? '',
      imageURL: json['image_url']?.toString() ?? '',
      advisorID: int.tryParse(json['advisor_id']?.toString() ?? '0') ?? 0,
      companyName: json['company_name']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth: DateTime.tryParse(json['date_of_birth']?.toString() ?? '') ??
          DateTime.now(),
      password: json['password']?.toString() ?? '',
      website: json['website_url']?.toString() ?? '',
    );
  }
}
