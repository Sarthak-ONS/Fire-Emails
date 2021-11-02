import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fire_mail/Services.dart/file_picker_api.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';

import '../provider_service.dart';

class ComposeEmailScreen extends StatefulWidget {
  const ComposeEmailScreen({Key? key}) : super(key: key);

  @override
  _ComposeEmailScreenState createState() => _ComposeEmailScreenState();
}

class _ComposeEmailScreenState extends State<ComposeEmailScreen> {
  final TextEditingController _subController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  late String fileName = "";
  late String filePath = "";

  List<Attachment> att = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _subController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    labelText: 'Subject',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    labelText: 'Enter The Body of The Email',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () async {
                        PlatformFile pickedFilePath =
                            await FilePickerAPI().pickFile();
                        setState(() {
                          fileName = pickedFilePath.name;
                          filePath = pickedFilePath.path!;
                        });
                        print(pickedFilePath.name);
                        print(pickedFilePath.path);
                        addAttachments(pickedFilePath.path!);
                        //
                      },
                      icon: const Icon(
                        Icons.file_copy,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Text(fileName),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(),
                    ),
                  ),
                  onPressed: sendEmail,
                  child: const Text(
                    'Send Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSendText() => Image.network(
        "https://i.pinimg.com/originals/98/64/9a/98649add72e05e3cc1b8ae0e6f553c8e.gif",
        height: 150,
        width: 150,
      );
  Future sendEmail() async {
    //CC Stands For Carbon Copy
    //BCC Stands For Blind Carbon Copy.
    if (Provider.of<CurrentUser>(context, listen: false).recipients!.isEmpty) {
      return;
    }
    if (_subController.text.isEmpty) {
      print("Enter the Body and Subject");
      return;
    }
    final smtpServer = gmailSaslXoauth2(
      Provider.of<CurrentUser>(context, listen: false).currentUserEmail!,
      Provider.of<CurrentUser>(context, listen: false).currentUserAuthToken!,
    );
    List? addrs = [];
    for (var i = 0;
        i < Provider.of<CurrentUser>(context, listen: false).recipients!.length;
        i++) {
      if (Provider.of<CurrentUser>(context, listen: false)
              .recipients![i]
              .email !=
          null) {
        addrs.add(Provider.of<CurrentUser>(context, listen: false)
            .recipients![i]
            .email);
      }
    }
    print(addrs);

    final message = Message()
      ..from = Address(
          Provider.of<CurrentUser>(context, listen: false).currentUserEmail!,
          Provider.of<CurrentUser>(context, listen: false).currentUserName!)
      ..recipients = addrs
      ..subject = _subController.text
      ..text = _bodyController.text
      ..attachments = att;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          titlePadding: const EdgeInsets.all(0.0),
          insetPadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.all(0.0),
          buttonPadding: const EdgeInsets.all(0.0),
          content: buildSendText(),
        ),
      );
      SendReport res = await send(message, smtpServer);
      var x = res.mail;
      print(x.from);
      _bodyController.clear();
      _subController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Emails were sent SuccessFully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } on MailerException catch (e) {
      print("////////");
      print(e);
    }
    addRecipientsName();
  }

  addAttachments(String path) {
    att.add(
      FileAttachment(File(path))
        ..location = Location.attachment
        ..cid = '<myimg@3.141>',
    );
  }

  addRecipientsName() {
    if (_bodyController.text.contains("#RECI")) {
      print(_bodyController.text.indexOf("#RECI"));
    }
  }
}
