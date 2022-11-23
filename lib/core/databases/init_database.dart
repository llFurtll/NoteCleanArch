import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_create.dart';
import 'database_upgrade.dart';

Future<void> initDatabase() async {
  await openDatabase(
    join(await getDatabasesPath(), "note.db"),
    version: 2,
    onCreate: onCreate,
    onUpgrade: onUpgrade
  );
}

Future<Database> getDatabase() async {
  return await openDatabase(join(await getDatabasesPath(), "note.db"));
}