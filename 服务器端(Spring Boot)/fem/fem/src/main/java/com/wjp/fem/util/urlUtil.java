package com.wjp.fem.util;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;

public class urlUtil {
	//获取本机ip
	public static String getIp() {
		try {
			InetAddress ip4 = Inet4Address.getLocalHost();
			return ip4.getHostAddress();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}	
		return null;
	}
	//获取图片url
	public static String getPicUrl() {
		String ipUrl = getIp();
		String picUrl = "http://" + ipUrl + ":8888/pictures/";
		return  picUrl;
	}
}
