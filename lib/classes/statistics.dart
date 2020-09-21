import 'statisticDetailed.dart';

class Statistics {
  final double card1;
  final double card2;
  final double card3;
  final double card4;
  final StatisticDetailedList details;

  Statistics(this.card1, this.card2, this.card3, this.card4, this.details);

  Statistics.fromJson(Map<String, dynamic> parsedJson)
      : card1 = parsedJson['card1'].toDouble(),
        card2 = parsedJson['card2'],
        card3 = parsedJson['card3'],
        card4 = parsedJson['card4'],
        details = StatisticDetailedList.fromJson(parsedJson['details']);
}
