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
