// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invocies_pro.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 80;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      id: fields[0] as int,
      invoiceNumber: fields[1] as String,
      invoiceDate: fields[2] as String,
      dueDate: fields[3] as String,
      status: fields[4] as String,
      totalAmount: fields[5] as String,
      supplierName: fields[6] as String,
      itemsCount: fields[7] as int,
      medicines: (fields[8] as List).cast<MedicineItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.invoiceNumber)
      ..writeByte(2)
      ..write(obj.invoiceDate)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.supplierName)
      ..writeByte(7)
      ..write(obj.itemsCount)
      ..writeByte(8)
      ..write(obj.medicines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineItemAdapter extends TypeAdapter<MedicineItem> {
  @override
  final int typeId = 81;

  @override
  MedicineItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineItem(
      medicineName: fields[0] as String,
      unitPrice: fields[1] as String,
      quantity: fields[2] as int,
      totalPrice: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.medicineName)
      ..writeByte(1)
      ..write(obj.unitPrice)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.totalPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
