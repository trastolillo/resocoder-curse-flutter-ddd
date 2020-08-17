import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:resocoder_ddd_tutorial/domain/core/failures.dart';

import '../core/value_object.dart';
import 'todo_item.dart';
import 'value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId id,
    @required NoteBody body,
    @required NoteColor color,
    @required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
      id: UniqueId(),
      body: NoteBody(''),
      color: NoteColor(NoteColor.predefinedColors[0]),
      todos: List3(emptyList()));

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(todos
            .getOrCrash()
            // Getting the failureOption from the TodoItem ENTITY -
            // NOT a failureOrUnit from a VALUE OBJECT
            .map((todoItem) => todoItem.failureOption)
            // If we cant't get the 0th element, the list is empty.
            // In such case, it's valid.
            .filter((o) => o.isSome())
            .getOrElse(0, (_) => none())
            .fold(
              () => right(unit),
              (f) => left(f),
            ))
        .fold(
          (f) => some(f),
          (r) => none(),
        );
  }
}
