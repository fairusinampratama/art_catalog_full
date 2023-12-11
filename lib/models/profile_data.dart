class UserProfile {
  final String email;
  final String firstName;
  final String lastName;
  final int age;

  UserProfile({
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.age = 0,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      email: data['email'] ?? '',
      firstName: data['first name'] as String? ?? '',
      lastName: data['last name'] as String? ?? '',
      age: data['age'] as int? ?? 0,
    );
  }
}
