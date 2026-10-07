class AlterResponseModel {
  final String? status;
  final List<AlterData>? data;
  final int? total;

  AlterResponseModel({
    this.status,
    this.data,
    this.total,
  });

  factory AlterResponseModel.fromJson(Map<String, dynamic> json) {
    return AlterResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? List<AlterData>.from(
          json['data'].map((x) => AlterData.fromJson(x)))
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

class AlterData {
  final String? lotNo;
  final int? alterCount;

  AlterData({
    this.lotNo,
    this.alterCount,
  });

  factory AlterData.fromJson(Map<String, dynamic> json) {
    return AlterData(
      lotNo: json['lotNo'],
      alterCount: json['alterCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotNo': lotNo,
      'alterCount': alterCount,
    };
  }
}