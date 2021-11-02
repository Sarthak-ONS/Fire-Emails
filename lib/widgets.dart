import 'dart:math';

import 'package:fire_mail/colors.dart';
import 'package:flutter/material.dart';

import 'Models/email_model.dart';

Widget buildEmailItem(EmailModel emailModel) {
  final _random = Random();
  return ListTile(
    title: Text(
      emailModel.subject!,
    ),
    subtitle: Text(
      emailModel.body!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    leading: CircleAvatar(
      backgroundColor: colorList[_random.nextInt(colorList.length)],
      child: Center(
        child: Text(
          '${emailModel.body!.substring(0, 1).toUpperCase()}${emailModel.subject!.substring(0, 1).toUpperCase()}',
        ),
      ),
    ),
  );
}
