class UpadModel {
  bool? success;
  String? message;
  List<UpadData>? data;
  Pagination? pagination;
  Filters? filters;

  UpadModel({this.success, this.message, this.data, this.pagination, this.filters});

  UpadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <UpadData>[];
      json['data'].forEach((v) {
        data!.add(UpadData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    filters =
    json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }
}

class UpadData {
  String? id;
  Employee? employeeId;
  int? upadAmount;
  String? createdAt;
  String? updatedAt;
  int? totalSalary;
  double? availableAmount;

  UpadData({
    this.id,
    this.employeeId,
    this.upadAmount,
    this.createdAt,
    this.updatedAt,
    this.totalSalary,
    this.availableAmount,
  });

  UpadData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    employeeId = json['employeeId'] != null
        ? Employee.fromJson(json['employeeId'])
        : null;

    upadAmount = json['upadAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    totalSalary = (json['totalSalary'] as num?)?.toInt();
    availableAmount = (json['availableAmount'] as num?)?.toDouble();
  }
}

class Employee {
  String? id;
  String? employeeName;
  String? firstName;
  String? lastName;
  String? nickname;
  String? email;
  String? mobileNumber;
  String? status;

  Employee({
    this.id,
    this.employeeName,
    this.firstName,
    this.lastName,
    this.nickname,
    this.email,
    this.mobileNumber,
    this.status,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    employeeName = json['employeeName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    nickname = json['nickname'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    status = json['status'];
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalRecords;
  bool? hasNext;
  bool? hasPrev;
  int? limit;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalRecords,
    this.hasNext,
    this.hasPrev,
    this.limit,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    hasNext = json['hasNext'];
    hasPrev = json['hasPrev'];
    limit = json['limit'];
  }
}
class Filters {
  String? search;
  String? employeeId;
  String? startDate;
  String? endDate;
  String? minAmount;
  String? maxAmount;

  Filters({
    this.search,
    this.employeeId,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });

  Filters.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    employeeId = json['employeeId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
  }
}