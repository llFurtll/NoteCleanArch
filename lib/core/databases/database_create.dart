import 'package:sqflite/sqflite.dart';

import 'utils.dart';

void onCreate(Database db, int version) async {
  await createAllTables(db);
  await insertRegistros(db);
}