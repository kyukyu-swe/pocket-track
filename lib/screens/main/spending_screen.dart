import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../provider/transactions_provider.dart';
import '../../widgets/piechart_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  DateTime _selectedDate = DateTime.now();
  late TransactionsProvider transactionsProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    transactionsProvider = Provider.of<TransactionsProvider>(context);
    setState(() {
      isLoading = true;
    });

    transactionsProvider.fetchTransactions(_selectedDate);
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

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
                  'Spending',
                  style: secondaryTextStyle(size: 16),
                ),
                InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1, 5),
                      lastDate: DateTime(DateTime.now().year + 1, 9),
                      initialDate: _selectedDate,
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          // Provider.of<TransactionsProvider>(context,
                          //         listen: false)
                          //     .fetchTransactions(_selectedDate);
                        });
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
                        color: primaryColor,
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
              child: isLoading == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          transactionsProvider.fetchTransactions(_selectedDate);
                        });
                      },
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 60),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Income', style: primaryTextStyle()),
                                    Text(
                                        transactionsProvider
                                            .totalIncomeAndExpense()[
                                                'totalIncome']
                                            .toString(),
                                        style: primaryTextStyle()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Expense', style: primaryTextStyle()),
                                    Text(
                                        transactionsProvider
                                            .totalIncomeAndExpense()[
                                                'totalExpense']
                                            .toString(),
                                        style: primaryTextStyle()),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Balance', style: primaryTextStyle()),
                                    Text(
                                        transactionsProvider
                                            .totalIncomeAndExpense()['balance']
                                            .toString(),
                                        style: primaryTextStyle()),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                PieChartWidget(
                                    dataMap:
                                        transactionsProvider.incomeByCategory(),
                                    chartTitle: 'Income'),
                                SizedBox(height: 80),
                                PieChartWidget(
                                    dataMap: transactionsProvider
                                        .expenseByCategory(),
                                    chartTitle: 'Expense'),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
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
