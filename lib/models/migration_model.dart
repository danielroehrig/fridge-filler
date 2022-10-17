import 'package:hive/hive.dart';

part 'migration_model.g.dart';

@HiveType(typeId: 3)
class Migration extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  bool applied;

  Migration({required this.id, this.applied = false});
}
