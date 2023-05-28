import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _data = [
    Expense(
      title: 'Flutter Course',
      amount: 400.50,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 50.50,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void addExpence(Expense e) {
    setState(() {
      _data.add(e);
    });
  }

  void _removeExpence(Expense e) {
    final expenseIndex = _data.indexOf(e);
    setState(() {
      _data.remove(e);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _data.insert(expenseIndex, e);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addExpences: addExpence),
    );
  }

  @override
  Widget build(context) {
    Widget mainContent = const Center(
      child: Text('No Expense Found. Start Adding One..'),
    );
    if (_data.isNotEmpty) {
      mainContent = ExpensesList(_removeExpence, expenses: _data);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _data),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
