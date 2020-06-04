class History {
  final int id;
  final String animeId; // anime id
  final String cover; // anime 封面
  final String title; // anime 标题
  final DateTime time; // 历史记录创建时间
  final String playCurrent; // 第几话
  final String playCurrentId; // 第几话 id
  final String playCurrentBoxUrl; // 第几话 boxUrl
  final int position; // 播放位置 用秒存储
  final int duration;

  History({
    this.id,
    this.animeId,
    this.cover,
    this.title,
    this.time,
    this.playCurrent,
    this.playCurrentId,
    this.playCurrentBoxUrl,
    this.position,
    this.duration,
  }); // 总时长 用秒存储

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "animeId": animeId, // anime id
      "cover": cover, // anime 封面
      "title": title, // anime 标题
      "time": time.toString(), // 历史记录创建时间
      "playCurrent": playCurrent, // 第几话
      "playCurrentId": playCurrentId, // 第几话 id
      "playCurrentBoxUrl": playCurrentBoxUrl, // 第几话 boxUrl
      "position": position, // 播放位置 用秒存储
      "duration": duration,
    };
  }

  factory History.from(Map<String, dynamic> it) {
    return History(
      id: it['id'],
      animeId: it['animeId'],
      cover: it['cover'],
      title: it['title'],
      time: DateTime.parse(it['time']),
      playCurrent: it['playCurrent'],
      playCurrentId: it['playCurrentId'],
      playCurrentBoxUrl: it['playCurrentBoxUrl'],
      position: it['position'],
      duration: it['duration'],
    );
  }

  History copyWith({
    int id,
    String animeId,
    String cover,
    String title,
    DateTime time,
    String playCurrent,
    String playCurrentId,
    String playCurrentBoxUrl,
    int position,
    int duration,
  }) {
    return History(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      time: time ?? this.time,
      playCurrent: playCurrent ?? this.playCurrent,
      playCurrentId: playCurrentId ?? this.playCurrentId,
      playCurrentBoxUrl: playCurrentBoxUrl ?? this.playCurrentBoxUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
