class ReceiptsShortList {
  final List<ReceiptShort> receipts;

  ReceiptsShortList({
    this.receipts,
  });

  factory ReceiptsShortList.fromJson(List<dynamic> parsedJson) {
    List<ReceiptShort> receipts = new List<ReceiptShort>();
    receipts = parsedJson.map((i) => ReceiptShort.fromJson(i)).toList();

    return new ReceiptsShortList(receipts: receipts);
  }
}

class ReceiptShort {
  final String id;
  final String companyName;
  final String category;
  final double totalPrice;
  final String date;
  final String time;

  ReceiptShort(
      {this.id,
      this.category,
      this.companyName,
      this.totalPrice,
      this.date,
      this.time});

  factory ReceiptShort.fromJson(Map<String, dynamic> json) {
    return new ReceiptShort(
        id: json['_id'],
        companyName: json['companyName'],
        category: json['category'],
        totalPrice: json['totalPrice'].toDouble(),
        date: json['issueDate'],
        time: json['issueDate']);
  }
}
