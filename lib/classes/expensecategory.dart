import 'expensecategoryDetailed.dart';

class ExpenseCategoryStatistics {
  final double totalExpense;
  final double cash;
  final double creditCard;
  final double cashback;
  final double average;
  final double expensive;
  final double cheap;
  final int totalReceipts;
  final ExpenseCategoryList details;

  ExpenseCategoryStatistics(
      this.totalExpense,
      this.cash,
      this.creditCard,
      this.cashback,
      this.average,
      this.expensive,
      this.cheap,
      this.totalReceipts,
      this.details);

  ExpenseCategoryStatistics.fromJson(Map<String, dynamic> parsedJson)
      : totalExpense = parsedJson['totalExpense'].toDouble(),
        cash = parsedJson['cashExpense'].toDouble(),
        creditCard = parsedJson['creditExpense'].toDouble(),
        cashback = parsedJson['kdv'].toDouble(),
        average = parsedJson['avg'].toDouble(),
        expensive = parsedJson['maxExpense'].toDouble(),
        cheap = parsedJson['minExpense'].toDouble(),
        totalReceipts = parsedJson['count'],
        details = ExpenseCategoryList.fromJson(parsedJson['details']);
}
