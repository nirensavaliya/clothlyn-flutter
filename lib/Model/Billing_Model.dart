class BillingDatesModel {
  String? status;
  List<BillingDate>? data;
  Pagination? pagination;

  BillingDatesModel({this.status, this.data, this.pagination});

  BillingDatesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <BillingDate>[];
      json['data'].forEach((v) {
        data!.add(BillingDate.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class BillingDate {
  String? date;

  BillingDate({this.date});

  BillingDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
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