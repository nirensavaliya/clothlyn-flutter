class EmployeeResponse {
  String? status;
  List<EmployeeData>? data;
  Pagination? pagination;

  EmployeeResponse({this.status, this.data, this.pagination});

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) => EmployeeResponse(
    status: json['status'] as String?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => EmployeeData.fromJson(e as Map<String, dynamic>))
        .toList(),
    pagination: json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.map((e) => e.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

class EmployeeData {
  String? id;
  String? employeeName;
  String? firstName;
  String? lastName;
  String? nickname;
  String? email;
  String? adharNumber;
  String? adharCardFront;
  String? adharCardBack;
  String? mobileNumber;
  String? referenceName;
  String? referenceMobileNumber;
  String? accountNumber;
  String? accountHolderName;
  String? ifscCode;
  String? bankName;
  String? bankBranchName;
  List<Role>? role;
  List<dynamic>? scanPermission;
  List<String>? employeeRole;
  List<Machine>? machine;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<String>? processNames;
  List<dynamic>? scanPermissionNames;
  List<String>? machineNames;

  EmployeeData({
    this.id,
    this.employeeName,
    this.firstName,
    this.lastName,
    this.nickname,
    this.email,
    this.adharNumber,
    this.adharCardFront,
    this.adharCardBack,
    this.mobileNumber,
    this.referenceName,
    this.referenceMobileNumber,
    this.accountNumber,
    this.accountHolderName,
    this.ifscCode,
    this.bankName,
    this.bankBranchName,
    this.role,
    this.scanPermission,
    this.employeeRole,
    this.machine,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.processNames,
    this.scanPermissionNames,
    this.machineNames,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    id: json['_id'] as String?,
    employeeName: json['employeeName'] as String?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    nickname: json['nickname'] as String?,
    email: json['email'] as String?,
    adharNumber: json['adharNumber'] as String?,
    adharCardFront: json['adharCardFront'] as String?,
    adharCardBack: json['adharCardBack'] as String?,
    mobileNumber: json['mobileNumber'] as String?,
    referenceName: json['referenceName'] as String?,
    referenceMobileNumber: json['referenceMobileNumber'] as String?,
    accountNumber: json['accountNumber'] as String?,
    accountHolderName: json['accountHolderName'] as String?,
    ifscCode: json['ifscCode'] as String?,
    bankName: json['bankName'] as String?,
    bankBranchName: json['bankBranchName'] as String?,
    role: (json['role'] as List<dynamic>?)
        ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
        .toList(),
    scanPermission: json['scanPermission'] as List<dynamic>?,
    employeeRole: (json['employeeRole'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    machine: (json['machine'] as List<dynamic>?)
        ?.map((e) => Machine.fromJson(e as Map<String, dynamic>))
        .toList(),
    status: json['status'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    v: json['__v'] as int?,
    processNames: (json['processNames'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    scanPermissionNames: json['scanPermissionNames'] as List<dynamic>?,
    machineNames: (json['machineNames'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'employeeName': employeeName,
    'firstName': firstName,
    'lastName': lastName,
    'nickname': nickname,
    'email': email,
    'adharNumber': adharNumber,
    'adharCardFront': adharCardFront,
    'adharCardBack': adharCardBack,
    'mobileNumber': mobileNumber,
    'referenceName': referenceName,
    'referenceMobileNumber': referenceMobileNumber,
    'accountNumber': accountNumber,
    'accountHolderName': accountHolderName,
    'ifscCode': ifscCode,
    'bankName': bankName,
    'bankBranchName': bankBranchName,
    'role': role?.map((e) => e.toJson()).toList(),
    'scanPermission': scanPermission,
    'employeeRole': employeeRole,
    'machine': machine?.map((e) => e.toJson()).toList(),
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'processNames': processNames,
    'scanPermissionNames': scanPermissionNames,
    'machineNames': machineNames,
  };
}

class Role {
  String? id;
  String? processName;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Role({
    this.id,
    this.processName,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['_id'] as String?,
    processName: json['processName'] as String?,
    userId: json['userId'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    v: json['__v'] as int?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'processName': processName,
    'userId': userId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

class Machine {
  String? id;
  String? machineName;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Machine({
    this.id,
    this.machineName,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
    id: json['_id'] as String?,
    machineName: json['machineName'] as String?,
    userId: json['userId'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    v: json['__v'] as int?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'machineName': machineName,
    'userId': userId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

class Pagination {
  int? total;
  int? page;
  int? pages;
  int? limit;
  bool? hasPagination;

  Pagination({this.total, this.page, this.pages, this.limit, this.hasPagination});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json['total'] as int?,
    page: json['page'] as int?,
    pages: json['pages'] as int?,
    limit: json['limit'] as int?,
    hasPagination: json['hasPagination'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'pages': pages,
    'limit': limit,
    'hasPagination': hasPagination,
  };
}