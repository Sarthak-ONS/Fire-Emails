import 'package:fire_mail/Models/recipient_model.dart';
import 'package:hive/hive.dart';

part 'email_model.g.dart';

@HiveType(typeId: 0)
class EmailModel extends HiveObject {
  @HiveField(0)
  String? body;

  @HiveField(1)
  String? subject;

  @HiveField(2)
  List? addressList;

  @HiveField(3)
  List<String>? listFilePath;
}
