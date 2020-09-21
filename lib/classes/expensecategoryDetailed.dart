class ExpenseCategoryList {
  final List<ExpenseCategory> detailsList;

  ExpenseCategoryList({
    this.detailsList,
  });

  factory ExpenseCategoryList.fromJson(List<dynamic> parsedJson) {
    List<ExpenseCategory> detailsList = new List<ExpenseCategory>();
    detailsList = parsedJson.map((i) => ExpenseCategory.fromJson(i)).toList();

    return new ExpenseCategoryList(detailsList: detailsList);
  }
}

class ExpenseCategory {
  final int year;
  final int month;
  final int day;
  final int hour;
  final double expense;

  ExpenseCategory({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.expense,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return new ExpenseCategory(
        year: json['year'],
        month: json['month'],
        day: json['day'],
        hour: json['hour'],
        expense: json['expense'].toDouble());
  }
}
