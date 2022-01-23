// ignore_for_file: prefer_const_constructors
// ignore not_initialised_non_nullable_instance_fields

import 'dart:io';

import 'package:expenses_app/widgets/adaptive_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function buttonAction;

  NewTransaction(this.buttonAction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.buttonAction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDayPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _selectedDate = datePicked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 30,
            ),
            TextField(
              autocorrect: true,
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              autocorrect: true,
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate == null
                      ? 'No Date Chosen'
                      : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate ?? DateTime.now())}'),
                 AdaptiveTextButton(text: 'Choose Date', handler: _presentDayPicker,)
                ],
              ),
            ),
            ElevatedButton(
              child: Text('Add Description'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).textTheme.button?.color),
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.blue.withOpacity(0.29);
                  }
                  return null;
                }),
              ),
              onPressed: _submitData,
            ),
          ],
          ),
        ),
      ),
    );
  }
}
