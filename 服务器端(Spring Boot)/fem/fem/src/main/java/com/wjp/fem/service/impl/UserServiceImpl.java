package com.wjp.fem.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjp.fem.bean.ForeUserSpot;
import com.wjp.fem.bean.ForeUserSpotExample;
import com.wjp.fem.bean.Spot;
import com.wjp.fem.bean.SpotExample;
import com.wjp.fem.bean.User;
import com.wjp.fem.bean.UserExample;
import com.wjp.fem.dao.ForeUserSpotMapper;
import com.wjp.fem.dao.SpotMapper;
import com.wjp.fem.dao.UserMapper;
import com.wjp.fem.service.UserService;
import com.wjp.fem.util.JiGuangSMSUtil;

@Service
public class UserServiceImpl implements UserService{
	@Autowired
	private UserMapper userMapper;
	@Autowired
	private ForeUserSpotMapper foreMapper;
	@Autowired
	private SpotMapper spotMapper;
	
	/**
	    * 登录
	 * success: 返回User,并加上token
	 * failure：返回null
	 */
	@Override
	public User login(String id, String password) {
		User user = userMapper.selectByPrimaryKey(id);
		
		if(user == null) {
			return null;
		} else {
			if(user.getUserPassword().equals(password)) {
				return user;
			} else {
				return null;
				
			}
		}
		
	}
	
	//根据userId查找spotList
	public List<Spot> findSpotsByUserId(String userId) {
		
		List<Spot> list = new ArrayList<Spot>();	
		ForeUserSpotExample example = new ForeUserSpotExample();
		example.createCriteria().andForeUserIdEqualTo(userId);
		
		List<ForeUserSpot> list2 = foreMapper.selectByExample(example);		
		for (ForeUserSpot foreUserSpot : list2) {
			int spotId = foreUserSpot.getForeSpotId();
			Spot spot = spotMapper.selectByPrimaryKey(spotId);
			list.add(spot);
		}		
		if(list.size() > 0) {
			return list;
		}
		return null;
	}

	//修改密码
	@Override
	public boolean alertPassword(String userId, String password) {
		User user = userMapper.selectByPrimaryKey(userId);
		
		user.setUserPassword(password);
		int i = userMapper.updateByPrimaryKey(user);
		
		if(i > 0) {
			return true;
		}
		return false;
	}

	//添加地址
	@Override
	public boolean addSpot(Spot spot, String userId) {
		//判断项目名是否重重
		SpotExample example = new SpotExample();
		example.createCriteria().andSpotNameEqualTo(spot.getSpotName());
		List<Spot> list = spotMapper.selectByExample(example);
		if(list.size() > 0) {
			return false;
		}
		//插入spot表
		int i = spotMapper.insert(spot);
		//找到插入的spotId
		SpotExample example1 = new SpotExample();
		example1.createCriteria().andSpotNameEqualTo(spot.getSpotName());
		List<Spot> list1 = spotMapper.selectByExample(example);
		Integer spotId = list1.get(0).getSpotId();
		//插入到user_spot表
		ForeUserSpot foreUserSpot = new ForeUserSpot();
		foreUserSpot.setForeSpotId(spotId);
		foreUserSpot.setForeUserId(userId);
		int j = foreMapper.insert(foreUserSpot);
		if(j > 0) {
			return true;
		}
		return false;
	}
	
	//查找userList --- 分页
	@Override
	public PageInfo<User> getUser(int size, int page, String id) {
		PageHelper.startPage(page, size);
		UserExample example = new UserExample();
		example.createCriteria().andUserIdLike("%"+id+"%");
		List<User> list = userMapper.selectByExample(example);
		PageInfo<User> pageInfo = new PageInfo<User>(list);
		return pageInfo;
	}
	
	//分配spot
	@Override
	public boolean alloSpot(String spotName, String userId) {
		SpotExample example = new SpotExample();
		example.createCriteria().andSpotNameEqualTo(spotName);
		List<Spot> list = spotMapper.selectByExample(example);
		if(list.size() <= 0) {
			return false;
		}
		Integer spotId = list.get(0).getSpotId();
		//插入到user_spot表
		ForeUserSpot foreUserSpot = new ForeUserSpot();
		foreUserSpot.setForeSpotId(spotId);
		foreUserSpot.setForeUserId(userId);
		int j = foreMapper.insert(foreUserSpot);
		if(j > 0) {
			return true;
		}
		return false;
	}

	//移除spot
	@Override
	public boolean removeSpot(int spotId, String userId) {
		ForeUserSpotExample example = new ForeUserSpotExample();
		example.createCriteria().andForeUserIdEqualTo(userId).andForeSpotIdEqualTo(spotId);
		int i = foreMapper.deleteByExample(example);
		if(i > 0) {
			return true;
			
		}
		return false;
	}

	//发送验证码
	@Override
	public String sendValidateCode(String tel) {
		String messageId = JiGuangSMSUtil.sendSMSCode(tel);
		return messageId;
	}
	
	//手机号登录，验证验证码
	@Override
	public User phoneLogin(String phone, String messageId, String vCode) {
		boolean b = JiGuangSMSUtil.sendVaildSMSCode(messageId, vCode);
		if(b == true) {
			UserExample example = new UserExample();
			example.createCriteria().andUserTelEqualTo(phone);
			List<User> list = userMapper.selectByExample(example);
			if(list.size() == 0) {
				return null;
			} else {
				return list.get(0);
			}
			
		}
		return null;
	}

	//注册
	@Override
	public boolean register(User user) {
		String userId = user.getUserId();
		user.setUserRole("用户");
		User user2 = userMapper.selectByPrimaryKey(userId);
		if(user2 == null) {
			int i = userMapper.insert(user);
			if(i > 0) {
				return true;
			}	
		}	
		return false;
	}
	
	//密码找回
	@Override
	public String retrieve(String userId, String phone) {
		UserExample example = new UserExample();
		example.createCriteria().andUserTelEqualTo(phone).andUserIdEqualTo(userId);
		List<User> list = userMapper.selectByExample(example);
		if(list.size() > 0) {
			return list.get(0).getUserPassword();
		}
		return null;
	}
	
	//根据spotId查找spot
	@Override
	public Spot findSpot(int spotId) {
		Spot spot = spotMapper.selectByPrimaryKey(spotId);
		return spot;
	}
	//修改spot
	@Override
	public boolean alertSpot(Spot spot) {
		int i = spotMapper.updateByPrimaryKey(spot);
		if(i > 0) {
			return true;
		}
		return false;
	}
	

	

}
