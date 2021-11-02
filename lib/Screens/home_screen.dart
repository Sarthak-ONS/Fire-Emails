// ignore_for_file: avoid_print

import 'dart:math';

import 'package:fire_mail/Models/email_model.dart';
import 'package:fire_mail/Screens/login_screen.dart';
import 'package:fire_mail/Screens/select_recipients.dart';
import 'package:fire_mail/Services.dart/gmail_api.dart';
import 'package:fire_mail/Services.dart/google_auth_api.dart';
import 'package:fire_mail/provider_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'compose_email.dart';

class HomePageScreen extends StatefulWidget {
  static String id = "HomePageScreen";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    Hive.box('email_Model').close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      backgroundColor: const Color(0xfff5f5f5),
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              accountName: Text(
                Provider.of<CurrentUser>(context).currentUserName!,
              ),
              accountEmail: Text(
                Provider.of<CurrentUser>(context).currentUserEmail!,
              ),
              currentAccountPicture: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 35,
                  foregroundImage: NetworkImage(
                    Provider.of<CurrentUser>(context).userPhotoUrl!,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Select Receipients'),
              onTap: () async {
                Navigator.pushNamed(context, SelectRecepients.id);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                final isLogout = await GoogleAuthApi().logout();
                if (isLogout) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                }
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: ClipOval(
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Image.network(
                    Provider.of<CurrentUser>(context).userPhotoUrl!,
                  ),
                ),
              ),
            ),
            backgroundColor: const Color(0xfff5f5f5),
            expandedHeight: 200,
            floating: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(8.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.mail_outline,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Inbox',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            //title: Text('My App Bar'),
            actions: [
              IconButton(
                onPressed: () {
                  // MailAPI().getMails(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ComposeEmailScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
          buildImages()
        ],
      ),
    );
  }

  List<Color> colorList = [
    Colors.red,
    Colors.black,
    Colors.green,
    Colors.cyan,
    Colors.yellow
  ];
  Widget buildImages() => SliverToBoxAdapter(
        child: ValueListenableBuilder<Box<EmailModel>>(
          valueListenable: Boxes.getEmailModel().listenable(),
          builder: (context, box, _) {
            final _random = Random();
            final emailModel = box.values.toList().cast<EmailModel>();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: emailModel.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    emailModel[index].body!,
                  ),
                  subtitle: Text(
                    emailModel[index].subject!,
                  ),
                  leading: CircleAvatar(
                    backgroundColor:
                        colorList[_random.nextInt(colorList.length)],
                    child: Center(
                      child: Text(
                        '${emailModel[index].body!.substring(0, 1)}${emailModel[index].subject!.substring(0, 1)}',
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
