class CompanyModel {
  final String name;

  CompanyModel({required this.name});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json["company_name"] ?? "Testing Cloud Database",
    );
  }
}