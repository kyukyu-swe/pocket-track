import 'package:flutter/material.dart';
import '../../provider/transactions_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../widgets/confirm_delete_tran.dart';

class IncomeTransactionsScreen extends StatefulWidget {
  final DateTime selectedDate;
  const IncomeTransactionsScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<IncomeTransactionsScreen> createState() =>
      _IncomeTransactionsScreenState();
}

class _IncomeTransactionsScreenState extends State<IncomeTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionsProvider transProvider =
        Provider.of<TransactionsProvider>(context);
    List<Map<String, dynamic>> dailyTranList =
        transProvider.incomeTransactionsForOneMonth();
    if (dailyTranList.isEmpty) {
      return Center(
        child: Text(
          'No transactions for this month!',
          style: primaryTextStyle(),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: secondaryColor),
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: RefreshIndicator(
        onRefresh: () async {
          transProvider.fetchTransactions(widget.selectedDate);
        },
        child: ListView(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyTranList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: boxDecorationRoundedWithShadow(12,

                        /// change card color
                        backgroundColor: Colors.white54),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dailyTranList[index]['date'],
                                style: primaryTextStyle(size: 15)),
                            Text(
                              dailyTranList[index]['totalSum'].toString(),
                              style: secondaryTextStyle(
                                  color: Colors.green, size: 15),
                            ),
                          ],
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dailyTranList[index]['tranList'].length,
                          itemBuilder: (context, index2) {
                            return Dismissible(
                              key: UniqueKey(),
                              confirmDismiss: (direction) {
                                return confirmDeleteTran(context);
                              },
                              onDismissed: (direction) async {
                                await transProvider.deleteIncome(
                                    dailyTranList[index]['tranList'][index2],
                                    widget.selectedDate);
                              },
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dailyTranList[index]['tranList']
                                                  [index2]
                                              .category,
                                          overflow: TextOverflow.ellipsis,
                                          style: primaryTextStyle(size: 14),
                                        ),
                                        if (dailyTranList[index]['tranList']
                                                    [index2]
                                                .note !=
                                            null)
                                          Text(
                                            dailyTranList[index]['tranList']
                                                        [index2]
                                                    .note ??
                                                '',
                                            style: primaryTextStyle(
                                                weight: FontWeight.w500,
                                                color: primaryTextColor
                                                    .withOpacity(0.7),
                                                size: 12),
                                          )
                                      ],
                                    ),
                                    Text(
                                      dailyTranList[index]['tranList'][index2]
                                          .amount
                                          .toString(),
                                      style: primaryTextStyle(size: 14),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
