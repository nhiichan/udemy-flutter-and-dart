import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String? label;
  final double? spendingAmount;
  final double? spendingPercentageOfTotal;

  const ChartBar({
    Key? key,
    required this.label,
    required this.spendingAmount,
    required this.spendingPercentageOfTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          // nếu không thêm height thì khi nó phải hiện 1 số quá lớn,
          // cái chart sẽ bị đẩy lên trên!
          child: FittedBox(
            child: Text('\$${spendingAmount!.toStringAsFixed(0)}'),
          ),
        ), // integer value
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          width: 10,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            // Cái này giúp chart của mình hiện phần màu ở phía 
            // dưới thay vì từ trên xuống
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPercentageOfTotal,
                // so với chiều cao của toàn bộ cha
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(label!),
      ],
    );
  }
}
