class RecordTempModel {
  int recordTempId;
  int foreSpotId;
  String foreSpotDetail;
  String foreTempId;
  String foreTempName;
  int recordVal;
  DateTime recordTime;
  String recordState;
  String tempLinkman;
  String tempPhone;

  RecordTempModel({
    this.foreSpotDetail,
    this.foreSpotId,
    this.foreTempId,
    this.foreTempName,
    this.recordState,
    this.recordTempId,
    this.recordTime,
    this.recordVal,
    this.tempLinkman,
    this.tempPhone
  });

  factory RecordTempModel.fromJson(dynamic json) {
    return RecordTempModel(
      foreSpotDetail: json['foreSpotDetail'],
      foreSpotId: json['foreSpotId'],
      foreTempId: json['foreTempId'],
      foreTempName: json['foreTempName'],
      recordState: json['recordState'],
      recordTempId: json['recordTempId'],
      recordTime: DateTime.parse(json['recordTime']),
      recordVal: json['recordVal'],
      tempLinkman: json['tempLinkman'],
      tempPhone: json['tempPhone']
    );
  }
}

class RecordTempListModel{
  List<RecordTempModel> data;
  RecordTempListModel(this.data);
  factory RecordTempListModel.fromJson(List json) {
    return RecordTempListModel(
      json.map((f) {
        return RecordTempModel.fromJson(f);
      }).toList()
    );
  }  
  
}

