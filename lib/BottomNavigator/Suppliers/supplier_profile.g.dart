// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplierProfileAdapter extends TypeAdapter<SupplierProfile> {
  @override
  final int typeId = 0;

  @override
  SupplierProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupplierProfile(
      company_name: fields[0] as String,
      contact_person_name: fields[1] as String,
      phone: fields[2] as String,
      email: fields[3] as String,
      address: fields[4] as String,
      payment_method: fields[5] as String,
      credit_limit: fields[6] as int,
      date: fields[7] as String,
      id: fields[8] as int,
      status: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SupplierProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.company_name)
      ..writeByte(1)
      ..write(obj.contact_person_name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.payment_method)
      ..writeByte(6)
      ..write(obj.credit_limit)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
