// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_inventory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryCountAdapter extends TypeAdapter<InventoryCount> {
  @override
  final int typeId = 10;

  @override
  InventoryCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryCount(
      id: fields[0] as int,
      countNumber: fields[1] as String,
      countDate: fields[2] as String,
      status: fields[3] as String,
      createdBy: fields[4] as String,
      items: (fields[5] as List).cast<InventoryItem>(),
      created_at: fields[8] as String,
      items_count: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryCount obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.countNumber)
      ..writeByte(2)
      ..write(obj.countDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.items_count)
      ..writeByte(8)
      ..write(obj.created_at)
      ..writeByte(5)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InventoryItemAdapter extends TypeAdapter<InventoryItem> {
  @override
  final int typeId = 11;

  @override
  InventoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryItem(
      id: fields[0] as int,
      medicine: fields[1] as Medicine,
      systemQuantity: fields[2] as int,
      actualQuantity: fields[3] as int,
      difference: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicine)
      ..writeByte(2)
      ..write(obj.systemQuantity)
      ..writeByte(3)
      ..write(obj.actualQuantity)
      ..writeByte(4)
      ..write(obj.difference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 12;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      id: fields[0] as int,
      name: fields[1] as String,
      barCode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.barCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
