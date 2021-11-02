import 'package:fire_mail/Models/email_model.dart';
import 'package:fire_mail/Models/recipient_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class CurrentUser extends ChangeNotifier {
  String? currentUserName;
  String? currentUserEmail;
  String? currentUserAuthToken;
  String? userPhotoUrl;
  List<RecipientsModel>? recipients = [];
  GoogleSignInAuthentication? googleSignInAuthenticatio;
  int? totalEmailSent = 0;

  changeUserDetails(String? name, String? url, String? email, String? token) {
    currentUserName = name;
    currentUserEmail = email;
    currentUserAuthToken = token;
    userPhotoUrl = url;
    notifyListeners();
  }

  addEmailSentCount(int count) {
    totalEmailSent = totalEmailSent! + count;
    notifyListeners();
  }

  changeSignINAuthAccount(
      GoogleSignInAuthentication googleSignInAuthentication) {
    googleSignInAuthenticatio = googleSignInAuthentication;
    notifyListeners();
  }

  addToRecipientsList(RecipientsModel model) {
    recipients!.add(model);
    notifyListeners();
  }

  addAEmailToDatabase(
      {String? body, String? subject, List? add, List<String>? fileList}) {
    final emailModel = EmailModel()
      ..body = body
      ..subject = subject
      ..addressList = add
      ..listFilePath = fileList;

    final box = Boxes.getEmailModel();
    box.add(emailModel);
    notifyListeners();
  }
}

class Boxes {
  static Box<EmailModel> getEmailModel() => Hive.box<EmailModel>('email_Model');
}
