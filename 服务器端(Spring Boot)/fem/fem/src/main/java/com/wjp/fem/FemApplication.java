package com.wjp.fem;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

import com.wjp.fem.util.urlUtil;
@EnableScheduling
@SpringBootApplication
@MapperScan("com.wjp.fem.dao")
@ServletComponentScan(basePackages = "com.wjp.fem.filter")
public class FemApplication {

	public static void main(String[] args) {
		SpringApplication.run(FemApplication.class, args);
		System.out.println(urlUtil.getIp());
		
	}
}
