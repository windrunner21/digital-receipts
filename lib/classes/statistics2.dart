class Statistic2List {
  final List<Statistic2> list;

  Statistic2List({
    this.list,
  });

  factory Statistic2List.fromJson(List<dynamic> parsedJson) {
    List<Statistic2> list = new List<Statistic2>();
    list = parsedJson.map((i) => Statistic2.fromJson(i)).toList();

    return new Statistic2List(list: list);
  }
}

class Statistic2 {
  final String name;
  final int times;
  final double expense;

  Statistic2({this.name, this.times, this.expense});

  factory Statistic2.fromJson(Map<String, dynamic> json) {
    return new Statistic2(
        name: json['name'],
        times: json['times'],
        expense: json['expense'].toDouble());
  }
}
