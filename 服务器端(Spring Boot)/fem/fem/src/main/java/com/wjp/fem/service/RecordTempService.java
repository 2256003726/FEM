package com.wjp.fem.service;

import java.util.Date;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.RecordElec;
import com.wjp.fem.bean.RecordTemp;

public interface RecordTempService {
	//根据时间范围查询recordList，pageInfo展示
	public PageInfo<RecordTemp> getRecordTemp(int curPage, int size, Date begin, Date over, Integer spotId, String state);
	//已处理
	public boolean dispose(long reId);
	//删除
	public boolean delete(long reId);
	//根据设备id查找
	public PageInfo<RecordTemp> getRecordTempById(int curPage, int size, Date begin, Date over, String tempId, String state);
		
}
