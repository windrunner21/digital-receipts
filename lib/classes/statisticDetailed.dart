class StatisticDetailedList {
  final List<StatisticDetailed> detailsList;

  StatisticDetailedList({
    this.detailsList,
  });

  factory StatisticDetailedList.fromJson(List<dynamic> parsedJson) {
    List<StatisticDetailed> detailsList = new List<StatisticDetailed>();
    detailsList = parsedJson.map((i) => StatisticDetailed.fromJson(i)).toList();

    return new StatisticDetailedList(detailsList: detailsList);
  }
}

class StatisticDetailed {
  final int year;
  final int month;
  final int day;
  final int hour;
  final double yAxis;

  StatisticDetailed({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.yAxis,
  });

  factory StatisticDetailed.fromJson(Map<String, dynamic> json) {
    return new StatisticDetailed(
        year: json['year'],
        month: json['month'],
        day: json['day'],
        hour: json['hour'],
        yAxis: json['yAxis'].toDouble());
  }
}
