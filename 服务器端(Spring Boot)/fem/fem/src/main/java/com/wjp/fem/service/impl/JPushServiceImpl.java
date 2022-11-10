package com.wjp.fem.service.impl;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.wjp.fem.bean.Electricity;
import com.wjp.fem.bean.ElectricityExample;
import com.wjp.fem.bean.ForeUserSpot;
import com.wjp.fem.bean.ForeUserSpotExample;
import com.wjp.fem.bean.RecordElec;
import com.wjp.fem.bean.RecordTemp;
import com.wjp.fem.bean.Temperature;
import com.wjp.fem.bean.TemperatureExample;
import com.wjp.fem.dao.ElectricityMapper;
import com.wjp.fem.dao.ForeUserSpotMapper;
import com.wjp.fem.dao.RecordElecMapper;
import com.wjp.fem.dao.RecordTempMapper;
import com.wjp.fem.dao.SpotMapper;
import com.wjp.fem.dao.TemperatureMapper;
import com.wjp.fem.service.JPushService;
import com.wjp.fem.util.JpushClientUtil;
@Service
public class JPushServiceImpl implements JPushService{
	@Autowired
	ElectricityMapper elecMapper;
	@Autowired
	TemperatureMapper tempMapper;
	@Autowired
	RecordElecMapper reElecMapper;
	@Autowired
	RecordTempMapper reTempMapper;
	@Autowired 
	SpotMapper spotMapper;
	@Autowired 
	ForeUserSpotMapper u_sMapper;
	
	@Scheduled(cron = "*/20 * * * * *")
	@Override
	public void Push() {
		long startTime = System.currentTimeMillis();
		List<Electricity> elecList = getElecList();
		for (Electricity e : elecList) {
			
			List<String> idList = getUserIdList(e.getForeSpotId());
			if(idList == null) {
				continue;
			}
			String msg_title = e.getElecName();
			String msg_content = "地点:" + e.getElecSpotDetail() + "  " + "报警值:" + e.getElecValue();
			setElecPush(e.getElecId(), 1);
			addReElce(e);
			JpushClientUtil.sendToRegistrationId(idList, "电流警报", msg_title, msg_content, "");
		}
		List<Temperature> tempList = getTempList();
		for (Temperature t : tempList) {
			List<String> idList = getUserIdList(t.getForeSpotId());
			if(idList == null) {
			continue;
		}
			String msg_title = t.getTempName();
			String msg_content = "安装地点:" + t.getTempSpotDetail() + "  " + "报警值:" + t.getTempVal();
			setTempPush(t.getTempId(), 1);
			addReTemp(t);
			JpushClientUtil.sendToRegistrationId(idList, "温度警报", msg_title, msg_content, "");			
		}
		long endTime = System.currentTimeMillis();
		System.out.println("方法运行用时:" + (endTime-startTime));		
	}
	
	//重置push
//	@Scheduled(cron = "0 0 23 * * *")
	@Override
	public void resetPush() {
		System.out.println("重置处理");
		ElectricityExample example = new ElectricityExample();
		example.createCriteria().andElecPushEqualTo(1);
		List<Electricity> elecList = elecMapper.selectByExample(example);
		for (Electricity electricity : elecList) {
			setElecPush(electricity.getElecId(), 0);
		}
		TemperatureExample example2 = new TemperatureExample();
		example2.createCriteria().andTempPushEqualTo(1);
		List<Temperature> tempList = tempMapper.selectByExample(example2);
		for (Temperature temperature : tempList) {
			setTempPush(temperature.getTempId(), 0);
		}
		
	}
	
	
	//查询所有报警的elceList，且push=0
	public List<Electricity> getElecList() {
		ElectricityExample example = new ElectricityExample();
		example.createCriteria().andElecStateEqualTo("2").andElecPushEqualTo(0);
		List<Electricity> list = elecMapper.selectByExample(example);
		return list;
	}
	
	//查询所有报警的tempList，且push=0
	public List<Temperature> getTempList() {
		TemperatureExample example = new TemperatureExample();
		example.createCriteria().andTempStateEqualTo("2").andTempPushEqualTo(0);
		List<Temperature> list = tempMapper.selectByExample(example);
		return list;
	}
	
	//设置ElecPush值
	public void setElecPush(String elecId, int push) {
		Electricity electricity = elecMapper.selectByPrimaryKey(elecId);
		electricity.setElecPush(push);
		elecMapper.updateByPrimaryKeySelective(electricity);
	}
	
	//设置TempPush值
	public void setTempPush(String tempId, int push) {
		Temperature temperature = tempMapper.selectByPrimaryKey(tempId);
		temperature.setTempPush(push);
		tempMapper.updateByPrimaryKeySelective(temperature);
	}
	
	//elec添加报警记录
	public void addReElce(Electricity elec) {
		RecordElec record = new RecordElec();
		record.setForeElecId(elec.getElecId());
		record.setForeElecName(elec.getElecName());
		record.setForeSpotDetail(elec.getElecSpotDetail());
		record.setForeSpotId(elec.getForeSpotId());
		record.setRecordState("1");
		record.setRecordVal(elec.getElecValue());
		Date date = new Date(System.currentTimeMillis());
		record.setRecordTime(date);
		record.setElecLinkman(elec.getElecLinkman());
		record.setElecPhone(elec.getElecPhone());
		reElecMapper.insert(record);
	}
	
	//temp添加报警记录
	public void addReTemp(Temperature temp) {
		RecordTemp record = new RecordTemp();
		record.setForeSpotDetail(temp.getTempSpotDetail());
		record.setForeSpotId(temp.getForeSpotId());
		record.setForeTempId(temp.getTempId());
		record.setForeTempName(temp.getTempName());
		record.setRecordState("1");
		record.setRecordVal(temp.getTempVal());
		Date date = new Date(System.currentTimeMillis());
		record.setRecordTime(date);
		record.setTempLinkman(temp.getTempLinkman());
		record.setTempPhone(temp.getTempPhone());
		reTempMapper.insert(record);
	}
	
	//根据spotid查找user
	public List<String> getUserIdList(int spotId) {
		List<String> userIdList = new ArrayList<String>();
		ForeUserSpotExample example = new ForeUserSpotExample();
		example.createCriteria().andForeSpotIdEqualTo(spotId);
		List<ForeUserSpot> list = u_sMapper.selectByExample(example);
		if(list.size() == 0) {
			return null;
		}
		for (ForeUserSpot foreUserSpot : list) {
			userIdList.add(foreUserSpot.getForeUserId());
		}
		return userIdList;
	}

	
	
	
	
	
}
