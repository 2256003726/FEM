
class RecordElecModel {
  int recordElecId;
  int foreSpotId;
  String foreSpotDetail;
  String foreElecId;
  String foreElecName;
  int recordVal;
  DateTime recordTime;
  String recordState;
  String elecLinkman;
  String elecPhone;

  RecordElecModel({
    this.foreElecId,
    this.foreElecName,
    this.foreSpotDetail,
    this.foreSpotId,
    this.recordElecId,
    this.recordState,
    this.recordTime,
    this.recordVal,
    this.elecLinkman,
    this.elecPhone
  });

  factory RecordElecModel.fromJson(dynamic json) {
    return RecordElecModel(
      foreElecId: json['foreElecId'],
      foreElecName: json['foreElecName'],
      foreSpotDetail: json['foreSpotDetail'],
      foreSpotId: json['foreSpotId'],
      recordElecId: json['recordElecId'],
      recordState: json['recordState'],
      recordTime: DateTime.parse(json['recordTime']),
      recordVal: json['recordVal'],
      elecLinkman: json['elecLinkman'],
      elecPhone: json['elecPhone']
    );
  }
}

class RecordElecListModel {
  List<RecordElecModel> data;
  RecordElecListModel(this.data);

  factory RecordElecListModel.fromJson(List json) {
    return RecordElecListModel(
      json.map((i) => RecordElecModel.fromJson(i)).toList()
    );
  }
}