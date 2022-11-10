class SpotModel {
  int spotId;
  String spotState;
  String spotCity;
  String spotCounty;
  String spotCategory;
  String spotName;
  
  SpotModel({
    this.spotCategory,
    this.spotCity,
    this.spotCounty,
    this.spotId,
    this.spotName,
    this.spotState
  });

  factory SpotModel.fromJson(dynamic json) {
    return SpotModel(
    spotCategory: json['spotCategory'],
    spotCity: json['spotCity'],
    spotCounty: json['spotCounty'],
    spotId: json['spotId'],
    spotName: json['spotName'],
    spotState: json['spotState'],
    );
  }
}

class SpotListModel {
  List<SpotModel> data;
  SpotListModel(this.data);
  factory SpotListModel.fromJson(List json) {
    return SpotListModel(
      json.map((i) => SpotModel.fromJson(i)).toList()
    );
  }
}