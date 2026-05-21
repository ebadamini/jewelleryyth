

class CreateUserRequestDto {

  const CreateUserRequestDto({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
});


  final String email;
  final String password;
  final String fullName;
  final String role;


  Map<String, dynamic> toJson(){
    return{
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
    };
  }
}