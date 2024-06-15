import '../../provider/categories_provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoryEditScreen extends StatefulWidget {
  final String? categoryName;
  const IncomeCategoryEditScreen({super.key, this.categoryName});

  @override
  _IncomeCategoryEditScreenState createState() =>
      _IncomeCategoryEditScreenState();
}

class _IncomeCategoryEditScreenState extends State<IncomeCategoryEditScreen> {
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
        .addOrEditIncomeCategory(
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
              borderRadius: BorderRadius.only(topRight: Radius.circular(0))),
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
                            ? 'Add Income Category'
                            : 'Edit Income Category',
                        style: primaryTextStyle(size: 18),
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
                    decoration: InputDecoration(labelText: 'Category name'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.only(top: 10, bottom: 10)),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(
                                'Save',
                                style: boldTextStyle(
                                    size: 15, color: Colors.white),
                              ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
