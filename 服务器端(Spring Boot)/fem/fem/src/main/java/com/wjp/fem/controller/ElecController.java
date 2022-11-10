package com.wjp.fem.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Electricity;
import com.wjp.fem.service.ElecService;

@Controller
@RequestMapping("elec")
public class ElecController {
	@Autowired
	ElecService service;
	
	@RequestMapping("getElec")
	@ResponseBody
	public PageInfo<Electricity> getElecListBySpotId(@RequestBody Map<String, String> data) {
		int spotId = Integer.parseInt(data.get("spotId"));
		String state = data.get("state");
		String name = data.get("name");
		int curPage = Integer.parseInt(data.get("curPage"));
		int size = Integer.parseInt(data.get("size"));
		PageInfo<Electricity> pageInfo = service.findElecBySpotIdAndState(spotId, state, name, curPage, size);
		//System.out.println(pageInfo);
		return pageInfo;	
	}
	
	@RequestMapping("getDetail")
	@ResponseBody
	public Electricity getDetail(String elecId) {
		Electricity electricity = service.findElecById(elecId);		
		return electricity;
	}
	
	@RequestMapping("updateElec")
	@ResponseBody
	public boolean updateElec(@RequestBody Electricity data) {
		boolean b = service.updateElec(data);
		return b;
	}
	
	@RequestMapping("deleteElec")
	@ResponseBody
	public boolean deleteElec(String elecId) {
		boolean b = service.deleteElec(elecId);
		return b;
	}
	
	@RequestMapping("addElec")
	@ResponseBody
	public boolean addElec(@RequestBody Electricity elec) {
		boolean b = service.addElec(elec);
		return b;
	}
}
