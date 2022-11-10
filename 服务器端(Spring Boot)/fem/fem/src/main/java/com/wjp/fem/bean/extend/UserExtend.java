package com.wjp.fem.bean.extend;

import com.wjp.fem.bean.User;

public class UserExtend {
	private User user;
	private String token;
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public UserExtend(User user, String token) {
		super();
		this.user = user;
		this.token = token;
	}
	public UserExtend() {
		super();
	}
	
	
	
}
