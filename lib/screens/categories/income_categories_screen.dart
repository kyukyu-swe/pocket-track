import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../provider/categories_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../widgets/confirm_delete_tran.dart';
import 'income_category_edit_screen.dart';

class IncomeCategoriesScreen extends StatefulWidget {
  const IncomeCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCategoriesScreen> createState() => _IncomeCategoriesScreenState();
}

class _IncomeCategoriesScreenState extends State<IncomeCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    var categoriesProvider = Provider.of<CategoriesProvider>(context);
    List<String> incCateList = categoriesProvider.incomeCategories;
    return Container(
      //margin: EdgeInsets.only(top: 90),
      color: secondaryColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 3),
                    itemCount: incCateList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 20,
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(5),
                          decoration: boxDecorationRoundedWithShadow(12,

                              /// change card color
                              backgroundColor: Colors.white54),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Text(
                                        '  ${index + 1}. ${incCateList[index]}',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: primaryTextStyle(size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              IncomeCategoryEditScreen(
                                            categoryName: incCateList[index],
                                          ),
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    if (incCateList.length <= 1) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Can\'t be deleted!',
                                              style:
                                                  primaryTextStyle(size: 14)),
                                          content: Text(
                                              'There must be at least one category',
                                              style:
                                                  primaryTextStyle(size: 14)),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Ok',
                                                  style: primaryTextStyle(
                                                      size: 14)),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      if (await confirmDeleteTran(context)) {
                                        categoriesProvider.deleteIncomeCategory(
                                            incCateList[index]);
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ));
                    },
                  ),
                ),

                //const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
