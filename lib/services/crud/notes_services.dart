import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'crud_crudexceptions.dart';



class NotesService {

  Database? _database;


  Future<DataBaseNote> updateNote({required DataBaseNote note, required String text,}) async {
    final database = _getDatabaseOrThrow();
    await getNotes(id: note.id);
     final upadteCount = await database.update(
      noteTable,
       {
         textColumn: text,
         isSyncedWithCloudColumn: 0,
       }
    );
     if(upadteCount == 0){
      throw CouldNotUpdateNote();
    }
    else{
     return await getNotes(id: note.id);
    }
  }

  Future<Iterable<DataBaseNote>> getAllNotes() async{
    final database = _getDatabaseOrThrow();
    final notes = await database.query(noteTable);
    return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
  }

  Future<DataBaseNote> getNotes({required int id}) async{
  final database = _getDatabaseOrThrow();
  final notes = await database.query(
    noteTable,
    limit: 1,
    where: 'id = ?',
    whereArgs: [id],
  );
  if(notes.isEmpty) {
    throw CouldNotFindNote();
  }
  else{
   return DataBaseNote.fromRow(notes.first);
  }
  }

  Future<int> deleteAllNotes() async {
    final database = _getDatabaseOrThrow();
    return await database.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async{
    final database = _getDatabaseOrThrow();
   final deletedCount = await database.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
   if(deletedCount != 1){
     throw CouldNotDeleteNote();
   }
    // make sure owner exists in the database with correct id

  }

  Future<DataBaseNote> createNote({required Databaseuser owner}) async{
     final database = _getDatabaseOrThrow();

     // make sure owner exists in the database with correct id
      final dbuser = await getUser(email: owner.email);
      if(dbuser.id != owner){
        throw CouldNotFindUser();
      }
      const text = '';
      // create the note
    final noteId = await database.insert(
      noteTable,
      {
        textColumn: text,
        userIdColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1,
      },
    );
    final note  = DataBaseNote(id: noteId,
        userid: owner.id,
        text: text,
        isSyncedWithCloud: true);
    return note;
  }

  Future<Databaseuser> getUser({required String email}) async {
    final database = _getDatabaseOrThrow();
final results = await database.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(results.isEmpty){
      throw CouldNotFindUser();
    }
    else{
      return Databaseuser.fromRow(results.first);
    }
  }

  Future<Databaseuser> createUser({required String email}) async{
    final database = _getDatabaseOrThrow();
    final results = await database.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(results.isNotEmpty){
      throw UserAlreadyExists();
    }

   final userId= await database.insert(
      userTable,
      {
        emailColumn: email.toLowerCase(),
      },
    );
    return Databaseuser(id:userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final database = _getDatabaseOrThrow();
    final deletedCount = await database.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(deletedCount != 1){
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
  final database = _database;
  if(database == null){
    throw DatabaseIsNotOpen();
  }
  else{
    return database;
  }
  }

  Future<void> close() async {
    if(_database == null){
      throw DatabaseIsNotOpen();
    }
    else{
    await _database!.close();
    _database = null;
    }
  }

  Future<void> open() async {
    if(_database != null){
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final databasePath = join(docsPath.path, databaseName);
      final database = await openDatabase(
        databasePath,
      );
      _database = database;
      await database.execute(createUserTable);
      await database.execute(createNoteTable);
    }on MissingPlatformDirectoryException{
      throw unableToGetDocumentDirectory();
    }
  }
}




@immutable
class Databaseuser {
  final int id;
  final String email;

  const Databaseuser({
    required this.id,
    required this.email,
  });
  Databaseuser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person , ID=$id, email=$email';

  @override
  bool operator ==(covariant Databaseuser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote {
  final int id;
  final int userid;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNote(
      {required this.id,
      required this.userid,
      required this.text,
      required this.isSyncedWithCloud});

  DataBaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userid = map[emailColumn] as int,
  text = map[textColumn] as String,
  isSyncedWithCloud =
  (map[isSyncedWithCloudColumn] as int) == 1 ?  true : false;

  @override
  String toString() => 'Note , ID=$id, userid=$userid, isSyncedWithCloud=$isSyncedWithCloud, text=$text';

  @override
  bool operator ==(covariant Databaseuser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const databaseName = 'pnotes.db';
const userTable = 'users';
const noteTable = 'note';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''
      CREATE TABLE IF NOT EXISTS "users" (
	"id"	INTEGER,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
      ''';

const createNoteTable = '''
      CREATE IF NOT EXISTS TABLE "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id")
);
      ''';