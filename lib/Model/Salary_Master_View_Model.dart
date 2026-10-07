class SalaryMasterViewModel {
  final String status;
  final EmployeeSalaryData data;

  SalaryMasterViewModel({
    required this.status,
    required this.data,
  });

  factory SalaryMasterViewModel.fromJson(Map<String, dynamic> json) {
    return SalaryMasterViewModel(
      status: json['status'] ?? '',
      data: EmployeeSalaryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class EmployeeSalaryData {
  final String employeeId;
  final DateTime joinedAt;
  final Employee employee;
  final SalarySummaryMaster salarySummaryMaster;
  final HalfMonthSnapshot halfMonthPeriodSnapshot;
  final Totals totals;
  final List<PaidSalaryHistory> paidSalaryHistory;
  final int paidSalaryRecordCount;

  EmployeeSalaryData({
    required this.employeeId,
    required this.joinedAt,
    required this.employee,
    required this.salarySummaryMaster,
    required this.halfMonthPeriodSnapshot,
    required this.totals,
    required this.paidSalaryHistory,
    required this.paidSalaryRecordCount,
  });

  factory EmployeeSalaryData.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryData(
      employeeId: json['employeeId'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt']),
      employee: Employee.fromJson(json['employee'] ?? {}),
      salarySummaryMaster:
      SalarySummaryMaster.fromJson(json['salarySummaryMaster'] ?? {}),
      halfMonthPeriodSnapshot:
      HalfMonthSnapshot.fromJson(json['halfMonthPeriodSnapshot'] ?? {}),
      totals: Totals.fromJson(json['totals'] ?? {}),
      paidSalaryHistory: (json['paidSalaryHistory'] as List? ?? [])
          .map((e) => PaidSalaryHistory.fromJson(e))
          .toList(),
      paidSalaryRecordCount: (json['paidSalaryRecordCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'employeeId': employeeId,
    'joinedAt': joinedAt.toIso8601String(),
    'employee': employee.toJson(),
    'salarySummaryMaster': salarySummaryMaster.toJson(),
    'halfMonthPeriodSnapshot': halfMonthPeriodSnapshot.toJson(),
    'totals': totals.toJson(),
    'paidSalaryHistory':
    paidSalaryHistory.map((e) => e.toJson()).toList(),
    'paidSalaryRecordCount': paidSalaryRecordCount,
  };
}

class Employee {
  final String id;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String adharNumber;
  final String mobileNumber;
  final String referenceName;
  final String referenceMobileNumber;
  final String accountNumber;
  final String accountHolderName;
  final String ifscCode;
  final String bankName;
  final String bankBranchName;
  final List<Role> role;
  final List<dynamic> scanPermission;
  final List<String> employeeRole;
  final List<Machine> machine;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPaid;
  final num totalSalary;
  final int totalUpad;

  Employee({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
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
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPaid,
    required this.totalSalary,
    required this.totalUpad,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] ?? '',
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      adharNumber: json['adharNumber'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referenceName: json['referenceName'] ?? '',
      referenceMobileNumber: json['referenceMobileNumber'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountHolderName: json['accountHolderName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankBranchName: json['bankBranchName'] ?? '',
      role: (json['role'] as List? ?? [])
          .map((e) => Role.fromJson(e))
          .toList(),
      scanPermission: json['scanPermission'] ?? [],
      employeeRole:
      (json['employeeRole'] as List? ?? []).map((e) => e.toString()).toList(),
      machine: (json['machine'] as List? ?? [])
          .map((e) => Machine.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      totalPaid: (json['totalPaid'] as num?)?.toInt() ?? 0,
      totalSalary: (json['totalSalary'] as num?)?.toDouble() ?? 0.0,
      totalUpad: (json['totalUpad'] as num?)?.toInt() ?? 0,
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
    'role': role.map((e) => e.toJson()).toList(),
    'scanPermission': scanPermission,
    'employeeRole': employeeRole,
    'machine': machine.map((e) => e.toJson()).toList(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'totalPaid': totalPaid,
    'totalSalary': totalSalary,
    'totalUpad': totalUpad,
  };
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

  Map<String, dynamic> toJson() => {
    '_id': id,
    'processName': processName,
  };
}

class Machine {
  final String id;
  final String machineName;

  Machine({
    required this.id,
    required this.machineName,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['_id'] ?? '',
      machineName: json['machineName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'machineName': machineName,
  };
}

class SalarySummaryMaster {
  final num totalRemainingAmount;
  final num currentPeriodSalary;
  final num lastPeriodSalary;
  final num upadPaid;
  final num paySalary;
  final num bonusPaid;
  final num salaryPaid;

  /// Legacy aliases
  final num totalSalary;
  final num currentTotalSalary;
  final num pendingFromLastClosedHalf;
  final num totalPaid;
  final num netSalary;
  final bool isHalfMonthSalary;
  final String status;
  final List<String> processNames;

  SalarySummaryMaster({
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
    required this.status,
    required this.processNames,
  });

  factory SalarySummaryMaster.fromJson(Map<String, dynamic> json) {
    num numOf(dynamic v) => (v is num) ? v : num.tryParse('$v') ?? 0;

    final lastPeriod =
        numOf(json['lastPeriodSalary'] ?? json['pendingFromLastClosedHalf']);
    final currentPeriod =
        numOf(json['currentPeriodSalary'] ?? json['currentTotalSalary']);
    final upad = numOf(json['upadPaid']);
    final bonus = numOf(json['bonusPaid']);
    final salaryPd = numOf(json['salaryPaid']);
    final totalPd = numOf(json['totalPaid']);
    final computedPay = (lastPeriod + bonus - (salaryPd != 0 ? salaryPd : totalPd) - upad);
    final pay = json['paySalary'] != null
        ? numOf(json['paySalary'])
        : (computedPay < 0 ? 0 : computedPay);
    final remaining = json['totalRemainingAmount'] != null
        ? numOf(json['totalRemainingAmount'])
        : (pay + currentPeriod);

    return SalarySummaryMaster(
      totalRemainingAmount: remaining,
      currentPeriodSalary: currentPeriod,
      lastPeriodSalary: lastPeriod,
      upadPaid: upad,
      paySalary: pay,
      bonusPaid: bonus,
      salaryPaid: salaryPd != 0 ? salaryPd : totalPd,
      totalSalary: numOf(json['totalSalary']),
      currentTotalSalary: currentPeriod,
      pendingFromLastClosedHalf: lastPeriod,
      totalPaid: totalPd,
      netSalary: remaining,
      isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
      status: json['status'] ?? '',
      processNames:
          (json['processNames'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRemainingAmount': totalRemainingAmount,
    'currentPeriodSalary': currentPeriodSalary,
    'lastPeriodSalary': lastPeriodSalary,
    'upadPaid': upadPaid,
    'paySalary': paySalary,
    'bonusPaid': bonusPaid,
    'salaryPaid': salaryPaid,
    'totalSalary': totalSalary,
    'currentTotalSalary': currentTotalSalary,
    'pendingFromLastClosedHalf': pendingFromLastClosedHalf,
    'totalPaid': totalPaid,
    'netSalary': netSalary,
    'isHalfMonthSalary': isHalfMonthSalary,
    'status': status,
    'processNames': processNames,
  };
}

class HalfMonthSnapshot {
  final num totalSalaryClosedHalf;
  final num currentOpenHalfEarned;
  final num pendingFromLastClosedHalf;
  final bool isHalfMonthSalary;

  HalfMonthSnapshot({
    required this.totalSalaryClosedHalf,
    required this.currentOpenHalfEarned,
    required this.pendingFromLastClosedHalf,
    required this.isHalfMonthSalary,
  });

  factory HalfMonthSnapshot.fromJson(Map<String, dynamic> json) {
    return HalfMonthSnapshot(
      totalSalaryClosedHalf: (json['totalSalaryClosedHalf'] as num?) ?? 0,
      currentOpenHalfEarned: (json['currentOpenHalfEarned'] as num?) ?? 0,
      pendingFromLastClosedHalf:
      (json['pendingFromLastClosedHalf'] as num?) ?? 0,
      isHalfMonthSalary: json['isHalfMonthSalary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalSalaryClosedHalf': totalSalaryClosedHalf,
    'currentOpenHalfEarned': currentOpenHalfEarned,
    'pendingFromLastClosedHalf': pendingFromLastClosedHalf,
    'isHalfMonthSalary': isHalfMonthSalary,
  };
}

class Totals {
  final num lifetimeEarnedFromSalaryReports;
  final num lifetimeTotalPaid;
  final num approximateNetOutstanding;

  Totals({
    required this.lifetimeEarnedFromSalaryReports,
    required this.lifetimeTotalPaid,
    required this.approximateNetOutstanding,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      lifetimeEarnedFromSalaryReports:
      (json['lifetimeEarnedFromSalaryReports'] as num?) ?? 0,
      lifetimeTotalPaid: (json['lifetimeTotalPaid'] as num?) ?? 0,
      approximateNetOutstanding:
      (json['approximateNetOutstanding'] as num?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'lifetimeEarnedFromSalaryReports':
    lifetimeEarnedFromSalaryReports,
    'lifetimeTotalPaid': lifetimeTotalPaid,
    'approximateNetOutstanding': approximateNetOutstanding,
  };
}

class PaidSalaryHistory {
  PaidSalaryHistory();

  factory PaidSalaryHistory.fromJson(Map<String, dynamic> json) {
    return PaidSalaryHistory();
  }

  Map<String, dynamic> toJson() => {};
}