class CompanyResponse {
  String? status;
  List<CompanyModel>? data;

  CompanyResponse({this.status, this.data});

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      status: json['status'],
      data: json['data'] != null
          ? List<CompanyModel>.from(
          json['data'].map((x) => CompanyModel.fromJson(x)))
          : [],
    );
  }
}

class CompanyModel {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CompanyModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}