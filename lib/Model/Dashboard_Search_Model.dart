class DashboardSearchResponse {
  String? status;
  DashboardData? data;

  DashboardSearchResponse({this.status, this.data});

  DashboardSearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }
}

class DashboardData {
  List<RecordModel>? records;
  DashboardStats? dashboardStats;
  Pagination? pagination;

  DashboardData({this.records, this.dashboardStats, this.pagination});

  DashboardData.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <RecordModel>[];
      json['records'].forEach((v) {
        records!.add(RecordModel.fromJson(v));
      });
    }

    dashboardStats = json['dashboardStats'] != null
        ? DashboardStats.fromJson(json['dashboardStats'])
        : null;

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class RecordModel {
  String? id;
  String? lotNo;
  String? dNo;
  String? colour;
  String? size;
  String? status;
  String? currentStatus;
  String? createdAt;

  EmployeeDetails? employeeDetails;
  List<ProcessDetail>? processDetails;
  DesignDetails? designDetails;

  RecordModel({
    this.id,
    this.lotNo,
    this.dNo,
    this.colour,
    this.size,
    this.status,
    this.currentStatus,
    this.createdAt,
    this.employeeDetails,
    this.processDetails,
    this.designDetails,
  });

  RecordModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    lotNo = json['lotNo'];
    dNo = json['dNo'];
    colour = json['colour'];
    size = json['size'];
    status = json['status'];
    currentStatus = json['currentStatus'];
    createdAt = json['createdAt'];

    employeeDetails = json['employeeDetails'] != null
        ? EmployeeDetails.fromJson(json['employeeDetails'])
        : null;

    if (json['schand_ProcessDetails'] != null) {
      processDetails = <ProcessDetail>[];
      json['schand_ProcessDetails'].forEach((v) {
        processDetails!.add(ProcessDetail.fromJson(v));
      });
    }

    designDetails = json['designDetails'] != null
        ? DesignDetails.fromJson(json['designDetails'])
        : null;
  }
}

class EmployeeDetails {
  String? username;
  String? phoneNumber;
  String? status;

  EmployeeDetails({this.username, this.phoneNumber, this.status});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
  }
}

class ProcessDetail {
  String? id;
  String? processId;
  double? price;
  String? createdAt;

  ProcessDetail({this.id, this.processId, this.price, this.createdAt});

  ProcessDetail.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    processId = json['processId'];
    price = (json['price'] as num?)?.toDouble();
    createdAt = json['createdAt'];
  }
}

class DesignDetails {
  String? id;
  String? designNumber;
  double? baseRate;

  DesignDetails({this.id, this.designNumber, this.baseRate});

  DesignDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    designNumber = json['designNumber'];
    baseRate = (json['baseRate'] as num?)?.toDouble();
  }
}

class DashboardStats {
  int? totalPicInSystem;
  int? totalRegisteredEmployees;
  int? totalCreatedDesigns;

  DashboardStats({
    this.totalPicInSystem,
    this.totalRegisteredEmployees,
    this.totalCreatedDesigns,
  });

  DashboardStats.fromJson(Map<String, dynamic> json) {
    totalPicInSystem = json['totalPicInSystem'];
    totalRegisteredEmployees = json['totalRegisteredEmployees'];
    totalCreatedDesigns = json['totalCreatedDesigns'];
  }
}

class Pagination {
  int? total;
  int? page;
  int? pages;
  int? limit;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.total,
    this.page,
    this.pages,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pages = json['pages'];
    limit = json['limit'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }
}