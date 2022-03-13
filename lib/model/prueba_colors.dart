import 'package:hive/hive.dart';

// part 'prueba_colors.g.dart';

@HiveType(typeId: 3)
class PruebaColors extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late int val;
}
