class VerificationRequest {
  final String id;
  final String mobileNumber;

  VerificationRequest({
    required this.id,
    required this.mobileNumber,
  });

  // Factory constructor for deserialization from map to VerificationRequest object
  factory VerificationRequest.fromMap(Map<String, dynamic> data) {
    return VerificationRequest(
      id: data['_id'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
    );
  }

  // Method to serialize VerificationRequest object to map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mobileNumber': mobileNumber,
    };
  }
}
