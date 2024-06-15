import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../provider/transactions_provider.dart';
import '../../widgets/piechart_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import "../../utils/utils.dart";

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
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
    List<Map<String, dynamic>> tranLists =
        transactionsProvider.AllTransactionsForOneMonth();
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
                      const BorderRadius.only(topRight: Radius.circular(0))),
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
                                vertical: 30, horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  lightgreenColor, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Rounded corners
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/total_balance.png',
                                                      height: 40,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left:
                                                              15), // Add padding to the left of the Text
                                                      child: Text(
                                                        'Total Balance',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  ], //Text]
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "\฿",
                                                      style: boldTextStyle(
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 3,
                                                            left:
                                                                5), // Add padding to the left of the Text
                                                        child: Text(
                                                          FormatUtil.formatNumberWithDecimals(
                                                              transactionsProvider
                                                                  .totalIncomeAndExpense()[
                                                                      'balance']
                                                                  .toDouble()),
                                                          style: boldTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              size: 18),
                                                        ))
                                                  ], //Text]
                                                )
                                              ], //Center],
                                            )), //Card
                                      ),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  lightredColor, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Rounded corners
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/expense.png',
                                                      height: 30,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left:
                                                              15), // Add padding to the left of the Text
                                                      child: Text(
                                                        'Expense',
                                                        style: boldTextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ], //Text]
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "\฿",
                                                      style: boldTextStyle(
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 3,
                                                            left:
                                                                5), // Add padding to the left of the Text
                                                        child: Text(
                                                          FormatUtil.formatNumberWithDecimals(
                                                              transactionsProvider
                                                                  .totalIncomeAndExpense()[
                                                                      'totalExpense']
                                                                  .toDouble()),
                                                          style: boldTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              size: 18),
                                                        ))
                                                  ], //Text]
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  lightblueColor, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Rounded corners
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/income.png',
                                                      height: 30,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left:
                                                              15), // Add padding to the left of the Text
                                                      child: Text(
                                                        'Income',
                                                        style: boldTextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ], //Text]
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "\฿",
                                                      style: boldTextStyle(
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 3,
                                                            left:
                                                                5), // Add padding to the left of the Text
                                                        child: Text(
                                                          FormatUtil.formatNumberWithDecimals(
                                                              transactionsProvider
                                                                  .totalIncomeAndExpense()[
                                                                      'totalIncome']
                                                                  .toDouble()),
                                                          style: boldTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              size: 18),
                                                        ))
                                                  ], //Text]
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PieChartWidget(
                                    dataMap:
                                        transactionsProvider.incomeByCategory(),
                                    chartTitle: 'Income'),
                                SizedBox(
                                  width: 50,
                                ),
                                PieChartWidget(
                                    dataMap: transactionsProvider
                                        .expenseByCategory(),
                                    chartTitle: 'Expense'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              'Top Recent Activities',
                              style: boldTextStyle(size: 16),
                            ),
                          ),
                          tranLists.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'There is no activites on this month.',
                                  ),
                                )
                              : Container(
                                  height: tranLists.length * 75,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: tranLists.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: softblueColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 9,
                                                            horizontal: 9),
                                                    decoration: BoxDecoration(
                                                      color: lightblueColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Icon(
                                                      tranLists[index]
                                                                  ['status'] ==
                                                              'income'
                                                          ? Icons.trending_up
                                                          : Icons.trending_down,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${tranLists[index]['category']}',
                                                          style:
                                                              boldTextStyle(),
                                                        ),
                                                        Text(
                                                          '${tranLists[index]['date'].split(',').take(2).join(',').trim()}',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "\฿ ${FormatUtil.formatNumberWithDecimals((tranLists[index]['totalSum'].toDouble()))}",
                                                style: secondaryTextStyle(
                                                    color: tranLists[index]
                                                                ['status'] ==
                                                            'income'
                                                        ? lightgreenColor
                                                        : lightredColor,
                                                    size: 15),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
