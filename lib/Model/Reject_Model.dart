class RejectResponseModel {
  String? status;
  List<RejectData>? data;
  int? total;

  RejectResponseModel({
    this.status,
    this.data,
    this.total,
  });

  factory RejectResponseModel.fromJson(Map<String, dynamic> json) {
    return RejectResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? List<RejectData>.from(
          json['data'].map((x) => RejectData.fromJson(x)))
          : [],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((x) => x.toJson()).toList(),
      'total': total,
    };
  }
}

class RejectData {
  String? lotNo;
  int? rejectPic;

  RejectData({
    this.lotNo,
    this.rejectPic,
  });

  factory RejectData.fromJson(Map<String, dynamic> json) {
    return RejectData(
      lotNo: json['lotNo'],
      rejectPic: json['rejectPic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotNo': lotNo,
      'rejectPic': rejectPic,
    };
  }
}