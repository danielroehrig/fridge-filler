import 'package:hive/hive.dart';

import '../models/migration_model.dart';

/// Checks if there are migrations to be executed runs them
Future<void> migrate() {
  return Hive.openBox<Migration>('migration')
      .then((migrationBox) => runFirstMigration(migrationBox));
}

Future<void> runFirstMigration(Box<Migration> box) {
  print("Checking first migration");
  var firstMigration = box.get(1);
  if (null == firstMigration) {
    print("First migration missing");
    firstMigration = Migration(id: 1, applied: true);
    box.put(1, firstMigration);
  } else if (!firstMigration.applied) {
    print("First migration there but not applied for reasons...");
    firstMigration.applied = true;
    firstMigration.save();
  } else {
    print("First migration already ran");
  }
  return Future.value();
}
