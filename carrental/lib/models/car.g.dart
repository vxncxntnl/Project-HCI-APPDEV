// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 0;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      id: fields[0] as int,
      name: fields[1] as String,
      pricePerDay: fields[2] as double,
      isAvailable: fields[3] as bool,
      model: fields[4] as String,
      year: fields[5] as int?,
      imagePath: fields[6] as String,
      imageUrl: fields[7] as String,
      rentedBy: fields[8] as String?,
      rentalDays: fields[9] as int,
      isPaid: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pricePerDay)
      ..writeByte(3)
      ..write(obj.isAvailable)
      ..writeByte(4)
      ..write(obj.model)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.rentedBy)
      ..writeByte(9)
      ..write(obj.rentalDays)
      ..writeByte(10)
      ..write(obj.isPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
