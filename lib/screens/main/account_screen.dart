import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../provider/auth.dart';
import '../account/change_password_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              backgroundColor: secondaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: Text(
                          'Setting',
                          style: primaryTextStyle(),
                        ),
                      ),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: secondaryColor.withOpacity(0.7),
                            border: Border.all(color: secondaryColor),
                          ),
                          child: Icon(Icons.settings,
                              color: primaryColor, size: 20)),
                      //SizedBox(width: 10)
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Image.asset(
                        'assets/images/wallet.png',
                        height: 200,
                      ),
                      Text(
                        auth.currentUser!.email!,
                        style: primaryTextStyle(size: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                        padding: EdgeInsets.all(12.0),
                        decoration: boxDecorationRoundedWithShadow(12,

                            /// change card color
                            backgroundColor: Colors.white54),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordScreen(),
                                      ));
                                },
                                leading: Icon(Icons.password,
                                    size: 24, color: primaryColor),
                                title: Text('Change password',
                                    style: primaryTextStyle()),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: primaryColor, size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Do you want to log out ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () async {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            Provider.of<Auth>(context,
                                                    listen: false)
                                                .logout();
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                leading: Icon(Icons.logout,
                                    size: 24, color: primaryColor),
                                title:
                                    Text('Logout', style: primaryTextStyle()),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: primaryColor, size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
