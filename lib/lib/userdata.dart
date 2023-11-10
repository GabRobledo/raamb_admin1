class User {
  final String id;
  final String name;
  final String email;
  final String role;
  // Add other fields as necessary

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    // Add other field initializers
  });

  // Factory constructor for deserialization from map to User object
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['_id'] ?? '',
      name: '${data['firstName']} ${data['lastName']}', // Assuming you have these fields in your data
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      // Initialize other fields here
    );
  }

  // Method to serialize User object to map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': name.split(' ').first, // This assumes 'name' is always two words separated by a space
      'lastName': name.split(' ').length > 1 ? name.split(' ')[1] : '', // Handling case where there might not be a last name
      'email': email,
      'role': role,
      // Add other fields here
    };
  }
}
