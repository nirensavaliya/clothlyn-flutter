// class SalarySummaryModel {
//   bool? success;
//   String? message;
//   List<SalaryData>? data;
//
//   SalarySummaryModel({this.success, this.message, this.data});
//
//   SalarySummaryModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <SalaryData>[];
//       json['data'].forEach((v) {
//         data!.add(SalaryData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> dataMap = {};
//     dataMap['success'] = success;
//     dataMap['message'] = message;
//     if (data != null) {
//       dataMap['data'] = data!.map((v) => v.toJson()).toList();
//     }
//     return dataMap;
//   }
// }
//
// class SalaryData {
//   String? employeeId;
//   String? employeeName;
//   String? firstName;
//   String? lastName;
//   String? nickname;
//   String? email;
//   String? mobileNumber;
//   String? profileImage;
//   List<String>? processNames;
//   double? totalSalary;
//   double? totalUpad;
//   double? totalPaid;
//   double? finalSalary;
//   double? availableAmount;
//   Employee? employee;
//
//   SalaryData({
//     this.employeeId,
//     this.employeeName,
//     this.firstName,
//     this.lastName,
//     this.nickname,
//     this.email,
//     this.mobileNumber,
//     this.profileImage,
//     this.processNames,
//     this.totalSalary,
//     this.totalUpad,
//     this.totalPaid,
//     this.finalSalary,
//     this.availableAmount,
//     this.employee,
//   });
//
//   SalaryData.fromJson(Map<String, dynamic> json) {
//     employeeId = json['employeeId'];
//     employeeName = json['employeeName'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     nickname = json['nickname'];
//     email = json['email'];
//     mobileNumber = json['mobileNumber'];
//     profileImage = json['profileImage'];
//     processNames = json['processNames']?.cast<String>();
//     totalSalary = (json['totalSalary'] ?? 0).toDouble();
//     totalUpad = (json['totalUpad'] ?? 0).toDouble();
//     totalPaid = (json['totalPaid'] ?? 0).toDouble();
//     finalSalary = (json['finalSalary'] ?? 0).toDouble();
//     availableAmount = (json['availableAmount'] ?? 0).toDouble();
//     employee =
//     json['employee'] != null ? Employee.fromJson(json['employee']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> dataMap = {};
//     dataMap['employeeId'] = employeeId;
//     dataMap['employeeName'] = employeeName;
//     dataMap['firstName'] = firstName;
//     dataMap['lastName'] = lastName;
//     dataMap['nickname'] = nickname;
//     dataMap['email'] = email;
//     dataMap['mobileNumber'] = mobileNumber;
//     dataMap['profileImage'] = profileImage;
//     dataMap['processNames'] = processNames;
//     dataMap['totalSalary'] = totalSalary;
//     dataMap['totalUpad'] = totalUpad;
//     dataMap['totalPaid'] = totalPaid;
//     dataMap['finalSalary'] = finalSalary;
//     dataMap['availableAmount'] = availableAmount;
//     if (employee != null) {
//       dataMap['employee'] = employee!.toJson();
//     }
//     return dataMap;
//   }
// }
//
// class Employee {
//   String? sId;
//   String? employeeName;
//   String? firstName;
//   String? lastName;
//   String? nickname;
//   String? email;
//   String? adharNumber;
//   String? adharCardFront;
//   String? adharCardBack;
//   String? mobileNumber;
//   String? referenceName;
//   String? referenceMobileNumber;
//   String? accountNumber;
//   String? accountHolderName;
//   String? ifscCode;
//   String? bankName;
//   String? bankBranchName;
//   List<Role>? role;
//   List<String>? scanPermission;
//   List<String>? employeeRole;
//   List<String>? machine;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//
//   Employee({
//     this.sId,
//     this.employeeName,
//     this.firstName,
//     this.lastName,
//     this.nickname,
//     this.email,
//     this.adharNumber,
//     this.adharCardFront,
//     this.adharCardBack,
//     this.mobileNumber,
//     this.referenceName,
//     this.referenceMobileNumber,
//     this.accountNumber,
//     this.accountHolderName,
//     this.ifscCode,
//     this.bankName,
//     this.bankBranchName,
//     this.role,
//     this.scanPermission,
//     this.employeeRole,
//     this.machine,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Employee.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     employeeName = json['employeeName'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     nickname = json['nickname'];
//     email = json['email'];
//     adharNumber = json['adharNumber'];
//     adharCardFront = json['adharCardFront'];
//     adharCardBack = json['adharCardBack'];
//     mobileNumber = json['mobileNumber'];
//     referenceName = json['referenceName'];
//     referenceMobileNumber = json['referenceMobileNumber'];
//     accountNumber = json['accountNumber'];
//     accountHolderName = json['accountHolderName'];
//     ifscCode = json['ifscCode'];
//     bankName = json['bankName'];
//     bankBranchName = json['bankBranchName'];
//
//     if (json['role'] != null) {
//       role = <Role>[];
//       json['role'].forEach((v) {
//         role!.add(Role.fromJson(v));
//       });
//     }
//
//     scanPermission = json['```scanPermission```']?.cast<String>();
//     employeeRole = json['employeeRole']?.cast<String>();
//     machine = json['machine']?.cast<String>();
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> dataMap = {};
//     dataMap['_id'] = sId;
//     dataMap['employeeName'] = employeeName;
//     dataMap['firstName'] = firstName;
//     dataMap['lastName'] = lastName;
//     dataMap['nickname'] = nickname;
//     dataMap['email'] = email;
//     dataMap['adharNumber'] = adharNumber;
//     dataMap['adharCardFront'] = adharCardFront;
//     dataMap['adharCardBack'] = adharCardBack;
//     dataMap['mobileNumber'] = mobileNumber;
//     dataMap['referenceName'] = referenceName;
//     dataMap['referenceMobileNumber'] = referenceMobileNumber;
//     dataMap['accountNumber'] = accountNumber;
//     dataMap['accountHolderName'] = accountHolderName;
//     dataMap['ifscCode'] = ifscCode;
//     dataMap['bankName'] = bankName;
//     dataMap['bankBranchName'] = bankBranchName;
//     if (role != null) {
//       dataMap['role'] = role!.map((v) => v.toJson()).toList();
//     }
//     dataMap['scanPermission'] = scanPermission;
//     dataMap['employeeRole'] = employeeRole;
//     dataMap['machine'] = machine;
//     dataMap['status'] = status;
//     dataMap['createdAt'] = createdAt;
//     dataMap['updatedAt'] = updatedAt;
//     return dataMap;
//   }
// }
//
// class Role {
//   String? sId;
//   String? processName;
//   String? userId;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//
//   Role({
//     this.sId,
//     this.processName,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   Role.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     processName = json['processName'];
//     userId = json['userId'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     v = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> dataMap = {};
//     dataMap['_id'] = sId;
//     dataMap['processName'] = processName;
//     dataMap['userId'] = userId;
//     dataMap['createdAt'] = createdAt;
//     dataMap['updatedAt'] = updatedAt;
//     dataMap['__v'] = v;
//     return dataMap;
//   }
// }

class SalarySummaryModel {
  final bool success;
  final String message;
  final List<SalaryData> data;
  final Pagination pagination;
  final Summary summary;

  SalarySummaryModel({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    required this.summary,
  });

  factory SalarySummaryModel.fromJson(Map<String, dynamic> json) {
    return SalarySummaryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => SalaryData.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      summary: Summary.fromJson(json['summary'] ?? {}),
    );
  }
}

class SalaryData {
  final String employeeId;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String mobileNumber;
  final String? profileImage;
  final List<String> processNames;

  /// New salary-master fields (Sep 22 API)
  final double totalRemainingAmount;
  final double currentPeriodSalary;
  final double lastPeriodSalary;
  final double upadPaid;
  final double paySalary;
  final double bonusPaid;
  final double salaryPaid;

  /// Legacy fields (kept for older responses / detail screens)
  final double totalSalary;
  final double currentTotalSalary;
  final double pendingFromLastClosedHalf;
  final double totalPaid;
  final double netSalary;

  final bool isHalfMonthSalary;
  final Employee employee;

  SalaryData({
    required this.employeeId,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    required this.mobileNumber,
    this.profileImage,
    required this.processNames,
    required this.totalRemainingAmount,
    required this.currentPeriodSalary,
    required this.lastPeriodSalary,
    required this.upadPaid,
    required this.paySalary,
    required this.bonusPaid,
    required this.salaryPaid,
    required this.totalSalary,
    required this.currentTotalSalary,
    required this.pendingFromLastClosedHalf,
    required this.totalPaid,
    required this.netSalary,
    required this.isHalfMonthSalary,
    required this.employee,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    double numOf(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;

    final lastPeriod = numOf(
      json['lastPeriodSalary'] ?? json['pendingFromLastClosedHalf'],
    );
    final currentPeriod = numOf(
      json['currentPeriodSalary'] ?? json['currentTotalSalary'],
    );
    final upad = numOf(json['upadPaid']);
    final bonus = numOf(json['bonusPaid']);
    final salaryPd = numOf(json['salaryPaid']);
    final totalPd = numOf(json['totalPaid']);

    final computedPay =
        (lastPeriod + bonus - (salaryPd > 0 ? salaryPd : totalPd) - upad)
            .clamp(0, double.infinity)
            .toDouble();
    final pay = json['paySalary'] != null ? numOf(json['paySalary']) : computedPay;
    final remaining = json['totalRemainingAmount'] != null
        ? numOf(json['totalRemainingAmount'])
        : (pay + currentPeriod);

    return SalaryData(
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImage: json['profileImage'],
      processNames:
          (json['processNames'] as List? ?? []).map((e) => e.toString()).toList(),
      totalRemainingAmount: remaining,
      currentPeriodSalary: currentPeriod,
      lastPeriodSalary: lastPeriod,
      upadPaid: upad,
      paySalary: pay,
      bonusPaid: bonus,
      salaryPaid: salaryPd > 0 ? salaryPd : totalPd,
      totalSalary: numOf(json['totalSalary']),
      currentTotalSalary: currentPeriod,
      pendingFromLastClosedHalf: lastPeriod,
      totalPaid: totalPd,
      netSalary: remaining,
      isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
      employee: Employee.fromJson(json['employee'] ?? {}),
    );
  }
}

class Employee {
  final String id;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String mobileNumber;

  final String? adharNumber;
  final String? accountNumber;

  final List<String> processNames;
  final List<String> machineNames;

  final bool isHalfMonthSalary;
  final String status;
  final DateTime? createdAt;
  final String? ifscCode;
  final String? bankName;
  final String? bankBranchName;
  final String? accountHolderName;

  Employee({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    required this.mobileNumber,
    this.adharNumber,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.bankBranchName,
    required this.processNames,
    required this.machineNames,
    required this.isHalfMonthSalary,
    required this.status,
    this.createdAt,
    this.accountHolderName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] ?? '',
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      adharNumber: json['adharNumber'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      bankName: json['bankName'],
      bankBranchName: json['bankBranchName'],
      processNames: (json['processNames'] as List? ?? []).map((e) => e.toString()).toList(),
      machineNames: (json['machineNames'] as List? ?? []).map((e) => e.toString()).toList(),
      isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      accountHolderName: json['accountHolderName'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      pageSize: json['pageSize'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class Summary {
  final int totalEmployees;
  final double totalSalarySum;
  final double currentTotalSalarySum;
  final double pendingFromLastClosedHalfSum;
  final double totalPaidSum;
  final double totalNetSalarySum;

  Summary({
    required this.totalEmployees,
    required this.totalSalarySum,
    required this.currentTotalSalarySum,
    required this.pendingFromLastClosedHalfSum,
    required this.totalPaidSum,
    required this.totalNetSalarySum,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalEmployees: json['totalEmployees'] ?? 0,
      totalSalarySum: (json['totalSalarySum'] ?? 0).toDouble(),
      currentTotalSalarySum:
      (json['currentTotalSalarySum'] ?? 0).toDouble(),
      pendingFromLastClosedHalfSum:
      (json['pendingFromLastClosedHalfSum'] ?? 0).toDouble(),
      totalPaidSum: (json['totalPaidSum'] ?? 0).toDouble(),
      totalNetSalarySum: (json['totalNetSalarySum'] ?? 0).toDouble(),
    );
  }
}