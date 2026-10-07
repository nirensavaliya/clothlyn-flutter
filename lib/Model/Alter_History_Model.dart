class AlterHistoryResponseModel {
  String? status;
  List<AlterHistoryData>? data;
  int? total;

  AlterHistoryResponseModel({
    this.status,
    this.data,
    this.total,
  });

  factory AlterHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return AlterHistoryResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? List<AlterHistoryData>.from(
          json['data'].map((x) => AlterHistoryData.fromJson(x)))
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

class AlterHistoryData {
  String? lotNo;
  String? dNo;
  int? alterPic;
  String? processName;
  String? alterDoneDate;

  AlterHistoryData({
    this.lotNo,
    this.dNo,
    this.alterPic,
    this.processName,
    this.alterDoneDate,
  });

  factory AlterHistoryData.fromJson(Map<String, dynamic> json) {
    return AlterHistoryData(
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      alterPic: json['alterPic'],
      processName: json['processName'],
      alterDoneDate: json['alterDoneDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotNo': lotNo,
      'dNo': dNo,
      'alterPic': alterPic,
      'processName': processName,
      'alterDoneDate': alterDoneDate,
    };
  }
}