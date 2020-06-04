class Collection {
  final int id;
  final String animeId;

  Collection({
    this.id,
    this.animeId,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "animeId": animeId,
    };
  }

  factory Collection.from(Map<String, dynamic> it) {
    return Collection(
      id: it['id'],
      animeId: it['animeId'],
    );
  }
}
