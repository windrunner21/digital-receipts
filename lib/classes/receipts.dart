import 'receiptDetailed.dart';

class Receipts {
  final String city;
  final ReceiptDetailed receipts;

  Receipts(this.city, this.receipts);

  Receipts.fromJson(Map<String, dynamic> parsedJson)
      : city = parsedJson['city'],
        receipts = ReceiptDetailed.fromJson(parsedJson['receipt']);
}
