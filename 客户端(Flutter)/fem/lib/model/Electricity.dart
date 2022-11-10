
import 'package:fem/model/Spot.dart';

class ElectricityModel {
    String elecId;
    String elecName;
    int elecValue;
    int elecEarly;
    int elecWarning;
    String elecState;
    int foreSpotId;
    String elecSpotDetail;
    String elecStandard;
    String elecVoltage;
    String elecCurrent;
    String elecTexture;
    String elecSetting;
    String elecSize;
    String elecDes;
    String elecLinkman;
    String elecPhone;
  //  SpotModel spot;

    ElectricityModel({
        this.elecCurrent,
        this.elecDes,
        this.elecEarly,
        this.elecId,
        this.elecName,
        this.elecSetting,
        this.elecSize,
        this.elecSpotDetail,
        this.elecStandard,
        this.elecState,
        this.elecTexture,
        this.elecValue,
        this.elecVoltage,
        this.elecWarning,
        this.foreSpotId,
        this.elecLinkman,
        this.elecPhone
     //   this.spot
    });

    factory ElectricityModel.fromJson(dynamic json) {
      return ElectricityModel(
        elecCurrent: json['elecCurrent'],
        elecDes: json['elecDes'],
        elecEarly: json['elecEarly'],
        elecId: json['elecId'],
        elecName: json['elecName'],
        elecSetting: json['elecSetting'],
        elecSize: json['elecSize'],
        elecSpotDetail: json['elecSpotDetail'],
        elecStandard: json['elecStandard'],
        elecState: json['elecState'],
        elecTexture: json['elecTexture'],
        elecValue: json['elecValue'],
        elecVoltage: json['elecVoltage'],
        elecWarning: json['elecWarning'],
        foreSpotId: json['foreSpotId'],
        elecLinkman: json['elecLinkman'],
        elecPhone: json['elecPhone']
      //  spot: SpotModel.fromJson(json['spot'])
      );
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['elecId'] = this.elecId;
      data['elecName'] = this.elecName;
      data['elecCurrent'] = this.elecCurrent;
      data['elecDes'] = this.elecDes;
      data['elecSpotDetail'] = this.elecSpotDetail;
      data['elecWarning'] = this.elecWarning;
      data['elecEarly'] = this.elecEarly;
      data['elecValue'] = this.elecValue;
      data['elecVoltage'] = this.elecVoltage;
      data['elecTexture'] = this.elecTexture;
      data['foreSpotId'] = this.foreSpotId;
      data['elecStandard'] = this.elecStandard;
      data['elecState'] = this.elecState;
      data['elecSetting'] = this.elecSetting;
      data['elecSize'] = this.elecSize;
      data['elecLinkman'] = this.elecLinkman;
      data['elecPhone'] = this.elecPhone;
      return data;
     

    }
}

class ElectricityListModel {
    List<ElectricityModel> data;
    ElectricityListModel(this.data);

    factory ElectricityListModel.fromJson(List json) {
      return ElectricityListModel(
        json.map((i) => ElectricityModel.fromJson(i)).toList()
      );
    }
}