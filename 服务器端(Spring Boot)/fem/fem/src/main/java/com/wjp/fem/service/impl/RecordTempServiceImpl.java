package com.wjp.fem.service.impl;

import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.RecordElec;
import com.wjp.fem.bean.RecordElecExample;
import com.wjp.fem.bean.RecordTemp;
import com.wjp.fem.bean.RecordTempExample;
import com.wjp.fem.dao.RecordTempMapper;
import com.wjp.fem.service.RecordTempService;

@Service
public class RecordTempServiceImpl implements RecordTempService{
	@Autowired
	RecordTempMapper mapper;
	@Override
	public PageInfo<RecordTemp> getRecordTemp(int curPage, int size, Date begin, Date over, Integer spotId,
			String state) {
//		PageHelper.startPage(curPage, size);
		PageHelper.startPage(curPage, size, "record_time desc");
		RecordTempExample example = new RecordTempExample();
		
		if(begin != null && state != null) {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordStateEqualTo(state)
			.andRecordTimeBetween(begin, over);
		} else if(begin != null && state == null) {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordTimeBetween(begin, over);
		}
		else if(state == null || state.equals("")){
			example.createCriteria().andForeSpotIdEqualTo(spotId);
		} 
		else {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordStateEqualTo(state);
		}
		List<RecordTemp> list = mapper.selectByExample(example);
		//降序排列
//		Collections.sort(list, new Comparator<RecordTemp>() {
//			@Override
//			public int compare(RecordTemp o1, RecordTemp o2) {
//				int flag = o1.getRecordTime().compareTo(o2.getRecordTime());
//				if(flag == -1) {
//					flag = 1;
//				} else if(flag == 1) {
//					flag = -1;
//				}
//				return flag;
//			}
//		});
		PageInfo<RecordTemp> pageInfo = new PageInfo<RecordTemp>(list);
		return pageInfo;
	}

	@Override
	public boolean dispose(long reId) {
		RecordTempExample example = new RecordTempExample();
		RecordTemp temp = mapper.selectByPrimaryKey(reId);
		temp.setRecordState("0");
		System.out.println(temp.getRecordState());
		int i = mapper.updateByPrimaryKeySelective(temp);
		System.out.println("更新了temp");
		
		if(i != 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean delete(long reId) {
		int i = mapper.deleteByPrimaryKey(reId);
		if(i != 0) {
			return true;
		}
		return false;
	}

	@Override
	public PageInfo<RecordTemp> getRecordTempById(int curPage, int size, Date begin, Date over, String tempId,
			String state) {
		PageHelper.startPage(curPage, size, "record_time desc");
		RecordTempExample example = new RecordTempExample();
		
		if(begin != null && state != null) {
			example.createCriteria().andForeTempIdEqualTo(tempId).andRecordStateEqualTo(state)
			.andRecordTimeBetween(begin, over);
		} else if(begin != null && state == null) {
			example.createCriteria().andForeTempIdEqualTo(tempId).andRecordTimeBetween(begin, over);
		}
		else if(state == null || state.equals("")){
			example.createCriteria().andForeTempIdEqualTo(tempId);
		} 
		else {
			example.createCriteria().andForeTempIdEqualTo(tempId).andRecordStateEqualTo(state);
		}
		List<RecordTemp> list = mapper.selectByExample(example);
		PageInfo<RecordTemp> pageInfo = new PageInfo<RecordTemp>(list);
		return pageInfo;
	}

}
