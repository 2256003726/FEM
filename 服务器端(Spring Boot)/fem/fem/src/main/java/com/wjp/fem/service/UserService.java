package com.wjp.fem.service;

import java.util.List;

import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.Electricity;
import com.wjp.fem.bean.Spot;
import com.wjp.fem.bean.Temperature;
import com.wjp.fem.bean.User;
import com.wjp.fem.bean.extend.ElecExtend;
import com.wjp.fem.bean.extend.UserExtend;

public interface UserService {
	//登录
	public User login(String id, String password);
	//注册
	public boolean register(User user);
	//密码找回
	public String retrieve(String userId, String phone);
	
	//发送验证码
	public String sendValidateCode(String tel);
	//手机号登录
	public User phoneLogin(String phone, String messageId, String vCode);
	
	//根据userId查找所有spotList
	public List<Spot> findSpotsByUserId(String userId);
	
	//修改密码
	public boolean alertPassword(String userId, String password);
	
	//添加spot
	public boolean addSpot(Spot spot, String userId);
	
	//修改spot
	public boolean alertSpot(Spot spot);
	
	//根据spotId查找spot
	public Spot findSpot(int spotId);
	
	//查找userList----分页
	public PageInfo<User> getUser(int size, int page, String id);
	
	//分配spot ---即不添加新spot，只是在fore表里新增
	public boolean alloSpot(String spotName, String userId);
	
	//移除spot----在fore表里删除spot外键链接
	public boolean removeSpot(int spotId, String userId);
	
	
	
	
	
}
