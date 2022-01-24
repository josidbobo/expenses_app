// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors, prefer_typing_uninitialized_variables,

import 'dart:ui';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'widgets/chart.dart';
import 'widgets/new_transactions.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([
  //DeviceOrientation.portraitUp, (import 'package:flutter/services.dart';) to use it with this
  //]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.amber),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: const TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                button: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 'with' keyword is used as a "mix-in" ie to inherit some features of a class without inheriting
// the whole class.
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [
    //Transaction(id: 't1', title: 'Shoes', amount: 19.10, date: DateTime.now()),
    //Transaction(
    //  id: 't2',
    //amount: 2.09,
    //date: DateTime.now(),
    //title: 'Weekly Groceries'),
  ];
  bool _showChartBar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: chosenDate.toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext contex) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        context: contex,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransactions),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget transListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart', style: TextStyle(fontSize: 14)),
          Switch.adaptive(
              value: _showChartBar,
              onChanged: (state) {
                setState(() {
                  _showChartBar = state;
                });
              }),
        ],
      ),
      _showChartBar
          ? Container(
              // First container containing the chart component of the app.
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.5,
              child: Chart(_recentTransactions))
          : transListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, transListWidget) {
    return [
      Container(
          // First container containing the chart component of the app.
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      transListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    ///appBAR begins here.
    final ObstructingPreferredSizeWidget iOSAppBar = CupertinoNavigationBar(
      middle: const Text('Expenses'),
      trailing: GestureDetector(
        onTap: () => _startAddNewTransaction(context),
        child: const Icon(CupertinoIcons.add),
      ),
    );
    final androidAppBar = AppBar(
      title: const Center(
        child: Text('Expenses'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _startAddNewTransaction(context);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
      ],
    );

    /// End of appBar

    /// Ternary expresssion for assigning the preferredSize for calculating how much space the widgets are to take on the screen.
    final PreferredSizeWidget appBar =
        Platform.isIOS ? iOSAppBar : androidAppBar;

    final transListWidget = Container(
        // transListWidget containes the listTile
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.75,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // This is a shorthand for rendering if conditions, in this method it returns nothing if the
            // condition is false
            if (isLandscape == true)
              ..._buildLandscapeContent(mediaQuery, appBar, transListWidget),
            if (isLandscape != true)
              ..._buildPortraitContent(mediaQuery, appBar, transListWidget),
          ],
        ),
      ),
    );

    // The Return statement begins here
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: iOSAppBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: androidAppBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  _startAddNewTransaction(context);
                }),
          );
  }
}
