class ReceiptDetailed {
  final String companyName;
  final String date;
  final String time;
  final String type;
  final String paymentType;
  final String ettn;
  final String category;
  var items;
  final double totalTax;
  final double totalPrice;

  ReceiptDetailed(
      this.companyName,
      this.date,
      this.time,
      this.type,
      this.paymentType,
      this.ettn,
      this.category,
      this.items,
      this.totalTax,
      this.totalPrice);

  ReceiptDetailed.fromJson(Map<String, dynamic> json)
      : companyName = json['companyName'],
        date = json['issueDate'],
        time = json['issueDate'],
        type = json['receiptType'],
        paymentType = json['paymentTypeNote'],
        ettn = json['ettn'],
        category = json['category'],
        items = json['items'],
        totalTax = json['totalKDV'].toDouble(),
        totalPrice = json['totalPrice'].toDouble();
}
