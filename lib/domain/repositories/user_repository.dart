import '../entities/user.dart' as app_user;

abstract class UserRepository {
  Future<app_user.User?> getCurrentUser();
  Future<app_user.User?> getUserById(String userId);
  Future<bool> createUser(app_user.User user);
  Future<bool> updateUser(app_user.User user);
  Future<bool> deleteUser(String userId);
  Future<List<app_user.User>> getAllUsers();
  Future<List<app_user.User>> getUsersByRole(String role);
}