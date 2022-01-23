import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  Color? _bgcolor;

  @override
  void initState() {
    super.initState();
    const availableColors = [
      Colors.blue,
      Colors.green,
      Colors.pinkAccent,
      Colors.purpleAccent
    ];

   _bgcolor = availableColors[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bgcolor,
              //Theme.of(context).colorScheme.primary.withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text(
                '\$${widget.transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: Colors.black, fontSize: 19),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: Colors.grey, fontSize: 13.6),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
