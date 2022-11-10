package com.wjp.fem.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.annotation.RequestScope;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Spot;
import com.wjp.fem.bean.User;
import com.wjp.fem.bean.extend.ElecExtend;
import com.wjp.fem.bean.extend.UserExtend;
import com.wjp.fem.service.ElecService;
import com.wjp.fem.service.UserService;
import com.wjp.fem.util.JwtUtil;

@Controller
@RequestMapping("user")
public class UserController {
	@Autowired
	UserService service;
	@Autowired
	ElecService elecService;
	//登录
	@RequestMapping("login")
	@ResponseBody
	public UserExtend login(@RequestBody Map<String, String> data) {
		
		String id = data.get("userId");
		String password = data.get("password");		
		String token = "";
		User user = service.login(id, password);
		UserExtend userExtend = new UserExtend();
		if(user != null) {
			token = JwtUtil.createToken(user);
			userExtend.setToken(token);
			userExtend.setUser(user);
			return userExtend;
		}
		
		return null;
	}
	
	//注册
	@RequestMapping("register")
	@ResponseBody
	public boolean register(@RequestBody Map<String, String> data) {
		String id = data.get("userId");
		String password = data.get("password");		
		String phone = data.get("phone");
		String username = data.get("username");
		User user = new User();
		user.setUserId(id);
		user.setUserName(username);
		user.setUserPassword(password);
		user.setUserTel(phone);
		boolean b = service.register(user);
		return b;
		
	}
	
	//密码找回
	@RequestMapping("forget")
	@ResponseBody
	public String forget(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		String phone = data.get("phone");
		String string = service.retrieve(userId, phone);
		return string;
	}
	//获取spotList
	@RequestMapping("getSpotList")
	@ResponseBody
	public List<Spot> getSpotList(String userId) {
		
		List<Spot> list = service.findSpotsByUserId(userId);
		return list;
	}
	
	//修改密码
	@RequestMapping("alertPassword")
	@ResponseBody
	public boolean alertPassword(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		String password = data.get("password");
		boolean b = service.alertPassword(userId, password);
		return b;
	}
	
	//添加地址
	@RequestMapping("addSpot")
	@ResponseBody
	public boolean addSpot(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		String spotName = data.get("spotName");
		String spotProvince = data.get("spotProvince");
		String spotCity = data.get("spotCity");
		String spotArea = data.get("spotArea");
		Spot spot = new Spot();
		spot.setSpotState(spotProvince);
		spot.setSpotCity(spotCity);
		spot.setSpotCounty(spotArea);
		spot.setSpotName(spotName);
		
		boolean b = service.addSpot(spot, userId);
		return b;
	}
	
	//修改地址
	@RequestMapping("alertSpot")
	@ResponseBody
	public boolean alertSpot(@RequestBody Map<String, String> data) {
		int spotId = Integer.parseInt(data.get("spotId"));
		String spotName = data.get("spotName");
		String spotProvince = data.get("spotProvince");
		String spotCity = data.get("spotCity");
		String spotArea = data.get("spotArea");
		Spot spot = new Spot();
		spot.setSpotId(spotId);
		spot.setSpotState(spotProvince);
		spot.setSpotCity(spotCity);
		spot.setSpotCounty(spotArea);
		spot.setSpotName(spotName);
		
		boolean b = service.alertSpot(spot);
		return b;
	}
	
	//查询user
	@RequestMapping("getUsers")
	@ResponseBody
	public PageInfo<User> getUsers(@RequestBody Map<String, String> data) {
		String userId = data.get("id");
		int page = Integer.parseInt(data.get("page"));
		int size = Integer.parseInt(data.get("size"));
		PageInfo<User> pageInfo = service.getUser(size, page, userId);
		return pageInfo;
	}
	
	//分配地址
	@RequestMapping("alloSpot")
	@ResponseBody
	public boolean alloSpot(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		String spotName = data.get("spotName");
		boolean b = service.alloSpot(spotName, userId);
		return b;
	}
	
	//移除地址
	@RequestMapping("removeSpot")
	@ResponseBody
	public boolean removeSpot(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		Integer spotId = Integer.parseInt(data.get("spotId"));
		boolean b = service.removeSpot(spotId, userId);
		return b;
	}
	
}
