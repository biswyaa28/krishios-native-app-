import 'package:hive/hive.dart';

class ScanResult extends HiveObject {
  final String id;
  final String cropName;
  final String fieldName;
  final String diagnosis;
  final double healthScore;
  final DateTime scannedAt;
  final String? imagePath;
  final double? confidence;
  final String? treatment;
  final double? latitude;
  final double? longitude;
  final String? userId;

  ScanResult({
    required this.id,
    required this.cropName,
    required this.fieldName,
    required this.diagnosis,
    required this.healthScore,
    required this.scannedAt,
    this.imagePath,
    this.confidence,
    this.treatment,
    this.latitude,
    this.longitude,
    this.userId,
  });
}

class ScanResultAdapter extends TypeAdapter<ScanResult> {
  @override
  final int typeId = 1;

  @override
  ScanResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanResult(
      id: fields[0] as String,
      cropName: fields[1] as String,
      fieldName: fields[2] as String,
      diagnosis: fields[3] as String,
      healthScore: (fields[4] as num).toDouble(),
      scannedAt: fields[5] as DateTime,
      imagePath: fields[6] as String?,
      confidence: (fields[7] as num?)?.toDouble(),
      treatment: fields[8] as String?,
      latitude: (fields[9] as num?)?.toDouble(),
      longitude: (fields[10] as num?)?.toDouble(),
      userId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScanResult obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cropName)
      ..writeByte(2)
      ..write(obj.fieldName)
      ..writeByte(3)
      ..write(obj.diagnosis)
      ..writeByte(4)
      ..write(obj.healthScore)
      ..writeByte(5)
      ..write(obj.scannedAt)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.confidence)
      ..writeByte(8)
      ..write(obj.treatment)
      ..writeByte(9)
      ..write(obj.latitude)
      ..writeByte(10)
      ..write(obj.longitude)
      ..writeByte(11)
      ..write(obj.userId);
  }
}
