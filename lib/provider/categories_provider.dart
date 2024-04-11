import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CategoriesProvider with ChangeNotifier {
  User? user;

  CategoriesProvider(this.user) {
    fetchCategories();
  }

  CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('DataBase');

  List<String> incomeCategories = [];
  List<String> expenseCategories = [];

  Future<void> fetchCategories() async {
    if (user == null) {
      return;
    }
    incomeCategoriesStream();
    expenseCategoriesStream();
  }

  void updateUser(User us) async {
    user = us;
    await fetchCategories();
  }

  Future<void> incomeCategoriesStream() async {
    //incomeCategories = [];
    await for (var tranSnapshot in transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('incomeCategories')
        .snapshots()) {
      final incomeCateList = tranSnapshot.data();
      if (incomeCateList == null || incomeCateList.isEmpty) {
        addDefaultIncomeCategory();
      } else {
        incomeCategories = incomeCateList['names'].cast<String>();
      }

      notifyListeners();
    }
  }

  Future<void> expenseCategoriesStream() async {
    //expenseCategories = [];
    await for (var tranSnapshot in transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('expenseCategories')
        .snapshots()) {
      final expenseCateList = tranSnapshot.data();
      if (expenseCateList == null ||
          expenseCateList.isEmpty ||
          expenseCateList['names'].isEmpty) {
        addDefaultExpenseCategory();
      } else {
        expenseCategories = expenseCateList['names'].cast<String>();
      }

      notifyListeners();
    }
  }

  Future<void> addOrEditIncomeCategory(
      {String? oldName, String? newName}) async {
    if (oldName != null) {
      int ind = incomeCategories.indexOf(oldName);
      incomeCategories.removeWhere((name) => name == oldName);
      incomeCategories.insert(ind, newName!);
    } else {
      incomeCategories.add(newName!);
    }
    if (oldName == null && incomeCategories.length == 1) {
      await transactionCollection
          .doc(user!.uid)
          .collection('categories')
          .doc('incomeCategories')
          .set({'names': incomeCategories});
    } else {
      await transactionCollection
          .doc(user!.uid)
          .collection('categories')
          .doc('incomeCategories')
          .update({'names': incomeCategories});
    }
    notifyListeners();
  }

  Future<void> addOrEditExpenseCategory(
      {String? oldName, String? newName}) async {
    if (oldName != null) {
      int ind = expenseCategories.indexOf(oldName);
      expenseCategories.removeWhere((name) => name == oldName);
      expenseCategories.insert(ind, newName!);
    } else {
      expenseCategories.add(newName!);
    }
    if (oldName == null && expenseCategories.length == 1) {
      await transactionCollection
          .doc(user!.uid)
          .collection('categories')
          .doc('expenseCategories')
          .set({'names': expenseCategories});
    } else {
      await transactionCollection
          .doc(user!.uid)
          .collection('categories')
          .doc('expenseCategories')
          .update({'names': expenseCategories});
    }
    notifyListeners();
  }

  Future<void> deleteIncomeCategory(String incName) async {
    incomeCategories.removeWhere((inc) => inc == incName);
    await transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('incomeCategories')
        .update({'names': incomeCategories});
    notifyListeners();
  }

  Future<void> deleteExpenseCategory(String expName) async {
    expenseCategories.removeWhere((exp) => exp == expName);
    await transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('expenseCategories')
        .update({'names': expenseCategories});
    notifyListeners();
  }

  Future<void> addDefaultIncomeCategory() async {
    incomeCategories = ['Salary'];
    await transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('incomeCategories')
        .set({'names': incomeCategories});
  }

  Future<void> addDefaultExpenseCategory() async {
    expenseCategories = ['Food'];
    await transactionCollection
        .doc(user!.uid)
        .collection('categories')
        .doc('expenseCategories')
        .set({'names': expenseCategories});
  }
}
