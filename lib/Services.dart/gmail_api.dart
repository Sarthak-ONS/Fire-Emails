import 'package:fire_mail/Services.dart/google_auth_api.dart';
import 'package:fire_mail/provider_service.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:provider/provider.dart';

class MailAPI {
  final GmailApi _gmailApi = GmailApi(client!);

  getMails(context) async {
    //Provider.of<CurrentUser>(context, listen: false).currentUserEmail!
    try {
      ListMessagesResponse resh =
          await _gmailApi.users.messages.list("me", maxResults: 5);
      for (Message res in resh.messages!) {
        Message m = await _gmailApi.users.messages.get("me", res.id!);
        print(m.raw.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  getProfile(context) async {
    final res = await _gmailApi.users.getProfile(
      Provider.of<CurrentUser>(context, listen: false).currentUserEmail!,
    );
  }
}
