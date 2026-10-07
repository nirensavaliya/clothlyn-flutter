class AlterEditResponseModel {
  final String? status;
  final List<ScanData>? data;

  AlterEditResponseModel({
    this.status,
    this.data,
  });

  factory AlterEditResponseModel.fromJson(Map<String, dynamic> json) {
    return AlterEditResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? List<ScanData>.from(
          json['data'].map((x) => ScanData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class ScanData {
  final String? id;
  final String? lotNo;
  final String? dNo;
  final String? pic;
  final String? size;
  final String? color;
  final List<MachineEmployee>? machineEmployees;
  final String? stickerPhoto;
  final String? rcPic;
  final String? alter;
  final String? reject;
  final ProcessId? processId;
  final DashboardData? dashboardDataId;
  final String? scannedByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScanData({
    this.id,
    this.lotNo,
    this.dNo,
    this.pic,
    this.size,
    this.color,
    this.machineEmployees,
    this.stickerPhoto,
    this.rcPic,
    this.alter,
    this.reject,
    this.processId,
    this.dashboardDataId,
    this.scannedByName,
    this.createdAt,
    this.updatedAt,
  });

  factory ScanData.fromJson(Map<String, dynamic> json) {
    return ScanData(
      id: json['_id'],
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      pic: json['pic'],
      size: json['size'],
      color: json['color'],
      machineEmployees: json['machineEmployees'] != null
          ? List<MachineEmployee>.from(json['machineEmployees']
          .map((x) => MachineEmployee.fromJson(x)))
          : [],
      stickerPhoto: json['stickerPhoto'],
      rcPic: json['rcPic'],
      alter: json['alter'],
      reject: json['reject'],
      processId: json['processId'] != null
          ? ProcessId.fromJson(json['processId'])
          : null,
      dashboardDataId: json['dashboardDataId'] != null
          ? DashboardData.fromJson(json['dashboardDataId'])
          : null,
      scannedByName: json['scannedByName'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "lotNo": lotNo,
    "dNo": dNo,
    "pic": pic,
    "size": size,
    "color": color,
    "machineEmployees":
    machineEmployees?.map((x) => x.toJson()).toList(),
    "stickerPhoto": stickerPhoto,
    "rcPic": rcPic,
    "alter": alter,
    "reject": reject,
    "processId": processId?.toJson(),
    "dashboardDataId": dashboardDataId?.toJson(),
    "scannedByName": scannedByName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class MachineEmployee {
  final MachineId? machineId;
  final String? machineName;
  final Employee? employeeId;
  final double? baseRate;

  MachineEmployee({
    this.machineId,
    this.machineName,
    this.employeeId,
    this.baseRate,
  });

  factory MachineEmployee.fromJson(Map<String, dynamic> json) {
    return MachineEmployee(
      machineId: json['machineId'] != null
          ? MachineId.fromJson(json['machineId'])
          : null,
      machineName: json['machineName'],
      employeeId: json['employeeId'] != null
          ? Employee.fromJson(json['employeeId'])
          : null,
      baseRate: (json['baseRate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "machineId": machineId?.toJson(),
    "machineName": machineName,
    "employeeId": employeeId?.toJson(),
    "baseRate": baseRate,
  };
}

class MachineId {
  final String? id;
  final String? machineName;

  MachineId({
    this.id,
    this.machineName,
  });

  factory MachineId.fromJson(Map<String, dynamic> json) {
    return MachineId(
      id: json['_id'],
      machineName: json['machineName'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "machineName": machineName,
  };
}

class Employee {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobileNumber: json['mobileNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
  };
}

class ProcessId {
  final String? id;
  final String? processName;

  ProcessId({
    this.id,
    this.processName,
  });

  factory ProcessId.fromJson(Map<String, dynamic> json) {
    return ProcessId(
      id: json['_id'],
      processName: json['processName'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "processName": processName,
  };
}

class DashboardData {
  final String? id;
  final String? lotNo;
  final String? dNo;
  final String? colour;
  final String? size;
  final String? status;
  final String? currentStatus;

  DashboardData({
    this.id,
    this.lotNo,
    this.dNo,
    this.colour,
    this.size,
    this.status,
    this.currentStatus,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      id: json['_id'],
      lotNo: json['lotNo'],
      dNo: json['dNo'],
      colour: json['colour'],
      size: json['size'],
      status: json['status'],
      currentStatus: json['currentStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "lotNo": lotNo,
    "dNo": dNo,
    "colour": colour,
    "size": size,
    "status": status,
    "currentStatus": currentStatus,
  };
}