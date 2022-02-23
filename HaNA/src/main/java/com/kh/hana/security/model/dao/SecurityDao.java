package com.kh.hana.security.model.dao;

import org.springframework.security.core.userdetails.UserDetails;

public interface SecurityDao {

	UserDetails loadUserByUsername(String username);

	int selctUserReportCount(String username);

	int deleteUserRole(String username);

	int selectUserRestrictCount(String username);

	int selectUserRoleCount(String username);

	int insertUserRole(String username);

	int updateReportHistoryS2Y(String username);

}
