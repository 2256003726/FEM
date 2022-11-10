package com.wjp.fem.service;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Temperature;

public interface TempService {
	//根据spotId，state查询temp，分页展示
	public PageInfo<Temperature> findtempBySpotIdAndState(Integer spotId, String state, String name, int curPage, int size);
	//根据elecId, 查询temp
	public Temperature findTempById(String tempId);		
	//修改temp
	public boolean updateTemp(Temperature temp);
	//删除temp
	public boolean deleteTemp(String tempId);
	//添加temp
	public boolean addTemp(Temperature temp);
}
