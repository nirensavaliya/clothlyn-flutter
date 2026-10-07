class AdminUserModel {
  final String id;
  final String username;
  final String phoneNumber;
  final String email;
  final String status;
  final List<String> role;
  final String clientCode;
  final String accountRole;
  final String? company;

  AdminUserModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.role,
    required this.clientCode,
    required this.accountRole,
    this.company
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      role: json['role'] != null
          ? List<String>.from(json['role'].map((x) => x.toString()))
          : [],
      clientCode: json['clientCode'] ?? '',
      accountRole: json['accountRole'] ?? '',
      company: json['company'],
    );
  }
}