package com.wjp.fem.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Temperature;
import com.wjp.fem.bean.TemperatureExample;
import com.wjp.fem.dao.SpotMapper;
import com.wjp.fem.dao.TemperatureMapper;
import com.wjp.fem.service.TempService;

@Service
public class TempServiceImpl implements TempService{

	@Autowired
	SpotMapper spotMapper;
	@Autowired
	TemperatureMapper tempMapper;
	
	@Override
	public PageInfo<Temperature> findtempBySpotIdAndState(Integer spotId, String state, String name, int curPage, int size) {
		PageHelper.startPage(curPage, size);
		TemperatureExample example = new TemperatureExample();
		if(state.equals("4")) {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andTempNameLike("%"+name+"%");
		} else {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andTempStateEqualTo(state).andTempNameLike("%"+name+"%");
		}
		
		List<Temperature> list = tempMapper.selectByExample(example);
		PageInfo<Temperature> info = new PageInfo<Temperature>(list);
		return info;
	}

	@Override
	public Temperature findTempById(String tempId) {
		Temperature temperature = tempMapper.selectByPrimaryKey(tempId);
		return temperature;
	}

	@Override
	public boolean updateTemp(Temperature temp) {
		TemperatureExample example = new TemperatureExample();
		example.createCriteria().andTempIdEqualTo(temp.getTempId());
		int i = tempMapper.updateByExample(temp, example);
		if(i != 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean deleteTemp(String tempId) {
		int i = tempMapper.deleteByPrimaryKey(tempId);
		if(i > 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean addTemp(Temperature temp) {
		temp.setTempVal(0);
		temp.setTempState("0");
		temp.setTempPush(0);
		if(findTempById(temp.getTempId()) != null) {
			return false;
		}
		int i = tempMapper.insert(temp);
		if(i != 0) {
			return true;
		}
		
		return false;
	}

}
