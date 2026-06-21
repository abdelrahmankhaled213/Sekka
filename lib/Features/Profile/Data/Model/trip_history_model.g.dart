// GENERATED CODE - DO NOT MODIFY BY HAND
// Re-run:  flutter pub run build_runner build --delete-conflicting-outputs

part of 'trip_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripHistoryModelAdapter extends TypeAdapter<TripHistoryModel> {
  @override
  final int typeId = 2;

  @override
  TripHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripHistoryModel(
      id: fields[0] as String,
      fromStation: fields[1] as String,
      toStation: fields[2] as String,
      dateTime: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TripHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromStation)
      ..writeByte(2)
      ..write(obj.toStation)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

