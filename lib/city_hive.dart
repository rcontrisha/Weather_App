import 'package:hive/hive.dart';
part 'city_hive.g.dart';

@HiveType(typeId: 0)
class Kota extends HiveObject{
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String city;
  Kota({
    required this.city,
  });
}