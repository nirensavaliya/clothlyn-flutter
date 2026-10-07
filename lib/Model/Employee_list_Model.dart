class EmployeeListResponse {
  final String status;
  final List<EmployeeModel> data;
  final Pagination pagination;

  EmployeeListResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class EmployeeModel {
  final String id;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String adharCardFront;
  final String adharCardBack;
  final String adharNumber;
  final String mobileNumber;
  final String referenceName;
  final String referenceMobileNumber;
  final String accountNumber;
  final String accountHolderName;
  final String ifscCode;
  final String bankName;
  final String bankBranchName;
  final List<String> role;
  final List<String> scanPermission;
  final List<String> employeeRole;
  final List<String> machine;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
   String status;
  final List<String> processNames;
  final List<String> scanPermissionNames;
  final List<String> machineNames;

  EmployeeModel({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    required this.adharCardFront,
    required this.adharCardBack,
    required this.adharNumber,
    required this.mobileNumber,
    required this.referenceName,
    required this.referenceMobileNumber,
    required this.accountNumber,
    required this.accountHolderName,
    required this.ifscCode,
    required this.bankName,
    required this.bankBranchName,
    required this.role,
    required this.scanPermission,
    required this.employeeRole,
    required this.machine,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.processNames,
    required this.scanPermissionNames,
    required this.machineNames,
  });

  EmployeeModel copyWith({
    String? id,
    String? employeeName,
    String? firstName,
    String? lastName,
    String? nickname,
    String? email,
    String? adharNumber,
    String? mobileNumber,
    String? referenceName,
    String? referenceMobileNumber,
    String? accountNumber,
    String? accountHolderName,
    String? ifscCode,
    String? bankName,
    String? bankBranchName,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      adharNumber: adharNumber ?? this.adharNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      referenceName: referenceName ?? this.referenceName,
      referenceMobileNumber:
      referenceMobileNumber ?? this.referenceMobileNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      bankBranchName: bankBranchName ?? this.bankBranchName,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      role: role,
      scanPermission: scanPermission,
      employeeRole: employeeRole,
      machine: machine ?? [],
      processNames: processNames ?? [],
      scanPermissionNames: scanPermissionNames ?? [],
      machineNames: machineNames ?? [],
      adharCardFront: adharCardFront, adharCardBack: adharCardBack,
    );
  }
  bool get isActive => status.toLowerCase() == "active";

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['_id'] ?? '',
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      adharCardFront: json['adharCardFront'] ?? '',
      adharCardBack: json['adharCardBack'] ?? '',
      adharNumber: json['adharNumber'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referenceName: json['referenceName'] ?? '',
      referenceMobileNumber: json['referenceMobileNumber'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountHolderName: json['accountHolderName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankBranchName: json['bankBranchName'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      status: json['status'] ?? '',
      role: json['role'] is List
          ? (json['role'] as List)
          .map((e) => e is Map ? e['name']?.toString() ?? '' : e.toString())
          .toList()
          : json['role'] is Map
          ? [json['role']['name']?.toString() ?? '']
          : [],
      scanPermission: json['scanPermission'] is List
          ? (json['scanPermission'] as List)
          .map((e) => e is Map ? e['name']?.toString() ?? '' : e.toString())
          .toList()
          : json['scanPermission'] is Map
          ? [json['scanPermission']['name']?.toString() ?? '']
          : [],
      employeeRole: List<String>.from(json['employeeRole'] ?? []),
      machine: json['machine'] is List
          ? (json['machine'] as List)
          .map((e) => e is Map ? e['name']?.toString() ?? '' : e.toString())
          .toList()
          : json['machine'] is Map
          ? [json['machine']['name']?.toString() ?? '']
          : [],
      processNames: List<String>.from(json['processNames'] ?? []),
      scanPermissionNames:
      List<String>.from(json['scanPermissionNames'] ?? []),
      machineNames: List<String>.from(json['machineNames'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'employeeName': employeeName,
    'firstName': firstName,
    'lastName': lastName,
    'nickname': nickname,
    'email': email,
    'adharNumber': adharNumber,
    'mobileNumber': mobileNumber,
    'referenceName': referenceName,
    'referenceMobileNumber': referenceMobileNumber,
    'accountNumber': accountNumber,
    'accountHolderName': accountHolderName,
    'ifscCode': ifscCode,
    'bankName': bankName,
    'bankBranchName': bankBranchName,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'status': status,
    "processNames": processNames,
    "scanPermissionNames": scanPermissionNames,
    "machineNames": machineNames,
    "role": role,
    "scanPermission": scanPermission,
    "employeeRole": employeeRole,
    "machine": machine,
  };
}

class Pagination {
  final int total;
  final int page;
  final int pages;
  final int limit;

  Pagination({
    required this.total,
    required this.page,
    required this.pages,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'pages': pages,
    'limit': limit,
  };
}