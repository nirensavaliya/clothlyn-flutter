class EmployeeLoginResponse {
  final String status;
  final String message;
  final EmployeeLoginData data;

  EmployeeLoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EmployeeLoginResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeLoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: EmployeeLoginData.fromJson(json['data'] ?? {}),
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

class EmployeeLoginData {
  final EmployeeUser user;
  final String token;

  EmployeeLoginData({
    required this.user,
    required this.token,
  });

  factory EmployeeLoginData.fromJson(Map<String, dynamic> json) {
    return EmployeeLoginData(
      user: EmployeeUser.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user.toJson(),
      "token": token,
    };
  }
}

class EmployeeUser {
  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String phoneNumber;
  final String employeeRole;
  final String status;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Role> role;
  final List<dynamic> scanPermission;
  final Machine machine;

  EmployeeUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    required this.employeeRole,
    required this.status,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.scanPermission,
    required this.machine,
  });

  factory EmployeeUser.fromJson(Map<String, dynamic> json) {
    return EmployeeUser(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      employeeRole: json['employeeRole'] ?? '',
      status: json['status'] ?? '',
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      role: (json['role'] as List<dynamic>? ?? [])
          .map((e) => Role.fromJson(e))
          .toList(),
      scanPermission: json['scanPermission'] ?? [],
      machine: Machine.fromJson(json['machine'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstName": firstName,
      "lastName": lastName,
      "nickname": nickname,
      "email": email,
      "phoneNumber": phoneNumber,
      "employeeRole": employeeRole,
      "status": status,
      "lastLogin": lastLogin?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "role": role.map((e) => e.toJson()).toList(),
      "scanPermission": scanPermission,
      "machine": machine.toJson(),
    };
  }
}

class Role {
  final String id;
  final String processName;

  Role({
    required this.id,
    required this.processName,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['_id'] ?? '',
      processName: json['processName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "processName": processName,
    };
  }
}

class Machine {
  Machine();

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine();
  }

  Map<String, dynamic> toJson() => {};
}