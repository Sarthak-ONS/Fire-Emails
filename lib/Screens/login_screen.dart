// ignore_for_file: avoid_print

import 'package:fire_mail/Screens/home_screen.dart';
import 'package:fire_mail/Services.dart/google_auth_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   fit: BoxFit.cover,
          //   image: NetworkImage(
          //     "https://thumbs.gfycat.com/TotalUnawareAsiandamselfly-max-1mb.gif",
          //   ),
          // ),
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(context),
        body: Center(
          child: Stack(
            //    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoginButton(context),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.mail_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'FireMail',
                        style: TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@',
                        style: TextStyle(
                          fontSize: 38,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSheetHeading() => const Text(
        'Please Read The Following Instructions',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget buildRuleOne() => const Text(
        'Please Login Using the account from which you want to send emails to your receipents.',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      );

  Widget buildRuleTwo() => const Text(
        'Please allow us to access your Gmail, so that you can send your emails efficiently',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      );

  Widget buildRuleThree() => const Text(
        'We ensure you that only you can modify your mails with your proivided Gmail',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      );

  buildBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: true,
      shape: const RoundedRectangleBorder(),
      context: context,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
          child: Column(
            children: [
              buildSheetHeading(),
              const SizedBox(
                height: 15,
              ),
              buildRuleOne(),
              const SizedBox(
                height: 10,
              ),
              buildRuleTwo(),
              const SizedBox(
                height: 10,
              ),
              buildRuleThree()
            ],
          ),
        ),
      ),
    );
  }

  buildAppBar(context) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              buildBottomSheet(context);
            },
            icon: const Icon(
              Icons.info,
              size: 24,
              color: Colors.white,
            ),
          )
        ],
      );

  Widget buildLoginButton(context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xff023e8a);
            }
            return const Color(0xff0276E8);
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return size 40, otherwise 20
            if (states.contains(MaterialState.pressed)) {
              return const TextStyle(fontSize: 21, fontWeight: FontWeight.w300);
            }
            return const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
          }),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Text(
            "Login using Google",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () async {
          print("Signing User with Google");
          final user = await GoogleAuthApi().login(context);
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'User has not Signed In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
            return;
          }
          Navigator.pushNamedAndRemoveUntil(
              context, HomePageScreen.id, (route) => false);
        },
      );
}
