import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/order_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  const OrderItemWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 150, 250) : 95,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy - hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
              ),
            ),
            // if (_expanded)
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              height: _expanded ? min(widget.order.products.length * 20.0 + 50, 100) : 0,
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  var prod = widget.order.products[index];
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${prod.price} x ${prod.quantity}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                itemCount: widget.order.products.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
