import 'package:fire_mail/recipient_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser extends ChangeNotifier {
  String? currentUserName;
  String? currentUserEmail;
  String? currentUserAuthToken;
  String? userPhotoUrl;
  List<RecipientsModel>? recipients = [];
  GoogleSignInAuthentication? googleSignInAuthenticatio;

  changeUserDetails(String? name, String? url, String? email, String? token) {
    currentUserName = name;
    currentUserEmail = email;
    currentUserAuthToken = token;
    userPhotoUrl = url;
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
}
