class OtpVerificationArguments {
  final String authSide;
  final String verificationId;
  final bool issignUpWithEmail;
  // This variable will be true when user has signed with email and password and we want him to add his phone number as well as the secondary login

  OtpVerificationArguments({required this.authSide, required this.verificationId, required this.issignUpWithEmail});
}
