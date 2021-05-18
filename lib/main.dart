import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/model.dart';
import 'signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlueStacksApp());
}

class BlueStacksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Initial Page',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashPage());
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool? isInitialLoading;
  bool? isCompleted;

  @override
  void initState() {
    UserModel();
    isInitialLoading = true;
    isCompleted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget renderWidget;
    if (isInitialLoading!) {
      isInitialLoading = false;
      renderWidget = Stack(children: [
        // Container(decoration: const BoxDecoration(color: Colors.white)),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: Image.asset('assets/images/bs-logo.png',
                    fit: BoxFit.contain, scale: 0.4)))
      ]);
      Future.delayed(const Duration(milliseconds: 500), () => setState(() {}));
    } else if (!isInitialLoading! && !isCompleted!) {
      renderWidget = Stack(children: [
        // Container(decoration: const BoxDecoration(color: Colors.white)),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: Image.asset('assets/images/bs-logo.png',
                    fit: BoxFit.contain, scale: 0.4))),
        Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.25),
            child: const CircularProgressIndicator())
      ]);
      Future.delayed(const Duration(milliseconds: 2000), () {
        isCompleted = true;
        setState(() {});
      });
    } else {
      renderWidget = UserModel.isUserLoggedIn ? HomePage() : LoginPage();
    }
    return renderWidget;
  }
}
