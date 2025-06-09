import 'package:hr_pwa/model/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String databaseName = 'users';

class UserDatabase {
  // Database -> User
  final database = Supabase.instance.client.from(databaseName);

  // Create
  Future createUser(Users user) async {
    // final response = await database.insert({
    //   'user_id': user.userId,
    //   'phone_number': user.phoneNumber,
    //   'first_name': user.firstName,
    //   'last_name': user.lastName,
    //   'email': user.email,
    //   'employee_id': user.employeeId,
    //   'date_of_birth': user.dateOfBirth,
    //   'gender': user.gender,
    //   'created_at': DateTime.now().toIso8601String(),
    //   'updated_at': DateTime.now().toIso8601String(),
    //   'is_superadmin': user.isSuperAdmin,
    //   'is_admin': user.isAdmin,
    // });
    final response = await database.insert(user.toMap());

    if (response.error != null) {
      throw Exception('Failed to create user: ${response.error!.message}');
    }
  }

  // Read
  final stream = Supabase.instance.client.from(databaseName).stream(primaryKey: ['user_id']).map((data) => data.map((e) => Users.fromMap(e)).toList());

  // Update
  Future updateUser(Users user) async {
    final response = await database.update(user.toMap()).eq('user_id', user.userId);

    if (response.error != null) {
      throw Exception('Failed to update user: ${response.error!.message}');
    }
  }

  // Delete
  Future deleteUsers(Users user) async {
    await database.delete().eq('user_id', user.userId);
  }
}
