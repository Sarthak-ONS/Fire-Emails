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
      backgroundColor: const Color(0xff151719),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff151719),
        title: Text('Compose Mail'),
        actions: [
          IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () async {
              PlatformFile pickedFilePath = await FilePickerAPI().pickFile();
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
              Icons.attach_email_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            alignment: Alignment.centerLeft,
            onPressed: sendEmail,
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    enabled: false,
                    fillColor: const Color(0xff23262B),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    labelText:
                        'From :  ${Provider.of<CurrentUser>(context).currentUserEmail!}',
                    labelStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    enabled: false,
                    fillColor: Color(0xff23262B),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    labelText: 'To : Recipients are already Selected',
                    labelStyle: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _subController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xff23262B),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    hintText: 'Subject',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
                TextField(
                  minLines: 1,
                  maxLines: 20,
                  controller: _bodyController,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xff23262B),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff23262B),
                      ),
                    ),
                    hintText: 'Body',
                    hintStyle: TextStyle(
                      color: Colors.white54,
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
    print("Composing and Sending Mail");
    Provider.of<CurrentUser>(context, listen: false).addAEmailToDatabase(
      body:
          "The body of an email message is essentially the letter inside of the envelope. Consider how you read a letter you receive in the postal mail. You open the envelope and unfold the paper to view the contents of the message.",
      subject: "College Admission Issue Enquiry",
      fileList: [
        filePath,
      ],
      add: [
        "agarwalsarthak456@gmail.com",
        "sarthaak1931006@akgec.ac.in",
        "kpriyanshuse@gmail.com"
      ],
    );
    return;
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
      Provider.of<CurrentUser>(context, listen: false).addAEmailToDatabase(
        body: _bodyController.text,
        subject: _subController.text,
        fileList: [
          filePath,
        ],
        add: att,
      );
      Provider.of<CurrentUser>(context, listen: false)
          .addEmailSentCount(addrs.length);
      print(res.toString());
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
