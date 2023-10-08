class NoteEntity {
  String title;
  String body;
  DateTime dateCreated;
  DateTime dateModified;

  NoteEntity({
    required this.title,
    required this.body,
    required this.dateCreated,
    required this.dateModified,
  });

  factory NoteEntity.fromJson(Map<String, dynamic> map) {
    return NoteEntity(
      title: map["title"],
      body: map["body"],
      dateCreated: DateTime.parse(map["dateCreated"]),
      dateModified: DateTime.parse(map["dateModified"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "dateCreated": dateCreated.toIso8601String(),
      "dateModified": dateModified.toIso8601String(),
    };
  }
}
