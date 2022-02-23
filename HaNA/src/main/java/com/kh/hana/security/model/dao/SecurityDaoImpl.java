package com.kh.hana.security.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

@Repository
public class SecurityDaoImpl implements SecurityDao {

	@Autowired
	private SqlSession session;
	
	@Override
	public UserDetails loadUserByUsername(String username) {
		return session.selectOne("security.loadUserByUsername", username);
	}

	@Override
	public int selctUserReportCount(String username) {
		return session.selectOne("security.selectUserReportCount", username);
	}

	@Override
	public int deleteUserRole(String username) {
		return session.delete("security.deleteUserRole", username);
	}

	@Override
	public int selectUserRestrictCount(String username) {
		return session.selectOne("security.selectUserRestrictCount", username);
	}

	@Override
	public int selectUserRoleCount(String username) {
		return session.selectOne("security.selectUserRoleCount", username);
	}

	@Override
	public int insertUserRole(String username) {
		return session.insert("security.insertUserRole", username);
	}

	@Override
	public int updateReportHistoryS2Y(String username) {
		return session.update("security.updateReportHistoryS2Y", username);
	}
	
	

}
