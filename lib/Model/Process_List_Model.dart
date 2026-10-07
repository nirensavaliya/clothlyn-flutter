class ProcessRateResponseModel {
  final String status;
  final List<ProcessRateModel> data;

  ProcessRateResponseModel({
    required this.status,
    required this.data,
  });

  factory ProcessRateResponseModel.fromJson(Map<String, dynamic> json) {
    return ProcessRateResponseModel(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProcessRateModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ProcessRateModel {
  final String processName;
  final String? userId;
  final double price;
  final double oldRate;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProcessRateModel({
    required this.processName,
    required this.userId,
    required this.price,
    required this.oldRate,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProcessRateModel.fromJson(Map<String, dynamic> json) {
    return ProcessRateModel(
      processName: json['processName'] ?? '',
      userId: json['_id']?.toString(),
      price: (json['price'] ?? 0).toDouble(),
      oldRate: (json['oldRate'] ?? 0).toDouble(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'processName': processName,
      'userId': userId,
      'price': price,
      'oldRate': oldRate,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}