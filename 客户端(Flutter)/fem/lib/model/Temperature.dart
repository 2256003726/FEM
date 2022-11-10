
class TempModel {
  String tempId;
  String tempName;
  int tempVal;
  int tempEarly;
  int tempWarning;
  String tempState;
  int foreSpotId;
  String tempSpotDetail;
  String tempStandard;
  String tempVoltage;
  String tempCurrent;
  String tempTexture;
  String tempSetting;
  String tempSize;
  String tempDes;
  String tempLinkman;
  String tempPhone;
  

  TempModel({
    this.foreSpotId,
   
    this.tempCurrent,
    this.tempDes,
    this.tempEarly,
    this.tempId,
    this.tempName,
    this.tempSetting,
    this.tempSize,
    this.tempSpotDetail,
    this.tempStandard,
    this.tempState,
    this.tempTexture,
    this.tempVal,
    this.tempVoltage,
    this.tempWarning,
    this.tempLinkman,
    this.tempPhone
  });
  
  factory TempModel.fromJson(dynamic json) {
    return TempModel(
      tempCurrent: json['tempCurrent'],
      tempDes: json['tempDes'],
      tempEarly: json['tempEarly'],
      tempId: json['tempId'],
      tempName: json['tempName'],
      tempSetting: json['tempSetting'],
      tempSize: json['tempSize'],
      tempSpotDetail: json['tempSpotDetail'],
      tempStandard: json['tempStandard'],
      tempState: json['tempState'],
      tempTexture: json['tempTexture'],
      tempVal: json['tempVal'],
      tempVoltage: json['tempVoltage'],
      tempWarning: json['tempWarning'],
      foreSpotId: json['foreSpotId'],
      tempLinkman: json['tempLinkman'],
      tempPhone: json['tempPhone']
      
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['tempId'] = this.tempId;
      data['tempName'] = this.tempName;
      data['tempCurrent'] = this.tempCurrent;
      data['tempDes'] = this.tempDes;
      data['tempSpotDetail'] = this.tempSpotDetail;
      data['tempWarning'] = this.tempWarning;
      data['tempEarly'] = this.tempEarly;
      data['tempVal'] = this.tempVal;
      data['tempVoltage'] = this.tempVoltage;
      data['tempTexture'] = this.tempTexture;
      data['foreSpotId'] = this.foreSpotId;
      data['tempStandard'] = this.tempStandard;
      data['tempState'] = this.tempState;
      data['tempSetting'] = this.tempSetting;
      data['tempSize'] = this.tempSize;
      data['tempLinkman'] = this.tempLinkman;
      data['tempPhone'] = this.tempPhone;
      return data;
  }
}

class TempListModel {
  List<TempModel> data;
  TempListModel(this.data);
  factory TempListModel.fromJson(List json) {
    return TempListModel(
      json.map((i) => TempModel.fromJson(i)).toList()
    );
  }
}