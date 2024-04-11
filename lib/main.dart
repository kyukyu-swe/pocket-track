import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'provider/auth.dart';
import 'provider/categories_provider.dart';
import 'provider/transactions_provider.dart';
import 'screens/login/auth_screen.dart';
import 'screens/main/overall_screen.dart';
import "package:provider/provider.dart";

import 'constants/colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.lightBlue);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, TransactionsProvider>(
          update: (ctx, auth, previous) => previous!..updateUser(auth.user!),
          create: (BuildContext context) => TransactionsProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, CategoriesProvider>(
          update: (ctx, auth, previous) => previous!..updateUser(auth.user!),
          create: (BuildContext context) => CategoriesProvider(null),
        ),
      ],
      child: Consumer<Auth>(builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pocket Track',
          theme: ThemeData(
            useMaterial3: false,
            //fontFamily: 'Pyidaungsu',
            primaryColor: primaryColor,
            primarySwatch: canvasColor,

            ///change font style
            textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme,
            ),
            tabBarTheme: const TabBarTheme(
                labelColor: secondaryTextColor,
                labelStyle:
                    TextStyle(color: secondaryTextColor), // color for text
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: primaryTextColor))),

            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: secondaryColor,
              selectionHandleColor: secondaryColor,
            ),
          ),
          home: auth.isAuth ? const OverallScreen() : const AuthScreen(),
        );
      }),
    );
  }
}
