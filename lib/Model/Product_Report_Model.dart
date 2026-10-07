class DesignProcessModel {
  bool? success;
  List<DesignData>? data;
  Pagination? pagination;

  DesignProcessModel({this.success, this.data, this.pagination});

  DesignProcessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DesignData>[];
      json['data'].forEach((v) {
        data!.add(DesignData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class DesignData {
  String? id;
  String? designNumber;
  String? userId;
  String? description;
  String? status;
  List<Process>? processes;
  List<Process>? currentProcesses;

  DesignData({
    this.id,
    this.designNumber,
    this.userId,
    this.description,
    this.status,
    this.processes,
    this.currentProcesses,
  });

  DesignData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    designNumber = json['designNumber'];
    userId = json['userId'];
    description = json['description'];
    status = json['status'];

    if (json['processes'] != null) {
      processes = <Process>[];
      json['processes'].forEach((v) {
        processes!.add(Process.fromJson(v));
      });
    }

    if (json['currentProcesses'] != null) {
      currentProcesses = <Process>[];
      json['currentProcesses'].forEach((v) {
        currentProcesses!.add(Process.fromJson(v));
      });
    }
  }
}

class Process {
  String? id;
  String? processName;
  double? price;
  double? multiRate;
  bool? isActive;
  double? currentPrice;
  bool? isCurrentlyActive;
  List<Machine>? machineId;
  List<MachineDetails>? machineDetails;

  Process({
    this.id,
    this.processName,
    this.price,
    this.multiRate,
    this.isActive,
    this.currentPrice,
    this.isCurrentlyActive,
    this.machineId,
    this.machineDetails,
  });

  Process.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    processName = json['processName'];
    price = (json['price'] as num?)?.toDouble();
    multiRate = (json['multiRate'] as num?)?.toDouble();
    isActive = json['isActive'];
    currentPrice = (json['currentPrice'] as num?)?.toDouble();
    isCurrentlyActive = json['isCurrentlyActive'];

    if (json['machineId'] != null) {
      machineId = <Machine>[];
      json['machineId'].forEach((v) {
        machineId!.add(Machine.fromJson(v));
      });
    }

    if (json['machineDetails'] != null) {
      machineDetails = <MachineDetails>[];
      json['machineDetails'].forEach((v) {
        machineDetails!.add(MachineDetails.fromJson(v));
      });
    }
  }
}

class Machine {
  String? id;
  String? machineName;

  Machine({this.id, this.machineName});

  Machine.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    machineName = json['machineName'];
  }
}

class MachineDetails {
  String? id;
  String? machineId;
  String? machineName;
  double? baseRate;

  MachineDetails({this.id, this.machineId, this.machineName, this.baseRate});

  MachineDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    machineId = json['machineId'];
    machineName = json['machineName'];
    baseRate = (json['baseRate'] as num?)?.toDouble();
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
  }
}