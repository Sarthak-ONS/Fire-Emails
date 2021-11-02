import 'package:fire_mail/provider_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:provider/provider.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

AuthClient? client;

class GoogleAuthApi {
  static final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      GmailApi.mailGoogleComScope,
    ],
  );

  Future login(context) async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth = await account!.authentication;
      client = await _googleSignIn.authenticatedClient();

      print(auth.accessToken);

      if (await _googleSignIn.isSignedIn()) {
        Provider.of<CurrentUser>(context, listen: false).changeUserDetails(
          account.displayName,
          account.photoUrl!,
          account.email,
          auth.accessToken!,
        );
        return _googleSignIn.currentUser;
      }
      // ignore: avoid_print
      print(auth.accessToken);
      Provider.of<CurrentUser>(context, listen: false).changeUserDetails(
        account.displayName!,
        account.photoUrl!,
        account.email,
        auth.accessToken!,
      );
    } catch (e) {
      return null;
    }
  }

  Future logout() async {
    try {
      _googleSignIn.signOut();
      return true;
    } catch (e) {
      return null;
    }
  }
}
