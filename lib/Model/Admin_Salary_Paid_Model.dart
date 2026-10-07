class PaidSalaryResponse {
  final String status;
  final SalaryData data;

  PaidSalaryResponse({
    required this.status,
    required this.data,
  });

  factory PaidSalaryResponse.fromJson(Map<String, dynamic> json) {
    return PaidSalaryResponse(
      status: json['status'] ?? '',
      data: SalaryData.fromJson(json['data'] ?? {}),
    );
  }
}

class SalaryData {
  final List<PaidSalaries> paidSalaries;
  final Pagination pagination;

  SalaryData({
    required this.paidSalaries,
    required this.pagination,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    return SalaryData(
      paidSalaries: (json['paidSalaries'] as List? ?? [])
          .map((e) => PaidSalaries.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class PaidSalaries {
  final String id;
  final Employee employee;
  final double paid;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isUpad;
  final String paymentType;
  final DateTime? createdAt;

  PaidSalaries({
    required this.id,
    required this.employee,
    required this.paid,
    this.startDate,
    this.endDate,
    required this.isUpad,
    required this.paymentType,
    this.createdAt,
  });

  factory PaidSalaries.fromJson(Map<String, dynamic> json) {
    final type = (json['paymentType'] ?? '').toString().trim().toLowerCase();
    final isUpad = json['isUpad'] == true || type == 'upad';
    final resolvedType = type.isNotEmpty
        ? type
        : (isUpad ? 'upad' : 'salary');

    return PaidSalaries(
      id: json['_id'] ?? '',
      employee: Employee.fromJson(json['employeeId'] ?? {}),
      paid: (json['paid'] ?? 0).toDouble(),
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      isUpad: isUpad,
      paymentType: resolvedType,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
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
  final String? accountHolderName;

  final String? ifscCode;
  final String? bankName;
  final String? bankBranchName;

  final List<String> machine;
  final List<String> employeeRole;

  final double totalSalary;
  final double totalPaid;
  final double totalUpad;

  final String status;
  final DateTime? createdAt;

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
    this.accountHolderName,
    this.ifscCode,
    this.bankName,
    this.bankBranchName,
    required this.machine,
    required this.employeeRole,
    required this.totalSalary,
    required this.totalPaid,
    required this.totalUpad,
    required this.status,
    this.createdAt,
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
      accountHolderName: json['accountHolderName'],

      ifscCode: json['ifscCode'],
      bankName: json['bankName'],
      bankBranchName: json['bankBranchName'],

      machine:
      (json['machine'] as List? ?? []).map((e) => e.toString()).toList(),

      employeeRole:
      (json['employeeRole'] as List? ?? []).map((e) => e.toString()).toList(),

      totalSalary: (json['totalSalary'] ?? 0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0).toDouble(),
      totalUpad: (json['totalUpad'] ?? 0).toDouble(),

      status: json['status'] ?? '',

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}


class Pagination {
  int? total;
  int? page;
  int? pages;
  int? limit;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination(
      {this.total,
        this.page,
        this.pages,
        this.limit,
        this.hasNextPage,
        this.hasPrevPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pages = json['pages'];
    limit = json['limit'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    data['page'] = page;
    data['pages'] = pages;
    data['limit'] = limit;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    return data;
  }
}

// class PaidSalaryResponse {
//   final bool success;
//   final String message;
//   final List<EmployeeSalaryData> data;
//   final Pagination pagination;
//   final Filters filters;
//   final Summary summary;
//
//   PaidSalaryResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//     required this.pagination,
//     required this.filters,
//     required this.summary,
//   });
//
//   factory PaidSalaryResponse.fromJson(Map<String, dynamic> json) {
//     return PaidSalaryResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: (json['data'] as List? ?? [])
//           .map((e) => EmployeeSalaryData.fromJson(e))
//           .toList(),
//       pagination: Pagination.fromJson(json['pagination'] ?? {}),
//       filters: Filters.fromJson(json['filters'] ?? {}),
//       summary: Summary.fromJson(json['summary'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'success': success,
//     'message': message,
//     'data': data.map((e) => e.toJson()).toList(),
//     'pagination': pagination.toJson(),
//     'filters': filters.toJson(),
//     'summary': summary.toJson(),
//   };
// }
//
// class EmployeeSalaryData {
//   final String employeeId;
//   final String employeeName;
//   final String firstName;
//   final String lastName;
//   final String nickname;
//   final String email;
//   final String mobileNumber;
//   final String? profileImage;
//   final List<String> processNames;
//
//   final double totalSalary;
//   final double currentTotalSalary;
//   final double pendingFromLastClosedHalf;
//   final double totalPaid;
//   final double netSalary;
//
//   final bool isHalfMonthSalary;
//   final Employee employee;
//
//   EmployeeSalaryData({
//     required this.employeeId,
//     required this.employeeName,
//     required this.firstName,
//     required this.lastName,
//     required this.nickname,
//     required this.email,
//     required this.mobileNumber,
//     this.profileImage,
//     required this.processNames,
//     required this.totalSalary,
//     required this.currentTotalSalary,
//     required this.pendingFromLastClosedHalf,
//     required this.totalPaid,
//     required this.netSalary,
//     required this.isHalfMonthSalary,
//     required this.employee,
//   });
//
//   factory EmployeeSalaryData.fromJson(Map<String, dynamic> json) {
//     return EmployeeSalaryData(
//       employeeId: json['employeeId'] ?? '',
//       employeeName: json['employeeName'] ?? '',
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       nickname: json['nickname'] ?? '',
//       email: json['email'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       profileImage: json['profileImage'],
//       processNames: List<String>.from(json['processNames'] ?? []),
//       totalSalary: (json['totalSalary'] ?? 0).toDouble(),
//       currentTotalSalary: (json['currentTotalSalary'] ?? 0).toDouble(),
//       pendingFromLastClosedHalf:
//       (json['pendingFromLastClosedHalf'] ?? 0).toDouble(),
//       totalPaid: (json['totalPaid'] ?? 0).toDouble(),
//       netSalary: (json['netSalary'] ?? 0).toDouble(),
//       isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
//       employee: Employee.fromJson(json['employee'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'employeeId': employeeId,
//     'employeeName': employeeName,
//     'firstName': firstName,
//     'lastName': lastName,
//     'nickname': nickname,
//     'email': email,
//     'mobileNumber': mobileNumber,
//     'profileImage': profileImage,
//     'processNames': processNames,
//     'totalSalary': totalSalary,
//     'currentTotalSalary': currentTotalSalary,
//     'pendingFromLastClosedHalf': pendingFromLastClosedHalf,
//     'totalPaid': totalPaid,
//     'netSalary': netSalary,
//     'isHalfMonthSalary': isHalfMonthSalary,
//     'employee': employee.toJson(),
//   };
// }
//
// class Employee {
//   final String id;
//   final String employeeName;
//   final String firstName;
//   final String lastName;
//   final String nickname;
//   final String email;
//   final String mobileNumber;
//
//   final String? adharNumber;
//   final String? accountNumber;
//   final String? accountHolderName;
//   final String? ifscCode;
//   final String? bankName;
//
//   final List<String> processNames;
//   final List<String> machineNames;
//
//   final double totalSalary;
//   final double currentTotalSalary;
//   final double pendingFromLastClosedHalf;
//   final double totalPaid;
//   final double netSalary;
//
//   final bool isHalfMonthSalary;
//   final String status;
//   final DateTime? createdAt;
//   Employee({
//     required this.id,
//     required this.employeeName,
//     required this.firstName,
//     required this.lastName,
//     required this.nickname,
//     required this.email,
//     required this.mobileNumber,
//     this.adharNumber,
//     this.accountNumber,
//     this.accountHolderName,
//     this.ifscCode,
//     this.bankName,
//     required this.processNames,
//     required this.machineNames,
//     required this.totalSalary,
//     required this.currentTotalSalary,
//     required this.pendingFromLastClosedHalf,
//     required this.totalPaid,
//     required this.netSalary,
//     required this.isHalfMonthSalary,
//     required this.status,
//     required this.createdAt
//   });
//
//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       id: json['_id'] ?? '',
//       employeeName: json['employeeName'] ?? '',
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       nickname: json['nickname'] ?? '',
//       email: json['email'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       adharNumber: json['adharNumber'],
//       accountNumber: json['accountNumber'],
//       accountHolderName: json['accountHolderName'],
//       ifscCode: json['ifscCode'],
//       bankName: json['bankName'],
//       processNames: List<String>.from(json['processNames'] ?? []),
//       machineNames: List<String>.from(json['machineNames'] ?? []),
//       totalSalary: (json['totalSalary'] ?? 0).toDouble(),
//       currentTotalSalary: (json['currentTotalSalary'] ?? 0).toDouble(),
//       pendingFromLastClosedHalf:
//       (json['pendingFromLastClosedHalf'] ?? 0).toDouble(),
//       totalPaid: (json['totalPaid'] ?? 0).toDouble(),
//       netSalary: (json['netSalary'] ?? 0).toDouble(),
//       isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'employeeName': employeeName,
//     'firstName': firstName,
//     'lastName': lastName,
//     'nickname': nickname,
//     'email': email,
//     'mobileNumber': mobileNumber,
//     'adharNumber': adharNumber,
//     'accountNumber': accountNumber,
//     'accountHolderName': accountHolderName,
//     'ifscCode': ifscCode,
//     'bankName': bankName,
//     'processNames': processNames,
//     'machineNames': machineNames,
//     'totalSalary': totalSalary,
//     'currentTotalSalary': currentTotalSalary,
//     'pendingFromLastClosedHalf': pendingFromLastClosedHalf,
//     'totalPaid': totalPaid,
//     'netSalary': netSalary,
//     'isHalfMonthSalary': isHalfMonthSalary,
//     'status': status,
//     'createdAt': createdAt?.toIso8601String(),
//   };
// }
//
// class Pagination {
//   final int currentPage;
//   final int totalPages;
//   final int pageSize;
//   final int totalItems;
//
//   Pagination({
//     required this.currentPage,
//     required this.totalPages,
//     required this.pageSize,
//     required this.totalItems,
//   });
//
//   factory Pagination.fromJson(Map<String, dynamic> json) {
//     return Pagination(
//       currentPage: json['currentPage'] ?? 0,
//       totalPages: json['totalPages'] ?? 0,
//       pageSize: json['pageSize'] ?? 0,
//       totalItems: json['totalItems'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'currentPage': currentPage,
//     'totalPages': totalPages,
//     'pageSize': pageSize,
//     'totalItems': totalItems,
//   };
// }
//
// class Filters {
//   final String? search;
//   final String? employeeCode;
//   final String? nickName;
//   final String? processName;
//
//   Filters({
//     this.search,
//     this.employeeCode,
//     this.nickName,
//     this.processName,
//   });
//
//   factory Filters.fromJson(Map<String, dynamic> json) {
//     return Filters(
//       search: json['search'],
//       employeeCode: json['employeeCode'],
//       nickName: json['nickName'],
//       processName: json['processName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'search': search,
//     'employeeCode': employeeCode,
//     'nickName': nickName,
//     'processName': processName,
//   };
// }
//
// class Summary {
//   final int totalEmployees;
//   final double totalSalarySum;
//   final double currentTotalSalarySum;
//   final double pendingFromLastClosedHalfSum;
//   final double totalPaidSum;
//   final double totalNetSalarySum;
//
//   Summary({
//     required this.totalEmployees,
//     required this.totalSalarySum,
//     required this.currentTotalSalarySum,
//     required this.pendingFromLastClosedHalfSum,
//     required this.totalPaidSum,
//     required this.totalNetSalarySum,
//   });
//
//   factory Summary.fromJson(Map<String, dynamic> json) {
//     return Summary(
//       totalEmployees: json['totalEmployees'] ?? 0,
//       totalSalarySum: (json['totalSalarySum'] ?? 0).toDouble(),
//       currentTotalSalarySum:
//       (json['currentTotalSalarySum'] ?? 0).toDouble(),
//       pendingFromLastClosedHalfSum:
//       (json['pendingFromLastClosedHalfSum'] ?? 0).toDouble(),
//       totalPaidSum: (json['totalPaidSum'] ?? 0).toDouble(),
//       totalNetSalarySum: (json['totalNetSalarySum'] ?? 0).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'totalEmployees': totalEmployees,
//     'totalSalarySum': totalSalarySum,
//     'currentTotalSalarySum': currentTotalSalarySum,
//     'pendingFromLastClosedHalfSum': pendingFromLastClosedHalfSum,
//     'totalPaidSum': totalPaidSum,
//     'totalNetSalarySum': totalNetSalarySum,
//   };
// }

