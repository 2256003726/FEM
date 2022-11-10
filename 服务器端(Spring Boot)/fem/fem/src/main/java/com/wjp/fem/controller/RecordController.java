package com.wjp.fem.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.RecordElec;
import com.wjp.fem.bean.RecordTemp;
import com.wjp.fem.service.ElecService;
import com.wjp.fem.service.RecordElecService;
import com.wjp.fem.service.RecordTempService;

@Controller
@RequestMapping("record")
public class RecordController {
	@Autowired
	RecordElecService reElecService;
	@Autowired
	RecordTempService reTempService;
	//根据状态查询电流报告
	@RequestMapping("getElecList")
	@ResponseBody
	public PageInfo<RecordElec> getElecList(@RequestBody Map<String, String> data) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");//日期格式
		String b = data.get("begin");
		String o = (String) data.get("over");
		int curPage = Integer.parseInt(data.get("page"));
		int size = Integer.parseInt(data.get("size"));
		int spotId = Integer.parseInt(data.get("spotId"));
		String state = data.get("state");
		try {
			if(b.equals("") || b.isEmpty()) {
				PageInfo<RecordElec> pageInfo = reElecService.getRecordElec(curPage, size, null, null, spotId, state);	
				return pageInfo;
			}
			Date begin = format.parse(b);
			Date over = format.parse(o);			
			PageInfo<RecordElec> pageInfo = reElecService.getRecordElec(curPage, size, begin, over, spotId, state);		
			return pageInfo;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return null;	
	}
	
	//处理电流
	@RequestMapping("disposeElec")
	@ResponseBody
	public boolean dispose(long reId) {
		boolean b = reElecService.dispose(reId);
		return b;
	}
	
	//删除电流
	@RequestMapping("deleteElec")
	@ResponseBody
	public boolean delete(long reId) {
		boolean delete = reElecService.delete(reId);
		return delete;
	}
	
	//查询温度
	@RequestMapping("getTempList")
	@ResponseBody
	public PageInfo<RecordTemp> getTempList(@RequestBody Map<String, String> data) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");//日期格式
		String b = data.get("begin");
		String o = (String) data.get("over");
		int curPage = Integer.parseInt(data.get("page"));
		int size = Integer.parseInt(data.get("size"));
		int spotId = Integer.parseInt(data.get("spotId"));
		String state = data.get("state");
		try {
			if(b.equals("") || b.isEmpty()) {
				PageInfo<RecordTemp> pageInfo = reTempService.getRecordTemp(curPage, size, null, null, spotId, state);	
				return pageInfo;
			}
			Date begin = format.parse(b);
			Date over = format.parse(o);			
			PageInfo<RecordTemp> pageInfo = reTempService.getRecordTemp(curPage, size, begin, over, spotId, state);		
			return pageInfo;
		} catch (ParseException e) {
			
			e.printStackTrace();
		}		
		return null;	
	}
	
	//处理温度
	@RequestMapping("disposeTemp")
	@ResponseBody
	public boolean disposeTemp(long reId) {
		boolean b = reTempService.dispose(reId);
		return b;
	}
	
	//删除温度
	@RequestMapping("deleteTemp")
	@ResponseBody
	public boolean deleteTemp(long reId) {
		boolean delete = reTempService.delete(reId);
		return delete;
	}

	//获取报警概况，根据日期
	@RequestMapping("getOutline")
	@ResponseBody
	public Map<String, Integer> getOutline(@RequestBody Map<String, String> data) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");//日期格式
		String b = data.get("begin");
		String o = (String) data.get("over");
		int spotId = Integer.parseInt(data.get("spotId"));
		Map<String, Integer> outLine = new HashMap<>();
		int allAmount = 0;
		int unAmount = 0;
		int elec = 0;
		int temp = 0;
		try {
			Date begin = format.parse(b);
			Date over = format.parse(o);	
			elec = reElecService.getRecordElec(1, 0, begin, over, spotId, null).getSize();
			temp = reTempService.getRecordTemp(1, 0, begin, over, spotId, null).getSize();
			allAmount = elec + temp;
			unAmount = reElecService.getRecordElec(1, 0, begin, over, spotId, "1").getSize()
					+ reTempService.getRecordTemp(1, 0, begin, over, spotId, "1").getSize();
			outLine.put("allAmount", allAmount);
			outLine.put("unAmount", unAmount);
			outLine.put("elec", elec);
			outLine.put("temp", temp);
			return outLine;
		} catch (Exception e) {
			System.out.println("日期解析出错");
		}

		return null;
		
	}
	
	//根据elecId查询电流报告
	@RequestMapping("getElecListById")
	@ResponseBody
	public PageInfo<RecordElec> getElecListById(@RequestBody Map<String, String> data) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");//日期格式
		String b = data.get("begin");
		String o = (String) data.get("over");
		int curPage = Integer.parseInt(data.get("page"));
		int size = Integer.parseInt(data.get("size"));
		String elecId = data.get("id");
		String state = data.get("state");
		try {
			if(b.equals("") || b.isEmpty()) {
				PageInfo<RecordElec> pageInfo = reElecService.getRecordElecById(curPage, size, null, null, elecId, state);	
				return pageInfo;
			}
			Date begin = format.parse(b);
			Date over = format.parse(o);			
			PageInfo<RecordElec> pageInfo = reElecService.getRecordElecById(curPage, size, begin, over, elecId, state);		
			return pageInfo;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return null;	
	}
	
	//根据Id查询温度
	@RequestMapping("getTempListById")
	@ResponseBody
	public PageInfo<RecordTemp> getTempListById(@RequestBody Map<String, String> data) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");//日期格式
		String b = data.get("begin");
		String o = (String) data.get("over");
		int curPage = Integer.parseInt(data.get("page"));
		int size = Integer.parseInt(data.get("size"));
		String tempId = data.get("id");
		String state = data.get("state");
		try {
			if(b.equals("") || b.isEmpty()) {
				PageInfo<RecordTemp> pageInfo = reTempService.getRecordTempById(curPage, size, null, null, tempId, state);	
				return pageInfo;
			}
			Date begin = format.parse(b);
			Date over = format.parse(o);			
			PageInfo<RecordTemp> pageInfo = reTempService.getRecordTempById(curPage, size, begin, over, tempId, state);		
			return pageInfo;
		} catch (ParseException e) {
			
			e.printStackTrace();
		}		
		return null;	
	}
	
}
