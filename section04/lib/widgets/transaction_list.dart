import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:section04/models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key? key,
    required this.transactions,
    required this.deleteTransaction,
  }) : super(key: key);

  final List<Transaction>? transactions;
  final Function? deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: transactions!.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                // It needs a Function(BuildContext, int)
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColorDark,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          '\$${transactions![index].amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 30,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(6),
                    //     child: FittedBox(
                    //         child: Text(
                    //             '\$${transactions![index].amount.toStringAsFixed(2)}')),
                    //   ),
                    // ),
                    title: Text(
                      transactions![index].title,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions![index].date)),
                    trailing: IconButton(
                      onPressed: () =>
                          deleteTransaction!(transactions![index].id),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                );
                // return Card(
                //   child: Row(
                //     children: [
                //       Container(
                //         margin: const EdgeInsets.symmetric(
                //           vertical: 10,
                //           horizontal: 15,
                //         ),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: Theme.of(context).primaryColorDark,
                //             width: 2,
                //           ),
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(10)),
                //         ),
                //         padding: const EdgeInsets.all(10),
                //         child: Text(
                //           '\$${transactions![index].amount.toStringAsFixed(2)}',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //             color: Theme.of(context).primaryColorDark,
                //           ),
                //         ),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             transactions![index].title,
                //             style: Theme.of(context).textTheme.caption,
                //           ),
                //           Text(
                //             DateFormat.yMMMd()
                //                 .format(transactions![index].date),
                //             // DateFormat('yyyy-MM-dd').format(transactions![index].date),
                //             // Format DateTime year then month (M) then day!
                //             style: const TextStyle(
                //               color: Colors.grey,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // );
              },
              itemCount: transactions!.length,
            ),
    );
  }
}
