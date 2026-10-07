class DesignByNumberModel {
  String? id;
  String? designNumber;
  String? userId;
  String? description;
  String? status;
  double? baseRate;
  List<DesignProcessModel>? processes;

  DesignByNumberModel({
    this.id,
    this.designNumber,
    this.userId,
    this.description,
    this.status,
    this.baseRate,
    this.processes,
  });

  DesignByNumberModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    designNumber = json['designNumber'];
    userId = json['userId'];
    description = json['description'];
    status = json['status'];
    baseRate = (json['baseRate'] as num?)?.toDouble();

    if (json['processes'] != null) {
      processes = (json['processes'] as List)
          .map((e) => DesignProcessModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "designNumber": designNumber,
      "userId": userId,
      "description": description,
      "status": status,
      "baseRate": baseRate,
      "processes": processes?.map((e) => e.toJson()).toList(),
    };
  }
}

class DesignProcessModel {
  String? id;
  String? processName;
  double? price;
  int? multiRate;
  bool? isActive;

  DateTime? startDate;
  DateTime? endDate;

  List<MachineModel>? machineId;
  List<MachineDetailModel>? machineDetails;

  DesignProcessModel({
    this.id,
    this.processName,
    this.price,
    this.multiRate,
    this.isActive,
    this.startDate,
    this.endDate,
    this.machineId,
    this.machineDetails,
  });

  DesignProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    processName = json['processName'];
    price = (json['price'] as num?)?.toDouble();
    multiRate = (json['multiRate'] as num?)?.toInt();
    isActive = json['isActive'];

    startDate =
    json['startDate'] != null ? DateTime.parse(json['startDate']) : null;

    endDate =
    json['endDate'] != null ? DateTime.parse(json['endDate']) : null;

    if (json['machineId'] != null) {
      machineId = (json['machineId'] as List)
          .map((e) => MachineModel.fromJson(e))
          .toList();
    }

    if (json['machineDetails'] != null) {
      machineDetails = (json['machineDetails'] as List)
          .map((e) => MachineDetailModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "processName": processName,
      "price": price,
      "multiRate": multiRate,
      "isActive": isActive,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "machineId": machineId?.map((e) => e.toJson()).toList(),
      "machineDetails": machineDetails?.map((e) => e.toJson()).toList(),
    };
  }
}

class MachineModel {
  String? id;
  String? machineName;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  MachineModel({
    this.id,
    this.machineName,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  MachineModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    machineName = json['machineName'];
    userId = json['userId'];

    createdAt =
    json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;

    updatedAt =
    json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "machineName": machineName,
      "userId": userId,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class MachineDetailModel {
  String? id;
  String? machineName;
  double? baseRate;

  MachineDetailModel({
    this.id,
    this.machineName,
    this.baseRate,
  });

  MachineDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    machineName = json['machineName'];
    baseRate = (json['baseRate'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "machineName": machineName,
      "baseRate": baseRate,
    };
  }
}