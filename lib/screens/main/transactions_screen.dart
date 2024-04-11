import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../transaction_history/expense_transactions_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/transactions_provider.dart';
import '../transaction_history/income_transactions_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: secondaryTextStyle(size: 16),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1, 5),
                      lastDate: DateTime(DateTime.now().year + 1, 9),
                      initialDate: _selectedDate,
                      locale: const Locale('en', 'US'),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });

                        Provider.of<TransactionsProvider>(context,
                                listen: false)
                            .fetchTransactions(date);
                      }
                    });
                  },
                  child: Align(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      //decoration: boxDecoration(radius: 8, showShadow: true),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.8)),
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMM().format(_selectedDate),
                            style: secondaryTextStyle(),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.date_range,
                            color: secondaryColor,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: secondaryColor,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    /// transaction history tab bar
                    TabBar(
                        labelColor: primaryColor,
                        indicatorColor: primaryTextColor,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: primaryTextStyle(),
                        tabs: [
                          Tab(text: 'Income'),
                          Tab(text: 'Expense'),
                        ]),
                    Expanded(
                      child: TabBarView(children: [
                        IncomeTransactionsScreen(selectedDate: _selectedDate),
                        ExpenseTransactionsScreen(selectedDate: _selectedDate),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
