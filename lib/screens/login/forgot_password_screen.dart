import 'package:flutter/material.dart';
import 'forgot_password_widget.dart';
import '../../constants/colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/auth';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: secondaryColor,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Flexible(
                  //   child: Container(
                  //     margin: const EdgeInsets.only(bottom: 20.0),
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 8.0, horizontal: 94.0),
                  //     transform: Matrix4.rotationZ(-8 * pi / 180)
                  //       ..translate(-10.0),
                  //     // ..translate(-10.0),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.deepOrange.shade900,
                  //       boxShadow: const [
                  //         BoxShadow(
                  //           blurRadius: 8,
                  //           color: Colors.black26,
                  //           offset: Offset(0, 2),
                  //         )
                  //       ],
                  //     ),
                  //
                  //     child: const Text(
                  //       'MyShop',
                  //       style: TextStyle(
                  //         fontSize: 50,
                  //         fontFamily: 'Anton',
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    child: Image.asset(
                      'assets/images/wallet.png',
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 20),

                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const ForgotPasswordWidget(),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
