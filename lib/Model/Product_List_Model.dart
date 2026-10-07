class ProductReportModel {
  String? status;
  ProductReportData? data;

  ProductReportModel({this.status, this.data});

  ProductReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? ProductReportData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProcessColumn {
  String? key;
  String? label;
  String? processName;

  ProcessColumn({this.key, this.label, this.processName});

  ProcessColumn.fromJson(Map<String, dynamic> json) {
    key = json['key']?.toString();
    label = json['label']?.toString();
    processName = json['processName']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'processName': processName,
    };
  }
}

class ProductReportData {
  String? dNo;
  List<ProcessColumn>? processColumns;
  List<Report>? report;

  ProductReportData({this.dNo, this.processColumns, this.report});

  ProductReportData.fromJson(Map<String, dynamic> json) {
    dNo = json['dNo'];

    if (json['processColumns'] != null && json['processColumns'] is List) {
      processColumns = <ProcessColumn>[];
      for (final v in json['processColumns']) {
        if (v is Map<String, dynamic>) {
          processColumns!.add(ProcessColumn.fromJson(v));
        }
      }
    }

    if (json['report'] != null) {
      report = <Report>[];
      json['report'].forEach((v) {
        report!.add(Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dNo'] = dNo;

    if (processColumns != null) {
      data['processColumns'] =
          processColumns!.map((v) => v.toJson()).toList();
    }

    if (report != null) {
      data['report'] = report!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Report {
  String? color;
  String? size;
  String? forThread;
  String? rcPic;
  String? doraCut;
  String? doracutReceive;
  String? logo;
  String? press;
  String? packing;
  String? checking;
  String? billScan;
  String? total;
  String? completed;
  Map<String, dynamic> values;

  Report({
    this.color,
    this.size,
    this.forThread,
    this.rcPic,
    this.doraCut,
    this.doracutReceive,
    this.logo,
    this.press,
    this.packing,
    this.checking,
    this.billScan,
    this.total,
    this.completed,
    Map<String, dynamic>? values,
  }) : values = values ?? {};

  Report.fromJson(Map<String, dynamic> json)
      : values = Map<String, dynamic>.from(json) {
    color = json['color']?.toString();
    size = json['size']?.toString();
    forThread = json['forThread']?.toString();
    rcPic = json['rcPic']?.toString();
    doraCut = json['doraCut']?.toString();
    doracutReceive = json['doracutReceive']?.toString();
    logo = json['logo']?.toString();
    press = json['press']?.toString();
    packing = json['packing']?.toString();
    checking = json['checking']?.toString();
    billScan = json['billScan']?.toString();
    total = json['total']?.toString();
    completed = json['completed']?.toString();
  }

  /// Cell value for a dynamic process column key (e.g. "gajBattan").
  String cellValue(String? key) {
    if (key == null || key.isEmpty) return '';
    final v = values[key];
    if (v != null) return v.toString();
    return '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>.from(values);

    data['color'] = color;
    data['size'] = size;
    data['forThread'] = forThread;
    data['rcPic'] = rcPic;
    data['doraCut'] = doraCut;
    data['doracutReceive'] = doracutReceive;
    data['logo'] = logo;
    data['press'] = press;
    data['packing'] = packing;
    data['checking'] = checking;
    data['billScan'] = billScan;
    data['total'] = total;
    data['completed'] = completed;

    return data;
  }
}
