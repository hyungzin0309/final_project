package com.kh.hana.common.aspect;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.group.model.service.GroupService;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.search.model.service.SearchService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@Aspect
public class GroupMemberLevelCheckAspect {
	@Autowired
	private GroupService groupService;
	
	@Pointcut("execution(* com.kh.hana.group.controller.GroupController.leader*(..))")
	public void leader() {}
	
	@Pointcut("execution(* com.kh.hana.group.controller.GroupController.admin*(..))")
	public void admin() {}
	
	@Around("leader()")
	public Object isLeader(ProceedingJoinPoint joinPoint) throws Throwable{
		// 1. 사용자 입력값
		Object args[] = joinPoint.getArgs();
		
		for(Object o : args) {
			log.debug(" args = {}",o);
		}
		
		// 2. 멤버등급 확인(db)
		Map<String,Object> map = new HashMap<>();
		map.put("memberId", ((Member)args[0]).getId());
		map.put("groupId", args[1]);
		
		String memberLevel = groupService.selectGroupMemberLevel(map);
		
		if(memberLevel == null || !memberLevel.equals("ld")) {
			return "/common/error/forbidden";
		}
		
		return joinPoint.proceed();
	}
	
	@Around("admin()")
	public Object isAdmin(ProceedingJoinPoint joinPoint) throws Throwable{
		// 1. 사용자 입력값
		Object args[] = joinPoint.getArgs();
		
		for(Object o : args) {
			log.debug(" args = {}",o);
		}
		
		// 2. 멤버등급 확인(db)
		Map<String,Object> map = new HashMap<>();
		map.put("memberId", ((Member)args[0]).getId());
		map.put("groupId", args[1]);
		
		String memberLevel = groupService.selectGroupMemberLevel(map);
		
		if(memberLevel == null || memberLevel.equals("mb")) {
			return "/common/error/forbidden";
		}
		
		return joinPoint.proceed();
	}
}
