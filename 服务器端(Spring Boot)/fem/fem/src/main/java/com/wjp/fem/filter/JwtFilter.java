package com.wjp.fem.filter;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.auth0.jwt.interfaces.Claim;
import com.wjp.fem.util.JwtUtil;

/**
 * Servlet Filter implementation class JwtFilter
 */

@WebFilter(filterName = "JwtFilter", urlPatterns = {"/record/*", "/elec/*", "/temp/*",
			"/user/getSpotList", "/user/alertPassword", "/user/addSpot", "/user/getUsers","/user/removeSpot"})
public class JwtFilter implements Filter {
	private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);
    /**
     * Default constructor. 
     */
    public JwtFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		final HttpServletRequest request = (HttpServletRequest) req;
        final HttpServletResponse response = (HttpServletResponse) res;
		response.setCharacterEncoding("UTF-8");
		//获取header里面的token
		final String token = request.getHeader("authorization");
//		Enumeration<String> enumeration = request.getHeaderNames();
//		while(enumeration.hasMoreElements()) {
//			String headerName = (String) enumeration.nextElement();
//			String headerValue = request.getHeader(headerName);
//			System.out.println(headerName);
//			System.out.println(headerValue);
//			System.out.println();
//		}
		
		
		//OPTIONS请求直接放行
		if("OPTIONS".equals(request.getMethod())) {
			response.setStatus(HttpServletResponse.SC_OK);
			chain.doFilter(req, res);
		// Except OPTIONS, other request should be checked by JWT
		} else {
			if(token == null) {
				response.getWriter().write("没有token");
				System.out.println("没有token");
				return;
			}
			Map<String, Claim> userData = JwtUtil.verifyToken(token);
			if(userData == null) {
				response.getWriter().write("token为空");
				System.out.println("token为空");
				return;
			}
//			String userId = userData.get("userId").asString();
//			String password = userData.get("password").asString();
//			String userName = userData.get("userName").asString();
			//拦截器，拿到用户信息，放到request中
//			request.setAttribute("userId", userId);
//			request.setAttribute("password", password);
//			request.setAttribute("userName", userName);
//			System.out.println("可以放行");
			chain.doFilter(req, res);
		}
		
		
		
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		
	}

}
