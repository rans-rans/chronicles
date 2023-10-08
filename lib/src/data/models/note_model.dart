import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required title,
    required body,
    required dateCreated,
    required dateModified,
  }) : super(
          title: title,
          body: body,
          dateCreated: dateCreated,
          dateModified: dateModified,
        );
  // NoteModel({
  //   required super.title,
  //   required super.body,
  //   required super.dateCreated,
  //   required super.dateModified,
  // });

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      title: map["title"],
      body: map["body"],
      dateCreated: DateTime.parse(map["dateCreated"]),
      dateModified: DateTime.parse(map["dateModified"]),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "dateCreated": dateCreated.toIso8601String(),
      "dateModified": dateModified.toIso8601String(),
    };
  }
}
