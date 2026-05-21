class SignupRequestDto {
  const SignupRequestDto({
    required this.tenantName,
    required this.tenantCode,
    required this.adminEmail,
    required this.adminPassword,
    required this.adminFullName,
  });

  final String tenantName;
  final String tenantCode;
  final String adminEmail;
  final String adminPassword;
  final String adminFullName;

  Map<String, dynamic> toJson() {
    return {
      'tenantName': tenantName,
      'tenantCode': tenantCode,
      'adminEmail': adminEmail,
      'adminPassword': adminPassword,
      'adminFullName': adminFullName,
    };
  }
}
