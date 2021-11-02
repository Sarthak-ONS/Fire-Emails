// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmailModelAdapter extends TypeAdapter<EmailModel> {
  @override
  final int typeId = 0;

  @override
  EmailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailModel()
      ..body = fields[0] as String?
      ..subject = fields[1] as String?
      ..addressList = (fields[2] as List?)?.cast<dynamic>()
      ..listFilePath = (fields[3] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, EmailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.body)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.addressList)
      ..writeByte(3)
      ..write(obj.listFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
