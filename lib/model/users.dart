class Users {
  String userId;
  String phoneNumber;
  String firstName;
  String lastName;
  String email;
  String employeeId;
  DateTime dateOfBirth;
  String gender;
  bool isSuperAdmin;
  bool isAdmin;

  Users(
      {required this.userId,
      required this.phoneNumber,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.employeeId,
      required this.dateOfBirth,
      required this.gender,
      required this.isSuperAdmin,
      required this.isAdmin});

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
        userId: map['user_id'] as String,
        phoneNumber: map['phone_number'] as String,
        firstName: map['first_name'] as String,
        lastName: map['last_name'] as String,
        email: map['email'] as String,
        employeeId: map['employee_id'] as String,
        dateOfBirth: map['date_of_birth'] as DateTime,
        gender: map['gender'] as String,
        isSuperAdmin: map['is_superadmin'] as bool,
        isAdmin: map['is_admin'] as bool);
  }

  Map<String, dynamic> toMap() {
    return {
      // 'user_id': userId,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'employee_id': employeeId,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      // 'is_superadmin': isSuperAdmin,
      // 'is_admin': isAdmin,
    };
  }
}
