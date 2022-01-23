// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder containing the elements of the different transactions: title, date and amount.
    // Here each instance of transaction class are displayed by the listView.builder as a list of cards.
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text('There is no transaction'),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/fonts/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                  transaction: transactions[index], deleteTx: deleteTx);
            },
            itemCount: transactions.length,
          );
  }
}
