import 'dart:math';

import 'package:fire_mail/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'Models/email_model.dart';

Widget buildEmailItem(EmailModel emailModel) {
  final _random = Random();
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xffF7F1DC),
      borderRadius: BorderRadius.circular(15.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    margin: const EdgeInsets.symmetric(vertical: 0.125),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: colorList[_random.nextInt(colorList.length)],
          child: Center(
            child: Text(
              emailModel.body!.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emailModel.subject!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                emailModel.body!,
                style: const TextStyle(fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.star_border_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
            Text(
              DateFormat.jm().format(DateTime.now()),
              style: const TextStyle(fontSize: 12),
            )
          ],
        )
      ],
    ),
  );
}
// ListTile(
//     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//     minLeadingWidth: 20,

//     trailing: IconButton(
//       onPressed: () {},
//       icon: const Icon(
//         Icons.star_border_outlined,
//         color: Colors.black,
//       ),
//     ),
//   )