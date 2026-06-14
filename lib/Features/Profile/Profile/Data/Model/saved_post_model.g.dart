// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedPostModelAdapter extends TypeAdapter<SavedPostModel> {
  @override
  final int typeId = 3;

  @override
  SavedPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedPostModel(
      postId: fields[0] as String,
      savedAt: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedPostModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
