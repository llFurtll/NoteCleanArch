import 'package:sqflite/sqflite.dart';

import 'utils.dart';

void onUpgrade(Database db, int version, int newVersion) async {
  await createAllTables(db);
  await insertRegistros(db);
  await updateTables(db);
}