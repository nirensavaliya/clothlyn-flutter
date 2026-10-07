class MachineResponseModel {
  List<MachineModel>? data;
  PaginationModel? pagination;

  MachineResponseModel({
    this.data,
    this.pagination,
  });

  factory MachineResponseModel.fromJson(Map<String, dynamic> json) {
    return MachineResponseModel(
      data: json['data'] != null
          ? List<MachineModel>.from(
          json['data'].map((x) => MachineModel.fromJson(x)))
          : [],
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}

class MachineModel {
  String? id;
  String? machineName;
  UserModel? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  MachineModel({
    this.id,
    this.machineName,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      id: json['_id'],
      machineName: json['machineName'],
      userId:
      json['userId'] != null ? UserModel.fromJson(json['userId']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "machineName": machineName,
      "userId": userId,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class UserModel {
  String? id;
  String? username;
  String? phoneNumber;

  UserModel({
    this.id,
    this.username,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class PaginationModel {
  int? total;
  int? page;
  int? totalPages;
  int? limit;

  PaginationModel({
    this.total,
    this.page,
    this.totalPages,
    this.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'],
      page: json['page'],
      totalPages: json['totalPages'],
      limit: json['limit'],
    );
  }
}