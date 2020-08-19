import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:resocoder_ddd_tutorial/domain/notes/note.dart';
import 'package:resocoder_ddd_tutorial/domain/notes/note_failure.dart';

abstract class INoteRepository {
  // watch notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  // Create, Update, Delete (CUD)
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
