import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function? addNewTransaction;
  const NewTransaction({
    Key? key,
    this.addNewTransaction,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    // print(_titleController.text);
    // print(_amountController.text);
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedDate == null) return;
    String title = _titleController.text;
    double amount = double.parse(_amountController.text);
    widget.addNewTransaction!(title, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      // Chọn ngày
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
    // then là lấy dữ liệu về để xử lý
    // showDatePicker trả về một Future<DateTime>
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        // Khi mình ấn ra ngoài TextField thì nó sẽ
        // unfocus => keyboard sẽ biến mất!
      },
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                // onChanged: (value) => titleInput = value,
                controller: _titleController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                // onChanged: (value) => amountInput = value,
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  // TextField này khi ấn vào thì bàn phím hiện lên sẽ chỉ gồm
                  // chữ số và dấu chấm (do là kiểu double)
                  // Sẽ không cần try catch nữa!
                  decimal: true,
                ),
                // Bắt buộc phải có (_), dù không sử dụng!
                // Để _ để hiểu là không sử dụng đến.
              ),
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // Date picker
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text('Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
