package com.kh.hana.security.model.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import com.kh.hana.security.model.dao.SecurityDao;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SecurityService implements UserDetailsService {

	@Autowired
	private SecurityDao securityDao;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		
		// 1. 로그인 전 신고내역을 확인하여 제제여부를 판단한다.
		int reportCount = securityDao.selctUserReportCount(username);
		
		// 제제 되지 않은 신고내역이 10개 이상인 경우 유저 role 제거하여 제제
		// + 제제 시 기존에 신고된 내역은 모두 S로 변경
		// + trigger 통해서 user_restricted에 제제 추가(7일)
		if(reportCount >= 10) {
			int restrictUserResult = securityDao.deleteUserRole(username);
			log.info("restrictUserResult = {}", restrictUserResult);
		}
		
		// 2. 로그인 전 제제내역을 확인하여 제제기간이 지난경우 유저 role을 추가해준다.
		// user_role을 가지고 있는가?
		int userRoleCount = securityDao.selectUserRoleCount(username);
		if(userRoleCount == 0) {
			// 현 시각이 포함된 제제 row가 있는가?
			int restrictedCount = securityDao.selectUserRestrictCount(username);
			log.info("resCount = {}", restrictedCount);
			if(restrictedCount == 0) {
				// user_role이 없는데, 현시각 포함된 제제내역이 없는 경우, user_role을 부여
				int insertUserRole = securityDao.insertUserRole(username);
				log.info("insertRole = {}", insertUserRole);
				// user_role 복구 시, 신고내역 S -> Y로 변경
				int historyS2Y = securityDao.updateReportHistoryS2Y(username);
				log.info("historyCHange = {}", historyS2Y);
			}
		}
		UserDetails member = securityDao.loadUserByUsername(username);
		log.info("load member = {}", member);
		
		if(member == null) {
			throw new UsernameNotFoundException(username);
		}
		

		return member;
	}

}
