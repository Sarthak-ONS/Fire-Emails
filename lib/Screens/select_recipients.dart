// ignore_for_file: avoid_print
import 'dart:io';
import 'package:fire_mail/provider_service.dart';
import 'package:fire_mail/Models/recipient_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class SelectRecepients extends StatefulWidget {
  static String id = "SelectRecepients";
  const SelectRecepients({Key? key}) : super(key: key);

  @override
  _SelectRecepientsState createState() => _SelectRecepientsState();
}

class _SelectRecepientsState extends State<SelectRecepients> {
  File? fileMain;
  Future pickFile() async {
    setState(() {
      Provider.of<CurrentUser>(context, listen: false).recipients!.clear();
    });
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['xlsx'], type: FileType.custom);
    if (result != null) {
      fileMain = File(result.files.single.path!);
      print(fileMain!.path);
      readDataFromFile();
    } else {
      // User canceled the picker
      print("User Cancelled picking");
    }
  }

  readDataFromFile() async {
    var filePath = fileMain!.path;
    print(filePath);
    var bytes = File(filePath).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for (var table in decoder.tables.keys) {
      print(table);
      print(decoder.tables[table]!.maxCols);
      print(decoder.tables[table]!.maxRows);
      for (var i = 0; i < decoder.tables[table]!.rows.length; i++) {
        var row = decoder.tables[table]!.rows;
        print("The $i Recipient is : ${row[i][0]} ${row[i][1]}");
        if (row[i][0] != 'Name' &&
            row[i][1] != 'Email' &&
            row[i][0] != null &&
            row[i][1] != null &&
            Provider.of<CurrentUser>(context, listen: false)
                    .recipients!
                    .contains(
                        RecipientsModel(name: row[i][0], email: row[i][1])) !=
                true) {
          print(row[i][1]);
          Provider.of<CurrentUser>(context, listen: false).addToRecipientsList(
              RecipientsModel(name: row[i][0], email: row[i][1]));
        }
      }
    }
    setState(() {});
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final columns = ['Emails', 'Name'];

  Widget buildHeading() => const Text(
        "Add a Recipient to the List",
        style: TextStyle(fontSize: 20),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Receipents'),
        actions: [
          IconButton(
            onPressed: () {
              pickFile();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        buildHeading(),
                        const SizedBox(
                          height: 8,
                        ),
                        builTextFormField(_name, "Name"),
                        const SizedBox(
                          height: 8,
                        ),
                        builTextFormField(_email, "Email"),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_name.text.isEmpty || _email.text.isEmpty) {
                              return;
                            }
                            Provider.of<CurrentUser>(
                              context,
                              listen: false,
                            ).addToRecipientsList(
                              RecipientsModel(
                                  name: _name.text, email: _email.text),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Add Recipients'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          columns: getColumns(columns),
          rows: getRows(Provider.of<CurrentUser>(context).recipients!),
        ),
      ),
    );
  }

  Widget builTextFormField(TextEditingController controller, String text) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.blue,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.blue,
            ),
          ),
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );

  List<DataRow> getRows(List<RecipientsModel> reces) {
    return reces.map(
      (RecipientsModel rece) {
        final cells = [rece.email, rece.name];
        return DataRow(
          cells: Utils.modelBuilder(
            cells,
            (index, cell) {
              return DataCell(Text('$cell'));
            },
          ),
        );
      },
    ).toList();
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns
        .map(
          (String column) => DataColumn(
            label: Text(
              column,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )
        .toList();
  }
}
