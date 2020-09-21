class User {
  final bool isCorporate;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String city;
  final String district;
  final int pin;
  final bool agreement;
  final double limit;

  User(
      this.firstName,
      this.email,
      this.isCorporate,
      this.lastName,
      this.phoneNumber,
      this.city,
      this.district,
      this.pin,
      this.agreement,
      this.limit);

  User.fromJson(Map<String, dynamic> json)
      : isCorporate = json['isCorporate'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        city = json['city'],
        district = json['district'],
        pin = json['walletPin'],
        agreement = json['hasAgreedToShareData'],
        limit = json['expenseLimit'].toDouble();
}
