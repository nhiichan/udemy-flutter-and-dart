import 'package:flutter/material.dart';
import 'package:section04/models/transaction.dart';
import 'package:section04/widgets/chart.dart';
import 'package:section04/widgets/new_transaction.dart';
import 'package:section04/widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Section 04',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
            caption: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        )),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
              // set up border radius cho DatePicker
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 23,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(), // must be unique
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      _userTransactions.add(newTx);
      // Dart stores objects in memory and only stores the pointer at these
      // objects, the address in your variables. So _userTransactions holds
      // a pointer at this list, the pointer, the address itself is final.
      // We just can't change the pointer to the list!
      // add method will change the existing list but it will not generate a
      // new pointer or a new address.
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        // Tạo một Sheet ở phía dưới cùng màn hình!
        context: context,
        builder: (_) {
          // get a BuildContext and return a Widget
          return NewTransaction(
            addNewTransaction: _addNewTransaction,
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    // Vì list các transaction ở đây nên phải đặt hàm ở đây!
    // id is unique => use id to find the transaction to delete
    setState(() {
      // sẽ phải build lại UI
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // String? titleInput;
    // String? amountInput;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PERSONAL EXPENSES'),
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // .stretch lấy tất cả chiều rộng có thể
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: Card(
            //     color: Theme.of(context).primaryColor,
            //     child: const Center(
            //       child: Text(
            //         'CHART!',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     elevation: 5,
            //   ),
            // ),
            Chart(recentTransactions: _recentTransactions),
            TransactionList(
              transactions: _userTransactions,
              deleteTransaction: _deleteTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
