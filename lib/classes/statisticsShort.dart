class StatisticsShort {
  final double totalExpenses;
  final int receiptNumber;
  final String companyName;
  final String item;
  final int pinCode;

  StatisticsShort(this.totalExpenses, this.receiptNumber, this.companyName,
      this.item, this.pinCode);

  StatisticsShort.fromJson(Map<String, dynamic> json)
      : totalExpenses = json['expenses'].toDouble(),
        receiptNumber = json['count'],
        companyName = json['companyName'],
        item = json['item'],
        pinCode = json['pin'];
}
