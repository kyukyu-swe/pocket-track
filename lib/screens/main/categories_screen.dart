import 'package:flutter/material.dart';
import '../categories/expense_categories_screen.dart';
import '../categories/income_categories_screen.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../categories/expense_category_edit_screen.dart';
import '../categories/income_category_edit_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          shadowColor: secondaryColor,
          title: Text(
            'Categories',
            style: secondaryTextStyle(size: 16),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    if (_selectedIndex == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncomeCategoryEditScreen(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseCategoryEditScreen(),
                          ));
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    color: secondaryColor,
                  ));
              // use index at here...
            }),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: secondaryColor,
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(0))),
                width: MediaQuery.of(context).size.width,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      /// transaction history tab bar
                      TabBar(
                          labelColor: primaryColor,
                          indicatorColor: primaryTextColor,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: primaryTextStyle(size: 18),
                          onTap: (value) {
                            setState(() {
                              _selectedIndex =
                                  value; // Update the selected index on tab tap
                            });
                          },
                          tabs: [
                            Tab(text: 'Income'),
                            Tab(text: 'Expense'),
                          ]),
                      Expanded(
                        child: TabBarView(children: [
                          IncomeCategoriesScreen(),
                          ExpenseCategoriesScreen(),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
