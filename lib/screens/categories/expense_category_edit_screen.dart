import '../../provider/categories_provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseCategoryEditScreen extends StatefulWidget {
  final String? categoryName;
  const ExpenseCategoryEditScreen({super.key, this.categoryName});

  @override
  _ExpenseCategoryEditScreenState createState() =>
      _ExpenseCategoryEditScreenState();
}

class _ExpenseCategoryEditScreenState extends State<ExpenseCategoryEditScreen> {
  final _categoryNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.categoryName != null) {
      _categoryNameController.text = widget.categoryName!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_categoryNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CategoriesProvider>(context, listen: false)
        .addOrEditExpenseCategory(
      oldName: widget.categoryName,
      newName: _categoryNameController.text,
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 30),
          decoration: boxDecorationWithRoundedCorners(
              backgroundColor: secondaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Text(
                        widget.categoryName == null
                            ? 'Add expense category'
                            : 'Edit expense category',
                        style: primaryTextStyle(),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: primaryColor,
                        )),
                  ],
                ),
                Divider(thickness: 1),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _categoryNameController,
                    decoration:
                        const InputDecoration(labelText: 'Category name'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _onSave,
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(
                                'Save',
                                style: secondaryTextStyle(),
                              ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
