class UserDashboard {
  final double limit;
  final double spent;
  final double cashback;
  final double average;

  UserDashboard(this.limit, this.spent, this.cashback, this.average);

  UserDashboard.fromJson(Map<String, dynamic> json)
      : limit = json['limit'],
        spent = json['expenses'].toDouble(),
        cashback = json['kdv'].toDouble(),
        average = json['avg'].toDouble();
}
