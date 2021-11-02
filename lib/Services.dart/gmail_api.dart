import 'package:fire_mail/Services.dart/google_auth_api.dart';
import 'package:fire_mail/provider_service.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:provider/provider.dart';

class MailAPI {
  final GmailApi _gmailApi = GmailApi(client!);

  getMails(context) async {
    //Provider.of<CurrentUser>(context, listen: false).currentUserEmail!
    try {
      // Message message = Message();
      // _gmailApi.users.messages.send(message,
      //     Provider.of<CurrentUser>(context, listen: false).currentUserEmail!);
      WatchRequest watchRequest = WatchRequest(topicName: 'sarthak');
      _gmailApi.users.watch(watchRequest,
          Provider.of<CurrentUser>(context, listen: false).currentUserEmail!);
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
