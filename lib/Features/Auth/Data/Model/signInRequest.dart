class SignInRequest{
  final String? email;
  final String password;
  final String? phone;
  const SignInRequest({
     this.email,
    this.phone,
    required this.password

});

}