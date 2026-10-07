class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String accountRole;
  final String company;
  final String email;
  final String employeeRole;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.accountRole,
    required this.company,
    required this.email,
    required this.employeeRole
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String name = "";

    if (json['username'] != null && json['username'].toString().isNotEmpty) {
      name = json['username']; // Admin
    } else {
      name =
          "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim();
    }
    return User(
      id: json['_id'] ?? '',
      name: name,
      phoneNumber: json['phoneNumber'] ?? '',
      accountRole: json['accountRole'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      employeeRole: json['employeeRole'] ?? ''
    );
  }
}