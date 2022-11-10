package com.wjp.fem.service;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Electricity;

public interface ElecService {
	//根据spotId，state查询elec，分页展示
	public PageInfo<Electricity> findElecBySpotIdAndState(Integer spotId, String state, String name, int curPage, int size);
	//根据elecId, 查询elec
	public Electricity findElecById(String elecId);		
	//修改elec
	public boolean updateElec(Electricity elec);
	//删除
	public boolean deleteElec(String elecId);
	//添加
	public boolean addElec(Electricity elec);
}
