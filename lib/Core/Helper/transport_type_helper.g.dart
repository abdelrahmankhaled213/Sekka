// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_type_helper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransportTypeAdapter extends TypeAdapter<TransportType> {
  @override
  final int typeId = 1;

  @override
  TransportType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransportType.metro;
      case 1:
        return TransportType.monorail;
      case 2:
        return TransportType.bus;
      case 3:
        return TransportType.microbus;
      case 4:
        return TransportType.transfer;
      default:
        return TransportType.metro;
    }
  }

  @override
  void write(BinaryWriter writer, TransportType obj) {
    switch (obj) {
      case TransportType.metro:
        writer.writeByte(0);
        break;
      case TransportType.monorail:
        writer.writeByte(1);
        break;
      case TransportType.bus:
        writer.writeByte(2);
        break;
      case TransportType.microbus:
        writer.writeByte(3);
        break;
      case TransportType.transfer:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransportTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
