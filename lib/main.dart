import 'package:fire_mail/Screens/home_screen.dart';
import 'package:fire_mail/Screens/login_screen.dart';
import 'package:fire_mail/Screens/select_recipients.dart';
import 'package:fire_mail/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.id: (context) => const LoginScreen(),
          HomePageScreen.id: (context) => const HomePageScreen(),
          SelectRecepients.id: (context) => const SelectRecepients()
        },
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        initialRoute: LoginScreen.id,
      ),
    );
  }
}
