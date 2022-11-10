package com.wjp.fem.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Temperature;
import com.wjp.fem.service.TempService;

@Controller
@RequestMapping("temp")
public class TempController {
	@Autowired
	TempService service;
	
	@RequestMapping("getTemp")
	@ResponseBody
	public PageInfo<Temperature> getTempListBySpotId(@RequestBody Map<String, String> data) {
		int spotId = Integer.parseInt(data.get("spotId"));
		String state = data.get("state");
		String name = data.get("name");
		int curPage = Integer.parseInt(data.get("curPage"));
		int size = Integer.parseInt(data.get("size"));
		PageInfo<Temperature> info = service.findtempBySpotIdAndState(spotId, state, name, curPage, size);
		
		return info;
	}
	
	@RequestMapping("getDetail")
	@ResponseBody
	public Temperature getDetail(String tempId) {
		Temperature temperature = service.findTempById(tempId);
		
		return temperature;		
	}
	
	@RequestMapping("updateTemp")
	@ResponseBody
	public boolean updateTemp(@RequestBody Temperature data) {
		boolean b = service.updateTemp(data);
		return b;
	}
	
	@RequestMapping("deleteTemp")
	@ResponseBody
	public boolean deleteTemp(String tempId) {
		boolean b = service.deleteTemp(tempId);
		return b;
	}
	
	@RequestMapping("addTemp")
	@ResponseBody
	public boolean addTemp(@RequestBody Temperature temp) {
		boolean b = service.addTemp(temp);
		return b;
	}
	

}
