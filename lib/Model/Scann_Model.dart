class ScanProcessModel {
  final String status;
  final List<ScannData> data;

  ScanProcessModel({
    required this.status,
    required this.data,
  });

  factory ScanProcessModel.fromJson(Map<String, dynamic> json) {
    return ScanProcessModel(
      status: json['status'] ?? '',
      data: (json['data'] as List)
          .map((e) => ScannData.fromJson(e))
          .toList(),
    );
  }
}

class ScannData {
  final String id;
  final String processName;
  final UserModel? userId;
  final String createdAt;
  final String updatedAt;

  ScannData({
    required this.id,
    required this.processName,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScannData.fromJson(Map<String, dynamic> json) {
    return ScannData(
      id: json['_id'] ?? '',
      processName: json['processName'] ?? '',
      userId:
      json['userId'] != null ? UserModel.fromJson(json['userId']) : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String clientCode;
  final String username;
  final String phoneNumber;
  final String status;
  final String accountRole;
  final String company;

  UserModel({
    required this.id,
    required this.clientCode,
    required this.username,
    required this.phoneNumber,
    required this.status,
    required this.accountRole,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      clientCode: json['clientCode'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      accountRole: json['accountRole'] ?? '',
      company: json['company'] ?? '',
    );
  }
}