import 'package:flutter/material.dart';
import '../categories/expense_categories_screen.dart';
import '../categories/income_categories_screen.dart';
import '../../constants/colors.dart';
import '../../constants/style.dart';
import '../categories/expense_category_edit_screen.dart';
import '../categories/income_category_edit_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Categories',
            style: secondaryTextStyle(size: 16),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    final index = DefaultTabController.of(context).index;
                    if (index == 0) {
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

          /// categories tab bar
          bottom: TabBar(
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.white60,
              labelStyle: secondaryTextStyle(size: 14),
              tabs: const [
                Tab(text: 'Income'),
                Tab(text: 'Expense'),
              ]),
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(children: [
                IncomeCategoriesScreen(),
                ExpenseCategoriesScreen(),
              ]),
            )
          ],
        ),
      )),
    );
  }
}
