class DetailDto {
  String cover;
  String videoName;
  String curentText;
  List<String> starring;
  String director;
  List<String> types;
  String area;
  String years;
  String plot;
  List<PlayUrlTab> playUrlTab;

  DetailDto(
      {this.cover,
      this.videoName,
      this.curentText,
      this.starring,
      this.director,
      this.types,
      this.area,
      this.years,
      this.plot,
      this.playUrlTab});

  DetailDto.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    videoName = json['videoName'];
    curentText = json['curentText'];
    starring = json['starring'].cast<String>();
    director = json['director'];
    types = json['types'].cast<String>();
    area = json['area'];
    years = json['years'];
    plot = json['plot'];
    if (json['playUrlTab'] != null) {
      playUrlTab = new List<PlayUrlTab>();
      json['playUrlTab'].forEach((v) {
        playUrlTab.add(new PlayUrlTab.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['videoName'] = this.videoName;
    data['curentText'] = this.curentText;
    data['starring'] = this.starring;
    data['director'] = this.director;
    data['types'] = this.types;
    data['area'] = this.area;
    data['years'] = this.years;
    data['plot'] = this.plot;
    if (this.playUrlTab != null) {
      data['playUrlTab'] = this.playUrlTab.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayUrlTab {
  String id;
  String text;
  bool isBox;
  String src;

  PlayUrlTab({this.id, this.text, this.isBox, this.src});

  PlayUrlTab.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    isBox = json['isBox'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['isBox'] = this.isBox;
    data['src'] = this.src;
    return data;
  }
}
