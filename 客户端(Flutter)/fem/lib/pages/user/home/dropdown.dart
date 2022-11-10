
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:flutter/material.dart';
import '../../../model/Spot.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/TempProvider.dart';
class Dropdown extends StatefulWidget {
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  int _selectType;
  
  @override
  Widget build(BuildContext context) {
    //保存它的值
    if(_selectType == '' || _selectType == null) {
      if(Provider.of<SpotProvider>(context, listen: true).selectedSpot!=null)
      _selectType = Provider.of<SpotProvider>(context, listen: true).selectedSpot.spotId;
    }
    return Container(
        height: ScreenUtil().setHeight(100),
        
              width: MediaQuery.of(context).size.width - 140,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(45.0),
                //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                //borderRadius: BorderRadius.circular(16.0),
                color: Colors.lime,
               // border:Border(bottom:BorderSide(width: 2,color: Colors.blue) )
              ),
              child: new DropdownButtonHideUnderline(

                  child: new DropdownButton(

                    focusColor: Colors.indigo,
                    underline: Container(height: 10,color: Colors.black,),
                    items: items(context),
                    
                    hint: new Text('请选择'),
                    onChanged: (value) async{
                      await Provider.of<SpotProvider>(context, listen: false).setSelectedSpot(value);
                      await Provider.of<ElecProvider>(context, listen: false).setStateList(context);
                      await Provider.of<TempProvider>(context, listen: false).setStateList(context);
                      setState(() {
                        _selectType = value;
                      });
                    },
//              isExpanded: true,
                    value: _selectType,
                    elevation: 24,//设置阴影的高度
                    style: new TextStyle(//设置文本框里面文字的样式
                      
                      color: Colors.indigo,
                      fontSize: ScreenUtil().setSp(28),
                    ),
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                    iconSize: 40.0,
                  )
              
              )
    );
  }
}

  List<Widget> items(BuildContext context) {
  List<SpotModel> spots = Provider.of<SpotProvider>(context, listen: true).spotList;
  List<Widget> a = spots.map((val) {
    return DropdownMenuItem(
      child: Container(
        width: MediaQuery.of(context).size.width - 190,
        child: Text(val.spotName,textAlign: TextAlign.center,style: TextStyle(fontSize: ScreenUtil().setSp(35),),overflow: TextOverflow.ellipsis,),
      ),
      
      value: val.spotId,
    ); 
  }).toList();
  return a; 
}