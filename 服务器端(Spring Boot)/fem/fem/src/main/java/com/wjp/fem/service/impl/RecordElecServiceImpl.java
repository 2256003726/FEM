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
import com.wjp.fem.dao.RecordElecMapper;
import com.wjp.fem.service.RecordElecService;
@Service
public class RecordElecServiceImpl implements RecordElecService{
	@Autowired
	RecordElecMapper elecMapper;
	//查询
	@Override
	public PageInfo<RecordElec> getRecordElec(int curPage, int size, Date begin, Date over, Integer spotId,
			String state) {
		//PageHelper.startPage(curPage, size);
		PageHelper.startPage(curPage, size, "record_time desc");
		RecordElecExample example = new RecordElecExample();
		if(begin != null && state != null) {			
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordStateEqualTo(state)
			.andRecordTimeBetween(begin, over);
		} else if(begin != null && (state == null || state.equals(""))) {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordTimeBetween(begin, over);
		}
		else if(state == null || state.equals("")){
			example.createCriteria().andForeSpotIdEqualTo(spotId);
		} else {
			example.createCriteria().andForeSpotIdEqualTo(spotId).andRecordStateEqualTo(state);
		}
		
		
		List<RecordElec> list = elecMapper.selectByExample(example);
//		//降序排列
//		Collections.sort(list, new Comparator<RecordElec>() {
//			@Override
//			public int compare(RecordElec o1, RecordElec o2) {
//				int flag = o1.getRecordTime().compareTo(o2.getRecordTime());
//				if(flag == -1) {
//					flag = 1;
//				} else if(flag == 1) {
//					flag = -1;
//				}
//				return flag;
//			}
//		});
//		System.out.println(list.get(0).getRecordTime());
//		System.out.println(list.get(1).getRecordTime());
//		System.out.println(list.get(2).getRecordTime());
//		System.out.println(list.get(3).getRecordTime());
		PageInfo<RecordElec> pageInfo = new PageInfo<RecordElec>(list);
		return pageInfo;
	}

	//修改状态为已处理
	public boolean dispose(long reId) {
		RecordElecExample example = new RecordElecExample();
		example.createCriteria().andRecordElecIdEqualTo(reId);
		RecordElec recordElec = elecMapper.selectByPrimaryKey(reId);
		recordElec.setRecordState("0");
		int i = elecMapper.updateByExampleSelective(recordElec, example);
		if(i != 0) {
			
			return true;
		}
		return false;
	}
	//删除记录
	@Override
	public boolean delete(long reId) {
		int i = elecMapper.deleteByPrimaryKey(reId);
		if(i != 0) {
			return true;
		}
		return false;
	}

	@Override
	public PageInfo<RecordElec> getRecordElecById(int curPage, int size, Date begin, Date over, String elecId,
			String state) {
		PageHelper.startPage(curPage, size, "record_time desc");
		RecordElecExample example = new RecordElecExample();
		if(begin != null && state != null) {			
			example.createCriteria().andForeElecIdEqualTo(elecId).andRecordStateEqualTo(state)
			.andRecordTimeBetween(begin, over);
		} else if(begin != null && (state == null || state.equals(""))) {
			example.createCriteria().andForeElecIdEqualTo(elecId).andRecordTimeBetween(begin, over);
		}
		else if(state == null || state.equals("")){
			example.createCriteria().andForeElecIdEqualTo(elecId);
		} else {
			example.createCriteria().andForeElecIdEqualTo(elecId).andRecordStateEqualTo(state);
		}
		List<RecordElec> list = elecMapper.selectByExample(example);
		PageInfo<RecordElec> pageInfo = new PageInfo<RecordElec>(list);
		return pageInfo;
	}

}
