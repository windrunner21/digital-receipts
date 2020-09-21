class CouponsList {
  final List<Coupons> coupons;

  CouponsList({
    this.coupons,
  });

  factory CouponsList.fromJson(List<dynamic> parsedJson) {
    List<Coupons> coupons = new List<Coupons>();
    coupons = parsedJson.map((i) => Coupons.fromJson(i)).toList();

    return new CouponsList(coupons: coupons);
  }
}

class Coupons {
  final String id;
  final String storeName;
  final String description;
  final String startDate;
  final String endDate;
  final String condition;
  final double price;

  Coupons(
      {this.id,
      this.storeName,
      this.description,
      this.startDate,
      this.endDate,
      this.condition,
      this.price});

  factory Coupons.fromJson(Map<String, dynamic> json) {
    return new Coupons(
        id: json['_id'],
        storeName: json['storeName'],
        description: json['description'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        condition: json['condition'],
        price: json['price'].toDouble());
  }
}
