class ProductResponseModel {
  final String? status;
  final ProductData? data;

  ProductResponseModel({this.status, this.data});

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      status: json['status'],
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final List<ProductItem> records;
  final Pagination? pagination;

  ProductData({
    required this.records,
    this.pagination,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      records: (json['records'] as List? ?? [])
          .map((e) => ProductItem.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class ProductItem {
  final String? id;
  final String? lotNo;
  final String? dNo;
  final String? colour;
  final String? pic;
  final String? rcPic;
  final String? alter;
  final String? reject;
  final String? size;
  final int? layer;
  final String? master;
  final String? status;
  final String? currentStatus;
  final String? employeeId;
  final DateTime? date;
  final DateTime? lastScanDate;

  final LastProcess? lastProcess;
  final List<ProcessEmployee> processEmployees;

  ProductItem({
    this.id,
    this.lotNo,
    this.dNo,
    this.colour,
    this.pic,
    this.rcPic,
    this.alter,
    this.reject,
    this.size,
    this.layer,
    this.master,
    this.status,
    this.currentStatus,
    this.employeeId,
    this.date,
    this.lastScanDate,
    this.lastProcess,
    required this.processEmployees,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['_id'],
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      colour: json['colour'],
      pic: json['pic'],
      rcPic: json['rcPic'] ?? '0',
      alter: json['alter'] ?? '0',
      reject: json['reject'] ?? '0',
      size: json['size'],
      layer: json['layer'],
      master: json['master'],
      status: json['status'],
      currentStatus: json['currentStatus'],
      employeeId: json['employeeId'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      lastScanDate: json['lastScanDate'] != null
          ? DateTime.parse(json['lastScanDate'])
          : null,
      lastProcess: json['lastProcess'] != null
          ? LastProcess.fromJson(json['lastProcess'])
          : null,
      processEmployees: (json['schandProcessEmployee'] as List? ?? [])
          .map((e) => ProcessEmployee.fromJson(e))
          .toList(),
    );
  }
}

class ProcessEmployee {
  final String? processName;
  final String? employeeName;
  final String? employeeCode;
  final String? processID;
  final String? employeeID;
  final String? machineName;
  final String? scanDate;
  final String? scanBy;

  ProcessEmployee({
    this.processName,
    this.employeeName,
    this.employeeCode,
    this.processID,
    this.employeeID,
    this.machineName,
    this.scanDate,
    this.scanBy,
  });

  factory ProcessEmployee.fromJson(Map<String, dynamic> json) {
    return ProcessEmployee(
      processName: json['processName'],
      employeeName: json['employeeName'],
      employeeCode: json['employeeCode'],
      processID: json['processID'],
      employeeID: json['employeeID'],
      machineName: json['machineName'],
      scanDate: json['scanDate'],
      scanBy: json['scanBy'],
    );
  }
}

class LastProcess {
  final String? processName;
  final String? id;
  final String? employeeCode;
  final String? name;

  LastProcess({
    this.processName,
    this.id,
    this.employeeCode,
    this.name,
  });

  factory LastProcess.fromJson(Map<String, dynamic> json) {
    return LastProcess(
      processName: json['processName'],
      id: json['id'],
      employeeCode: json['employeeCode'],
      name: json['name'],
    );
  }
}

class Pagination {
  final int? total;
  final int? page;
  final int? pages;
  final int? limit;
  final bool? hasNextPage;

  Pagination({
    this.total,
    this.page,
    this.pages,
    this.limit,
    this.hasNextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      limit: json['limit'],
      hasNextPage: json['hasNextPage'],
    );
  }
}