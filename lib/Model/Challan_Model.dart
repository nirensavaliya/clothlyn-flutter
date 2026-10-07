class ChallanResponseModel {
  String? status;
  List<ChallanData>? data;
  Pagination? pagination;

  ChallanResponseModel({this.status, this.data, this.pagination});

  ChallanResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <ChallanData>[];
      json['data'].forEach((v) {
        data!.add(ChallanData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class ChallanData {
  int? no;
  String? dNo;
  String? lotNo;
  String? color;
  String? size;
  int? pic;
  int? alter;
  int? reject;
  num? totalDeduction;
  String? deductionText;
  int? netPic;
  String? totalPicText;
  num? amount;
  num? totalAmount;

  ChallanData({
    this.no,
    this.dNo,
    this.lotNo,
    this.color,
    this.size,
    this.pic,
    this.alter,
    this.reject,
    this.totalDeduction,
    this.deductionText,
    this.netPic,
    this.totalPicText,
    this.amount,
    this.totalAmount,
  });

  ChallanData.fromJson(Map<String, dynamic> json) {
    no = (json['no'] as num?)?.toInt();
    dNo = json['dNo'];
    lotNo = json['lotNo'];
    color = json['color'];
    size = json['size'];
    pic = (json['pic'] as num?)?.toInt();
    alter = (json['alter'] as num?)?.toInt();
    reject = (json['reject'] as num?)?.toInt();
    totalDeduction = json['totalDeduction'] as num?;
    deductionText = json['deductionText'];
    netPic = (json['netPic'] as num?)?.toInt();
    totalPicText = json['totalPicText'];
    amount = json['amount'] as num?;
    totalAmount = json['totalAmount'] as num?;
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