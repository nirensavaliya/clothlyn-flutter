class SalaryReportModel {
  String? status;
  List<SalaryData>? data;
  int? dataCount;
  TotalsOverall? totalsOverall;
  TotalsPage? totalsPage;
  ModelCounts? modelCounts;
  ModelTotals? modelTotals;
  Pagination? pagination;
  DateFilter? dateFilter;
  Filters? filters;
  FiltersApplied? filtersApplied;
  int? searchResultsCount;

  SalaryReportModel({
    this.status,
    this.data,
    this.dataCount,
    this.totalsOverall,
    this.totalsPage,
    this.modelCounts,
    this.modelTotals,
    this.pagination,
    this.dateFilter,
    this.filters,
    this.filtersApplied,
    this.searchResultsCount,
  });

  factory SalaryReportModel.fromJson(Map<String, dynamic> json) {
    return SalaryReportModel(
      status: json['status'],
      data: (json['data'] as List?)
          ?.map((e) => SalaryData.fromJson(e))
          .toList(),
      dataCount: json['dataCount'],
      totalsOverall: json['totalsOverall'] != null
          ? TotalsOverall.fromJson(json['totalsOverall'])
          : null,
      totalsPage: json['totalsPage'] != null
          ? TotalsPage.fromJson(json['totalsPage'])
          : null,
      modelCounts: json['modelCounts'] != null
          ? ModelCounts.fromJson(json['modelCounts'])
          : null,
      modelTotals: json['modelTotals'] != null
          ? ModelTotals.fromJson(json['modelTotals'])
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      dateFilter: json['dateFilter'] != null
          ? DateFilter.fromJson(json['dateFilter'])
          : null,
      filters: json['filters'] != null
          ? Filters.fromJson(json['filters'])
          : null,
      filtersApplied: json['filtersApplied'] != null
          ? FiltersApplied.fromJson(json['filtersApplied'])
          : null,
      searchResultsCount: json['searchResultsCount'],
    );
  }
}

class SalaryData {
  String? lotNo;
  String? dNo;
  String? size;
  String? color;
  double? singlePrice;
  String? createdAt;
  ProcessId? processId;
  double? price;
  dynamic? pic;
  String? model;
  User? user;
  double? totalPicPrice;
  double? paidSalary;
  double? currentMonthPending;
  double? totalDeductions;
  double? netAmount;
  String? id;
  int? addedAt;

  SalaryData({
    this.lotNo,
    this.dNo,
    this.size,
    this.color,
    this.singlePrice,
    this.createdAt,
    this.processId,
    this.price,
    this.pic,
    this.model,
    this.user,
    this.totalPicPrice,
    this.paidSalary,
    this.currentMonthPending,
    this.totalDeductions,
    this.netAmount,
    this.id,
    this.addedAt,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    return SalaryData(
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      size: json['size'],
      color: json['color'],
      singlePrice: (json['singlePrice'] as num?)?.toDouble(),
      createdAt: json['createdAt'],
      processId: json['processId'] != null
          ? ProcessId.fromJson(json['processId'])
          : null,
      price: (json['price'] as num?)?.toDouble(),
      pic: json['pic'],
      model: json['model'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalPicPrice: (json['totalPicPrice'] as num?)?.toDouble(),
      paidSalary: (json['paidSalary'] as num?)?.toDouble(),
      currentMonthPending:
      (json['currentMonthPending'] as num?)?.toDouble(),
      totalDeductions: (json['totalDeductions'] as num?)?.toDouble(),
      netAmount: (json['netAmount'] as num?)?.toDouble(),
      id: json['_id'],
      addedAt: json['_addedAt'],
    );
  }
}

class ProcessId {
  String? id;
  String? processName;
  String? userId;
  String? createdAt;
  String? updatedAt;

  ProcessId({
    this.id,
    this.processName,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProcessId.fromJson(Map<String, dynamic> json) {
    return ProcessId(
      id: json['_id'],
      processName: json['processName'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
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
  String? status;

  User({
    this.id,
    this.employeeName,
    this.firstName,
    this.lastName,
    this.nickname,
    this.email,
    this.mobileNumber,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      employeeName: json['employeeName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      nickname: json['nickname'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      status: json['status'],
    );
  }
}

class TotalsOverall {
  int? totalPic;
  double? totalAllPrice;
  double? totalPaidSalary;
  double? totalCurrentMonthPending;
  double? totalDeductions;
  double? totalNetAmount;

  TotalsOverall({
    this.totalPic,
    this.totalAllPrice,
    this.totalPaidSalary,
    this.totalCurrentMonthPending,
    this.totalDeductions,
    this.totalNetAmount,
  });

  factory TotalsOverall.fromJson(Map<String, dynamic> json) {
    return TotalsOverall(
      totalPic: json['totalPic'],
      totalAllPrice: (json['totalAllPrice'] as num?)?.toDouble(),
      totalPaidSalary: (json['totalPaidSalary'] as num?)?.toDouble(),
      totalCurrentMonthPending:
      (json['totalCurrentMonthPending'] as num?)?.toDouble(),
      totalDeductions:
      (json['totalDeductions'] as num?)?.toDouble(),
      totalNetAmount:
      (json['totalNetAmount'] as num?)?.toDouble(),
    );
  }
}

class TotalsPage {
  dynamic? totalPic;
  double? totalAllPrice;
  double? totalPaidSalary;
  double? totalCurrentMonthPending;
  double? totalDeductions;
  double? totalNetAmount;

  TotalsPage({
    this.totalPic,
    this.totalAllPrice,
    this.totalPaidSalary,
    this.totalCurrentMonthPending,
    this.totalDeductions,
    this.totalNetAmount,
  });

  factory TotalsPage.fromJson(Map<String, dynamic> json) {
    return TotalsPage(
      totalPic: json['totalPic'],
      totalAllPrice: (json['totalAllPrice'] as num?)?.toDouble(),
      totalPaidSalary: (json['totalPaidSalary'] as num?)?.toDouble(),
      totalCurrentMonthPending:
      (json['totalCurrentMonthPending'] as num?)?.toDouble(),
      totalDeductions:
      (json['totalDeductions'] as num?)?.toDouble(),
      totalNetAmount:
      (json['totalNetAmount'] as num?)?.toDouble(),
    );
  }
}

class ModelCounts {
  int? doracut;
  int? logo;
  int? packing;
  int? press;
  int? rc;
  int? layering;
  int? cutting;
  int? sorting;
  int? pocket;

  ModelCounts({
    this.doracut,
    this.logo,
    this.packing,
    this.press,
    this.rc,
    this.layering,
    this.cutting,
    this.sorting,
    this.pocket,
  });

  factory ModelCounts.fromJson(Map<String, dynamic> json) {
    return ModelCounts(
      doracut: json['doracut'],
      logo: json['logo'],
      packing: json['packing'],
      press: json['press'],
      rc: json['rc'],
      layering: json['layering'],
      cutting: json['cutting'],
      sorting: json['sorting'],
      pocket: json['pocket'],
    );
  }
}

class ModelTotals extends ModelCounts {
  ModelTotals.fromJson(Map<String, dynamic> json)
      : super(
    doracut: json['doracut'],
    logo: json['logo'],
    packing: json['packing'],
    press: json['press'],
    rc: json['rc'],
    layering: json['layering'],
    cutting: json['cutting'],
    sorting: json['sorting'],
    pocket: json['pocket'],
  );
}

class Pagination {
  bool? hasPagination;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({
    this.hasPagination,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      hasPagination: json['hasPagination'],
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class DateFilter {
  String? startDate;
  String? endDate;
  bool? isDefault;

  DateFilter({
    this.startDate,
    this.endDate,
    this.isDefault,
  });

  factory DateFilter.fromJson(Map<String, dynamic> json) {
    return DateFilter(
      startDate: json['startDate'],
      endDate: json['endDate'],
      isDefault: json['isDefault'],
    );
  }
}

class Filters {
  dynamic search;
  dynamic pic;
  dynamic lotNo;
  dynamic dNo;

  Filters({this.search, this.pic, this.lotNo, this.dNo});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      search: json['search'],
      pic: json['pic'],
      lotNo: json['lotNo'],
      dNo: json['dNo'],
    );
  }
}

class FiltersApplied {
  bool? search;
  bool? pic;
  bool? lotNo;
  bool? dNo;
  bool? any;

  FiltersApplied({
    this.search,
    this.pic,
    this.lotNo,
    this.dNo,
    this.any,
  });

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied(
      search: json['search'],
      pic: json['pic'],
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      any: json['any'],
    );
  }
}