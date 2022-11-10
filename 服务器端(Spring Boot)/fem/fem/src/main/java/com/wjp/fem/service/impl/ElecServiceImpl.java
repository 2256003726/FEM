package com.wjp.fem.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Electricity;
import com.wjp.fem.bean.ElectricityExample;
import com.wjp.fem.bean.Spot;
import com.wjp.fem.bean.extend.ElecExtend;
import com.wjp.fem.dao.ElectricityMapper;
import com.wjp.fem.dao.SpotMapper;
import com.wjp.fem.service.ElecService;

@Service
public class ElecServiceImpl implements ElecService{
	
	@Autowired
	private ElectricityMapper elecMapper;

	@Autowired
	private SpotMapper spotMapper;
	
	
	//根据spotId查找ElecList
	public List<ElecExtend> findElecBySpotId(Integer spotId) {
		List<ElecExtend> extendList = new ArrayList<ElecExtend>();
		ElectricityExample example = new ElectricityExample();
		
		example.createCriteria().andForeSpotIdEqualTo(spotId);
		Spot spot = spotMapper.selectByPrimaryKey(spotId);
		List<Electricity> list = elecMapper.selectByExample(example);
		for (Electricity e : list) {
			ElecExtend e2 = new ElecExtend();
			e2.setElecCurrent(e.getElecCurrent());
			e2.setElecDes(e.getElecDes());
			e2.setElecEarly(e.getElecEarly());
			e2.setElecId(e.getElecId());
			e2.setElecName(e.getElecName());
			e2.setElecSetting(e.getElecSetting());
			e2.setElecSize(e.getElecSize());
			e2.setElecSpotDetail(e.getElecSpotDetail());
			e2.setElecStandard(e.getElecStandard());
			e2.setElecState(e.getElecState());
			e2.setElecTexture(e.getElecTexture());
			e2.setElecValue(e.getElecValue());
			e2.setElecVoltage(e.getElecVoltage());
			e2.setElecWarning(e.getElecWarning());
			e2.setForeSpotId(e.getForeSpotId());
			e2.setSpot(spot);
			extendList.add(e2);
		}
		
		return extendList;
	}
	

	

	//根据状态
	@Override
	public PageInfo<Electricity> findElecBySpotIdAndState(Integer spotId, String state, String name, int curPage, int size) {
		PageHelper.startPage(curPage, size);
		ElectricityExample example = new ElectricityExample();
		if(state.equals("4")) {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andElecNameLike("%"+name+"%");
		} else {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andElecStateEqualTo(state).andElecNameLike("%"+name+"%");
		}
		List<Electricity> list = elecMapper.selectByExample(example);
		PageInfo<Electricity> pageInfo = new PageInfo<Electricity>(list);
		
		return pageInfo;
	}
	@Override
	public Electricity findElecById(String elecId) {
		Electricity electricity = elecMapper.selectByPrimaryKey(elecId);
		return electricity;
	}
	@Override
	public boolean updateElec(Electricity elec) {
		ElectricityExample example = new ElectricityExample();
		example.createCriteria().andElecIdEqualTo(elec.getElecId());
		int updateByExampleSelective = elecMapper.updateByExampleSelective(elec, example);
		if(updateByExampleSelective != 0) {
			return true;
		}
		return false;
	}
	@Override
	public boolean deleteElec(String elecId) {
		int i = elecMapper.deleteByPrimaryKey(elecId);
		if(i > 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean addElec(Electricity elec) {
		elec.setElecValue(0);
		elec.setElecState("0");
		elec.setElecPush(0);
		if(findElecById(elec.getElecId()) != null) {
			return false;
		}
		int i = elecMapper.insert(elec);
		if(i != 0) {
			return true;
		}
		return false;
	}

}
