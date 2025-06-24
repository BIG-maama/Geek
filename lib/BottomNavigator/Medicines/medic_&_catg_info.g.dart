// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medic_&_catg_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryInfoAdapter extends TypeAdapter<CategoryInfo> {
  @override
  final int typeId = 1;

  @override
  CategoryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryInfo(
      name: fields[0] as String,
      description: fields[1] as String,
      id: fields[2] as int,
      time_create: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.time_create);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PricesAdapter extends TypeAdapter<Prices> {
  @override
  final int typeId = 31;

  @override
  Prices read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prices(
      supplierPrice: fields[0] as int,
      peoplePrice: fields[1] as int,
      taxRate: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Prices obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.supplierPrice)
      ..writeByte(1)
      ..write(obj.peoplePrice)
      ..writeByte(2)
      ..write(obj.taxRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 4;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineFormAdapter extends TypeAdapter<MedicineForm> {
  @override
  final int typeId = 5;

  @override
  MedicineForm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineForm(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineForm obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineFormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 6;

  @override
  Status read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Status(
      isLow: fields[0] as bool,
      isOut: fields[1] as bool,
      isExpired: fields[2] as bool,
      isExpiringSoon: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isLow)
      ..writeByte(1)
      ..write(obj.isOut)
      ..writeByte(2)
      ..write(obj.isExpired)
      ..writeByte(3)
      ..write(obj.isExpiringSoon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicInfoAdapter extends TypeAdapter<MedicInfo> {
  @override
  final int typeId = 7;

  @override
  MedicInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicInfo(
      name: fields[0] as String,
      arabicName: fields[1] as String,
      barcode: fields[2] as String,
      type: fields[3] as String,
      quantity: fields[4] as String,
      alertQuantity: fields[5] as String,
      id: fields[7] as int,
      attachments: (fields[8] as List).cast<dynamic>(),
      prices: fields[9] as Prices,
      category: fields[10] as Category,
      medicineForm: fields[11] as MedicineForm,
      status: fields[12] as Status,
    );
  }

  @override
  void write(BinaryWriter writer, MedicInfo obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.arabicName)
      ..writeByte(2)
      ..write(obj.barcode)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.alertQuantity)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.attachments)
      ..writeByte(9)
      ..write(obj.prices)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.medicineForm)
      ..writeByte(12)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
