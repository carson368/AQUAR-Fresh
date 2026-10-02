enum UserRole { customer, admin, delivery }

class AppUser {
  final String id;
  final String name;
  final String phone;
  final UserRole role;

  const AppUser({required this.id, required this.name, required this.phone, required this.role});
}
