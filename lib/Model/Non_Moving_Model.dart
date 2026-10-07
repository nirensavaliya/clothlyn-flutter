class ProcessReportModel {
  final String? status;
  final int? total;
  final int? page;
  final int? limit;
  final List<NonMovingModel>? data;

  ProcessReportModel({
    this.status,
    this.total,
    this.page,
    this.limit,
    this.data,
  });

  factory ProcessReportModel.fromJson(Map<String, dynamic> json) {
    return ProcessReportModel(
      status: json['status'],
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      data: (json['data'] as List?)
          ?.map((e) => NonMovingModel.fromJson(e))
          .toList(),
    );
  }
}

class NonMovingModel {
  final String? id;
  final String? color;
  final String? date;
  final String? designNumber;
  final String? layer;
  final String? pic;
  final String? lotNo;
  final String? master;
  final String? size;
  final List<dynamic>? layering;
  final List<dynamic>? cutting;
  final List<dynamic>? sorting;
  final List<dynamic>? pocket;
  final List<dynamic>? progress;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final String? lastStatusChangeDate;
  final int? daysSinceLastChange;
  final List<dynamic>? employees;

  NonMovingModel({
    this.id,
    this.color,
    this.date,
    this.designNumber,
    this.layer,
    this.pic,
    this.lotNo,
    this.master,
    this.size,
    this.layering,
    this.cutting,
    this.sorting,
    this.pocket,
    this.progress,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.lastStatusChangeDate,
    this.daysSinceLastChange,
    this.employees,
  });

  factory NonMovingModel.fromJson(Map<String, dynamic> json) {
    return NonMovingModel(
      id: json['_id'],
      color: json['color'],
      date: json['date'],
      designNumber: json['designNumber'],
      layer: json['layer'],
      pic: json['pic'],
      lotNo: json['lotNo'],
      master: json['master'],
      size: json['size'],
      layering: json['layering'] ?? [],
      cutting: json['cutting'] ?? [],
      sorting: json['sorting'] ?? [],
      pocket: json['pocket'] ?? [],
      progress: json['progress'] ?? [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      lastStatusChangeDate: json['lastStatusChangeDate'],
      daysSinceLastChange: json['daysSinceLastChange'],
      employees: json['employees'] ?? [],
    );
  }
}