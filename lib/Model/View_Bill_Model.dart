class ViewBillResponseModel {
  String? status;
  ViewBillData? data;

  ViewBillResponseModel({this.status, this.data});

  ViewBillResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ViewBillData.fromJson(json['data']) : null;
  }
}

class ViewBillData {
  List<ChallanReport>? report;
  double? grandTotal;
  Pagination? pagination;

  ViewBillData({this.report, this.grandTotal, this.pagination});

  ViewBillData.fromJson(Map<String, dynamic> json) {
    if (json['report'] != null) {
      report = <ChallanReport>[];
      json['report'].forEach((v) {
        report!.add(ChallanReport.fromJson(v));
      });
    }

    grandTotal = (json['grandTotal'] as num?)?.toDouble();

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class ChallanReport {
  int? no;
  String? dNo;
  int? alter;
  int? reject;
  String? alterReject;
  int? totalPic;
  int? totalLots;
  String? totalPicLots;
  num? price;
  String? totalPicLotsText;
  num? totalAmount;

  ChallanReport({
    this.no,
    this.dNo,
    this.alter,
    this.reject,
    this.alterReject,
    this.totalPic,
    this.totalLots,
    this.totalPicLots,
    this.price,
    this.totalPicLotsText,
    this.totalAmount,
  });

  ChallanReport.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    dNo = json['dNo'];
    alter = json['alter'];
    reject = json['reject'];
    alterReject = json['alterReject'];
    totalPic = json['totalPic'];
    totalLots = json['totalLots'];
    totalPicLots = json['totalPicLots'];
    price = (json['price'] as num?)?.toDouble() ?? 0.0;
    totalPicLotsText = json['totalPicLotsText'];
    totalAmount = (json['totalAmount'] as num?)?.toDouble() ?? 0.0;
  }
}

class Pagination {
  int? total;
  int? page;
  int? pages;
  int? limit;

  Pagination({this.total, this.page, this.pages, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pages = json['pages'];
    limit = json['limit'];
  }
}