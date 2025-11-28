class ResetData {
  final String email; 
  String? otp;       
  String? verificationToken;

  ResetData({
    required this.email,
    this.otp,
    this.verificationToken,
  });

  bool get isReadyForReset {
    return email.isNotEmpty && otp != null && otp!.isNotEmpty;
  }

  @override
  String toString() {
    return 'ResetData(email: $email, otp: ${otp != null ? "******" : "null"}, verificationToken: ${verificationToken != null ? "present" : "null"})';
  }
}
