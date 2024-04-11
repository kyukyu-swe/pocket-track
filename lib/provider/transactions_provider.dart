import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/income.dart';

import '../models/expense.dart';

class TransactionsProvider with ChangeNotifier {
  User? user;
  bool isLoading = false;

  TransactionsProvider(this.user);

  void updateUser(User us) {
    user = us;
  }

  CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('DataBase');

  List<Income> incomeList = [];
  List<Expense> expenseList = [];

  Future<void> fetchTransactions(DateTime date) async {
    if (user == null) {
      return;
    }

    await fetchIncomeTransactions(date);
    await fetchExpenseTransactions(date);
  }

  Future<void> fetchIncomeTransactions(DateTime date) async {
    var tranSnapshot = await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date))
        .collection('incomeTransactions')
        .get();

    final incomeDocList = tranSnapshot.docs;
    incomeList = [];
    for (var doc in incomeDocList) {
      incomeList.add(Income.fromJson(doc));
    }
    notifyListeners();
  }

  Future<void> fetchExpenseTransactions(DateTime date) async {
    var tranSnapshot = await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date))
        .collection('expenseTransactions')
        .get();

    final expenseDocList = tranSnapshot.docs;
    expenseList = [];
    for (var doc in expenseDocList) {
      expenseList.add(Expense.fromJson(doc));
    }
    notifyListeners();
  }

  Future<void> addIncome(Income income, DateTime date) async {
    await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('incomeTransactions')
        .add(income.toJson());
    incomeList.add(income);
    notifyListeners();
  }

  Future<void> addExpense(Expense expense, DateTime date) async {
    await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('expenseTransactions')
        .add(expense.toJson());
    expenseList.add(expense);
    notifyListeners();
  }

  Map<String, dynamic> totalIncomeAndExpense() {
    int totalIncome = 0;
    int totalExpense = 0;
    int balance = 0;
    for (var income in incomeList) {
      totalIncome += income.amount;
    }
    for (var expense in expenseList) {
      totalExpense += expense.amount;
    }
    balance = totalIncome - totalExpense;

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': balance,
    };
  }

  Map<String, int> incomeByCategory() {
    List<String> categoryList = [];
    Map<String, int> incomeByCategory = {};
    for (var income in incomeList) {
      if (!categoryList.contains(income.category)) {
        categoryList.add(income.category);
      }
    }

    categoryList.reversed.forEach((category) {
      int amount = 0;
      incomeList.forEach((income) {
        if (category == income.category) {
          amount += income.amount;
        }
      });

      incomeByCategory[category] = amount;
    });
    List<MapEntry<String, int>> sortedEntries =
        incomeByCategory.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    Map<String, int> sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }

  Map<String, int> expenseByCategory() {
    List<String> categoryList = [];
    Map<String, int> expenseByCategory = {};
    for (var expense in expenseList) {
      if (!categoryList.contains(expense.category)) {
        categoryList.add(expense.category);
      }
    }

    categoryList.reversed.forEach((category) {
      int amount = 0;
      expenseList.forEach((expense) {
        if (category == expense.category) {
          amount += expense.amount;
        }
      });

      expenseByCategory[category] = amount;
    });

    List<MapEntry<String, int>> sortedEntries =
        expenseByCategory.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    Map<String, int> sortedMap = Map.fromEntries(sortedEntries);
    return sortedMap;
  }

  List<Map<String, dynamic>> incomeTransactionsForOneMonth() {
    List<Income> dayTranList = incomeList;

    List<Map<String, dynamic>> dailyTranList = [];

    for (int day = 31; day >= 0; day--) {
      int totalSum = 0;
      List<Income> dayList =
          dayTranList.where((income) => income.date.day == day).toList();
      dayList.sort((a, b) => a.date.compareTo(b.date));
      if (dayList.isNotEmpty) {
        for (var dayTran in dayList) {
          totalSum += dayTran.amount!;
        }
        Map<String, dynamic> dayMap = {
          'date':
              DateFormat('dd MMM, yyyy').format(dayList.first.date).toString(),
          'tranList': dayList,
          'totalSum': totalSum.toString(),
        };
        dailyTranList.add(dayMap);
      }
    }
    return dailyTranList;
  }

  List<Map<String, dynamic>> expenseTransactionsForOneMonth() {
    List<Expense> dayTranList = expenseList;

    List<Map<String, dynamic>> dailyTranList = [];

    for (int day = 31; day >= 0; day--) {
      int totalSum = 0;
      List<Expense> dayList =
          dayTranList.where((expense) => expense.date.day == day).toList();
      dayList.sort((a, b) => a.date.compareTo(b.date));
      if (dayList.isNotEmpty) {
        for (var dayTran in dayList) {
          totalSum += dayTran.amount!;
        }
        Map<String, dynamic> dayMap = {
          'date':
              DateFormat('dd MMM, yyyy').format(dayList.first.date).toString(),
          'tranList': dayList,
          'totalSum': totalSum.toString(),
        };
        dailyTranList.add(dayMap);
      }
    }
    return dailyTranList;
  }

  Future<void> deleteIncome(Income income, DateTime date) async {
    incomeList.removeWhere((inc) => inc.id == income.id);
    await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('incomeTransactions')
        .doc(income.id)
        .delete();
  }

  Future<void> deleteExpense(Expense expense, DateTime date) async {
    incomeList.removeWhere((exp) => exp.id == expense.id);
    await transactionCollection
        .doc(user!.uid)
        .collection('transactions')
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('expenseTransactions')
        .doc(expense.id)
        .delete();
  }
}
