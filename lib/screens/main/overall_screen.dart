import 'package:flutter/material.dart';
import 'account_screen.dart';
import 'categories_screen.dart';
import 'spending_screen.dart';
import 'transactions_screen.dart';
import '../new_transactions/add_transaction_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../provider/categories_provider.dart';
import '../../provider/transactions_provider.dart';

class OverallScreen extends StatefulWidget {
  const OverallScreen({super.key});

  @override
  _OverallScreenState createState() => _OverallScreenState();
}

class _OverallScreenState extends State<OverallScreen> {
  List<Widget> _pages = [];
  int selectedPos = 0;

  @override
  void initState() {
    Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
    _pages = [
      SpendingScreen(),
      TransactionsScreen(),
      CategoriesScreen(),
      AccountScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget tabItem(var pos, String title, IconData icon) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedPos = pos;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Image.asset(
              //   'assets/images/$image.png',
              //   color: selectedPos == pos ? primaryColor : Colors.black54,
              //   width: size,
              // ),
              Icon(
                icon,
                color: selectedPos == pos ? primaryColor : Colors.black54,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  //height: 0.7,
                  color: selectedPos == pos ? primaryColor : Colors.black54,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[selectedPos],
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(color: secondaryColor, boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tabItem(0, 'Spending', Icons.add_chart_sharp),
                  tabItem(1, 'Trans', Icons.table_chart),
                  const SizedBox(width: 45, height: 45),
                  tabItem(2, 'Categories', Icons.pie_chart),
                  tabItem(3, 'Account', Icons.account_circle_rounded),
                ],
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(),
              ));
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
