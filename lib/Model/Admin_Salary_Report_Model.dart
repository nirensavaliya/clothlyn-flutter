class AdminSalaryReportModel {
  String? status;
  List<RcData>? data;
  int? dataCount;
  RcTotals? rcTotals;
  TotalsOverall? totalsOverall;
  TotalsPage? totalsPage;
  Pagination? pagination;
  DateFilter? dateFilter;
  dynamic search;
  bool? searchApplied;
  int? searchResultsCount;

  AdminSalaryReportModel({
    this.status,
    this.data,
    this.dataCount,
    this.rcTotals,
    this.totalsOverall,
    this.totalsPage,
    this.pagination,
    this.dateFilter,
    this.search,
    this.searchApplied,
    this.searchResultsCount,
  });

  AdminSalaryReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dataCount = json['dataCount'];
    search = json['search'];
    searchApplied = json['searchApplied'];
    searchResultsCount = json['searchResultsCount'];

    if (json['data'] != null) {
      data = <RcData>[];
      json['data'].forEach((v) {
        data!.add(RcData.fromJson(v));
      });
    }

    rcTotals = json['rcTotals'] != null
        ? RcTotals.fromJson(json['rcTotals'])
        : null;

    totalsOverall = json['totalsOverall'] != null
        ? TotalsOverall.fromJson(json['totalsOverall'])
        : null;

    totalsPage = json['totalsPage'] != null
        ? TotalsPage.fromJson(json['totalsPage'])
        : null;

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    dateFilter = json['dateFilter'] != null
        ? DateFilter.fromJson(json['dateFilter'])
        : null;
  }
}

class RcData {
  String? id;
  String? lotNo;
  String? dNo;
  String? pic;
  double? price;
  String? size;
  String? color;
  String? model;
  String? role;
  int? alter;
  int? reject;
  int? totalPic;
  int? rcPic;
  int? effectivePic;
  double? totalPicPrice;
  double? netAmount;
  int? paidSalary;
  int? currentMonthPending;
  int? totalDeductions;
  User? user;
  String? createdAt;
  String? updatedAt;

  RcData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    lotNo = json['lotNo'];
    dNo = json['dNo'];
    pic = json['pic'].toString();
    price = (json['price'] ?? 0).toDouble();
    size = json['size'];
    color = json['color'];
    model = json['model'];
    role = json['role'];
    alter = json['alter'];
    reject = json['reject'];
    totalPic = json['totalPic'];
    rcPic = json['rcPic'];
    effectivePic = json['effectivePic'];
    totalPicPrice = (json['totalPicPrice'] ?? 0).toDouble();
    netAmount = (json['netAmount'] ?? 0).toDouble();
    paidSalary = json['paidSalary'];
    currentMonthPending = json['currentMonthPending'];
    totalDeductions = json['totalDeductions'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  String? id;
  String? employeeName;
  String? firstName;
  String? lastName;
  String? nickname;
  String? email;
  String? mobileNumber;

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    employeeName = json['employeeName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    nickname = json['nickname'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
  }
}

class RcTotals {
  int? totalPic;
  int? totalAlter;
  int? totalReject;
  int? totalEffectivePic;

  RcTotals.fromJson(Map<String, dynamic> json) {
    totalPic = json['totalPic'];
    totalAlter = json['totalAlter'];
    totalReject = json['totalReject'];
    totalEffectivePic = json['totalEffectivePic'];
  }
}

class TotalsOverall {
  int? totalPic;
  double? totalAllPrice;
  double? totalNetAmount;

  TotalsOverall.fromJson(Map<String, dynamic> json) {
    totalPic = json['totalPic'];
    totalAllPrice = (json['totalAllPrice'] ?? 0).toDouble();
    totalNetAmount = (json['totalNetAmount'] ?? 0).toDouble();
  }
}

class TotalsPage {
  int? totalPic;
  double? totalAllPrice;
  double? totalNetAmount;
  int? totalAlter;
  int? totalReject;

  TotalsPage.fromJson(Map<String, dynamic> json) {
    totalPic = json['totalPic'];
    totalAllPrice = (json['totalAllPrice'] ?? 0).toDouble();
    totalNetAmount = (json['totalNetAmount'] ?? 0).toDouble();
    totalAlter = json['totalAlter'];
    totalReject = json['totalReject'];
  }
}

class Pagination {
  bool? hasPagination;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination.fromJson(Map<String, dynamic> json) {
    hasPagination = json['hasPagination'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
}

class DateFilter {
  String? startDate;
  String? endDate;
  bool? isDefault;

  DateFilter.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    isDefault = json['isDefault'];
  }
}