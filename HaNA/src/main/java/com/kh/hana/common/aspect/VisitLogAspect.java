package com.kh.hana.common.aspect;

import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Component;

import com.kh.hana.group.model.service.GroupService;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@Aspect
public class VisitLogAspect {
	
	@Autowired
	private GroupService groupService;
	
	@Pointcut("execution(* com.kh.hana.group.controller.GroupController.groupPage(..))")
	public void groupPage() {}
	
	// 소모임 방문 로그 남기기
	@AfterReturning(pointcut="groupPage()", returning="returnObj")
	public void afterReturningAdvice(JoinPoint joinPoint, Object returnObj) throws Throwable{
		Object args[] = joinPoint.getArgs();
		
		Map<String,Object> param = new HashMap<>();
		param.put("groupId",args[0]);
		param.put("member",args[2]);
		
		int result = groupService.insertGroupVisitLog(param);
	}
	
}
