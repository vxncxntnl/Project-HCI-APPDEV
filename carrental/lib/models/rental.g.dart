// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentalAdapter extends TypeAdapter<Rental> {
  @override
  final int typeId = 1;

  @override
  Rental read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rental(
      id: fields[0] as int,
      customerName: fields[1] as String,
      contactNumber: fields[2] as String,
      duration: fields[3] as int,
      isPaid: fields[4] as bool,
      carId: fields[5] as int,
      totalCost: fields[6] as double,
      paymentMethod: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Rental obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.contactNumber)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.isPaid)
      ..writeByte(5)
      ..write(obj.carId)
      ..writeByte(6)
      ..write(obj.totalCost)
      ..writeByte(7)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
