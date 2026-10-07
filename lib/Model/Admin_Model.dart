class AdminModel {
  final String status;
  final String message;
  final AdminData data;

  AdminModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: AdminData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class AdminData {
  final String id;
  final String phoneNumber;
  final String username;
  final String clientCode;
  final String company;
  final String status;
  final List<dynamic> role;
  final DateTime? lastLogin;
  final String accountRole;
  final String token;

  AdminData({
    required this.id,
    required this.phoneNumber,
    required this.username,
    required this.clientCode,
    required this.company,
    required this.status,
    required this.role,
    required this.lastLogin,
    required this.accountRole,
    required this.token,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['_id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['username'] ?? '',
      clientCode: json['clientCode'] ?? '',
      company: json['company'] ?? '',
      status: json['status'] ?? '',
      role: json['role'] ?? [],
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,
      accountRole: json['accountRole'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "phoneNumber": phoneNumber,
      "username": username,
      "clientCode": clientCode,
      "company": company,
      "status": status,
      "role": role,
      "lastLogin": lastLogin?.toIso8601String(),
      "accountRole": accountRole,
      "token": token,
    };
  }
}
