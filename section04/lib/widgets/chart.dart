// Phần biểu đồ thể hiện một tuần

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:section04/models/transaction.dart';
import 'package:section04/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {
    // getter
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      // Trừ ngày đi so với thời gian hiện tại!
      double totalSum = 0.0;
      for (Transaction transaction in recentTransactions) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay),
        // 'day': DateFormat.E().format(weekDay).substring(0, 1),
        // label for week day
        // substring get the first character
        'amount': totalSum,
      };
    }).reversed.toList();
    // List được reversed sau đó phải đưa lại về List tiếp!
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0,
        (previousValue, element) =>
            previousValue += double.parse(element['amount'].toString()));
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        // Padding giống container nhưng nó chỉ có mục đích thêm padding
        // chứ không cần decoration hay gì!
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            double amount = double.parse(data['amount'].toString());
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'].toString(),
                  spendingAmount: amount,
                  spendingPercentageOfTotal:
                      totalSpending == 0 ? 0 : amount / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
