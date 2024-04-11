import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_income_widget.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import 'add_expense_widget.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime _selectedDate = DateTime.now();

  void _datePick() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 3, left: 5, right: 5),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: secondaryColor,
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(30))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded)),
                Text(
                  'AddNewTransaction',
                  style: primaryTextStyle(),
                ),
                const Spacer(),
                InkWell(
                  onTap: _datePick,
                  child: Align(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      //decoration: boxDecoration(radius: 8, showShadow: true),
                      // decoration: boxDecorationRoundedWithShadow(20
                      //     // backgroundColor: Colors.grey.shade100,
                      //     // borderRadius: BorderRadius.only(
                      //     //     topRight: Radius.circular(15),
                      //     //     bottomLeft: Radius.circular(15)),
                      //     ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        //color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(_selectedDate),
                            style: primaryTextStyle(size: 14),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.date_range,
                            color: primaryColor,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      /// add new transaction history tab bar
                      TabBar(
                          labelColor: primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: primaryTextStyle(size: 14),
                          tabs: const [
                            Tab(text: 'Income'),
                            Tab(text: 'Expense'),
                          ]),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: TabBarView(children: [
                            AddIncomeWidget(date: _selectedDate),
                            AddExpenseWidget(date: _selectedDate),
                          ]),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
