import 'package:isar/isar.dart';

part 'list_entity.g.dart';

@collection
class List {
  Id id = Isar.autoIncrement;
  String? name;
}
