class DesignListModel {
  bool? success;
  List<DesignModel>? data;
  Pagination? pagination;

  DesignListModel({this.success, this.data, this.pagination});

  DesignListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <DesignModel>[];
      json['data'].forEach((v) {
        data!.add(DesignModel.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      dataMap['pagination'] = pagination!.toJson();
    }

    return dataMap;
  }
}

class DesignModel {
  String? id;
  String? designNumber;
  String? userId;
  String? employeeId;
  String? machineId;
  double? baseRate;
  List<ProcessModel>? processes;

  DesignModel({
    this.id,
    this.designNumber,
    this.userId,
    this.employeeId,
    this.machineId,
    this.baseRate,
    this.processes,
  });

  DesignModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    designNumber = json['designNumber'];
    userId = json['userId'];
    employeeId = json['employeeId'];
    machineId = json['machineId'] is String
        ? json['machineId']
        : json['machineId'] is List
        ? (json['machineId'] as List).isNotEmpty
        ? json['machineId'][0].toString()
        : null
        : json['machineId'] is Map
        ? json['machineId']['_id']?.toString()
        : null;
    baseRate = (json['baseRate'] as num?)?.toDouble();

    if (json['processes'] != null) {
      processes = <ProcessModel>[];
      json['processes'].forEach((v) {
        processes!.add(ProcessModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['designNumber'] = designNumber;
    data['userId'] = userId;
    data['employeeId'] = employeeId;
    data['machineId'] = machineId;
    data['baseRate'] = baseRate;

    if (processes != null) {
      data['processes'] = processes!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ProcessModel {
  String? id;
  String? processName;
  List<dynamic>? machineId;
  List<dynamic>? machineDetails;
  double? price;
  double? multiRate;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  ProcessModel({
    this.id,
    this.processName,
    this.machineId,
    this.machineDetails,
    this.price,
    this.multiRate,
    this.startDate,
    this.endDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  ProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    processName = json['processName'];
    machineId = json['machineId'];
    machineDetails = json['machineDetails'];
    price = (json['price'] as num?)?.toDouble();
    multiRate = (json['multiRate'] as num?)?.toDouble();
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['processName'] = processName;
    data['machineId'] = machineId;
    data['machineDetails'] = machineDetails;
    data['price'] = price;
    data['multiRate'] = multiRate;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalItems'] = totalItems;
    data['itemsPerPage'] = itemsPerPage;
    return data;
  }
}