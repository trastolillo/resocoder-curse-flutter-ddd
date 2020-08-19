import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/core/value_object.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/todo_item.dart';
import '../../domain/notes/value_objects.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDto implements _$NoteDto {
  const NoteDto._();

  const factory NoteDto({
    @required String body,
    @required int color,
    @required List<TodoItemDto> todos,
    @required @ServerTimestampConverter() FieldValue serverTimeStamp,
    @JsonKey(ignore: true) String id,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .map(
            (todoItem) => TodoItemDto.fromDomain(todoItem),
          )
          .asList(),
      serverTimeStamp: FieldValue.serverTimestamp(),
      id: note.id.getOrCrash(),
    );
  }

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(id),
      body: NoteBody(body),
      color: NoteColor(Color(color)),
      todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()),
    );
  }

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  factory NoteDto.fromFirestore(DocumentSnapshot doc) {
    return NoteDto.fromJson(doc.data).copyWith(id: doc.documentID);
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json) => FieldValue.serverTimestamp();

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    @required String id,
    @required String name,
    @required bool done,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}
