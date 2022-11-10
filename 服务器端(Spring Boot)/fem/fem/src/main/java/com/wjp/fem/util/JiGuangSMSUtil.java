package com.wjp.fem.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.jiguang.common.resp.APIConnectionException;
import cn.jiguang.common.resp.APIRequestException;
import cn.jsms.api.SendSMSResult;
import cn.jsms.api.ValidSMSResult;
import cn.jsms.api.common.SMSClient;
import cn.jsms.api.common.model.SMSPayload;

public class JiGuangSMSUtil {
	protected static final Logger LOG = LoggerFactory.getLogger(JiGuangSMSUtil.class);

    private static final String appkey = "da37fa7a3226fc41171e4855";
    private static final String masterSecret = "a6b6d256ef7c4a8f78d98240";

   // private static final String devKey = "242780bfdd7315dc1989fedb";
  //  private static final String devSecret = "2f5ced2bef64167950e63d13";
    
    //发送验证码----返回
    public static String sendSMSCode(String tel) {
    	SMSClient client = new SMSClient(masterSecret, appkey);
    	//这个TempId就是模板方法。我上面也说了我用的是id为1的通用五分钟模板方法。根据是实际需求你们自己看着写
    	SMSPayload payload = SMSPayload.newBuilder().setMobileNumber(tel).setTempId(1).build();
    	//正式发送。然后极光返回给的返回值res也是封装好了的对象。
    	//其中，messageId是用来验证验证码的，要保存。
    	//code:200成功，失败报错
    	try {
    		SendSMSResult res = client.sendSMSCode(payload);
    		String messageId = res.getMessageId();
    		res.getResponseCode();
    		return messageId;
		} catch (Exception e) {
			LOG.info("Error Message: " + e.getMessage());

			return null;
		}
    }
    
    //验证用户输入的验证码
    //验证验证码需要发送的时候返回的messageId。还有就是用户输入验证码 这两个参数。
    //用户输入对了返回true，输错了返回false。如果超过五分钟了哪怕用户输入对了也会返回false
    public static boolean sendVaildSMSCode(String messageId, String vCode) {
    	//创建连接对象
    	SMSClient client = new SMSClient(masterSecret, appkey);
    	try {
    		//发送验证码，注意一点。这个假如验证码错误就直接报错了
    		ValidSMSResult res = client.sendValidSMSCode(messageId ,vCode); 
    		return true;
		} catch (Exception e) {
			LOG.info("Error Message: " + e.getMessage());
			return false;
		}
    }
    
    //发送短信
    public static void testSendSMSCode(String phone) {
    	SMSClient client = new SMSClient(masterSecret, appkey);
    	SMSPayload payload = SMSPayload.newBuilder()
				.setMobileNumber("13800138000")
				.setTempId(1)
				.build();
    	try {
			SendSMSResult res = client.sendSMSCode(payload);
            System.out.println(res.toString());
			LOG.info(res.toString());
		} catch (APIConnectionException e) {
            LOG.error("Connection error. Should retry later. ", e);
        } catch (APIRequestException e) {
            LOG.error("Error response from JPush server. Should review and fix it. ", e);
            LOG.info("HTTP Status: " + e.getStatus());
            LOG.info("Error Message: " + e.getMessage());
        }
    }
    
    //发送验证码
    public static Boolean testSendValidSMSCode(String msg_id,String valid) {
    	SMSClient client = new SMSClient(masterSecret, appkey);
    	Boolean flag = false;
		try {
			ValidSMSResult res = client.sendValidSMSCode("01658697-45d9-4644-996d-69a1b14e2bb8", "556618");
            System.out.println(res.toString());
			LOG.info(res.toString());
			flag = true;
		} catch (APIConnectionException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            LOG.error("Connection error. Should retry later. ", e);
        } catch (APIRequestException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 50010) {
                // do something
            }
            System.out.println(e.getStatus() + " errorCode: " + e.getErrorCode() + " " + e.getErrorMessage());
            LOG.error("Error response from JPush server. Should review and fix it. ", e);
            LOG.info("HTTP Status: " + e.getStatus());
            LOG.info("Error Message: " + e.getMessage());
        }
		return flag;
	}
}