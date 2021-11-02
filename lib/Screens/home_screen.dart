// ignore_for_file: avoid_print

import 'dart:math';

import 'package:fire_mail/Models/email_model.dart';
import 'package:fire_mail/Screens/login_screen.dart';
import 'package:fire_mail/Screens/select_recipients.dart';
import 'package:fire_mail/Services.dart/gmail_api.dart';
import 'package:fire_mail/Services.dart/google_auth_api.dart';
import 'package:fire_mail/colors.dart';
import 'package:fire_mail/provider_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
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
                  Icons.add,
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ValueListenableBuilder<Box<EmailModel>>(
                  valueListenable: Boxes.getEmailModel().listenable(),
                  builder: (context, box, _) {
                    final emailModel = box.values.toList().cast<EmailModel>();
                    return ListView.builder(
                      dragStartBehavior: DragStartBehavior.down,
                      itemCount: emailModel.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: const SlidableStrechActionPane(),
                          actionExtentRatio: 0.25,
                          child: buildEmailItem(
                            emailModel[index],
                          ),
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                print("Calling delete");
                                Provider.of<CurrentUser>(context, listen: false)
                                    .deleteEmailFromDataBase(emailModel[index]);
                              },
                              closeOnTap: true,
                            )
                          ],
                          actions: const [
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              },
              childCount: 1000, // 1000 list items
            ),
          )
        ],
      ),
    );
  }
}
