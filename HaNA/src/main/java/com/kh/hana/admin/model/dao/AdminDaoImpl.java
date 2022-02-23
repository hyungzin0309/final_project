package com.kh.hana.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
public class AdminDaoImpl implements AdminDao {
	
	@Autowired
	private SqlSession session;

	@Override
	public List<Map<String, Object>> selectRestrictionList(int limit, int offset) {
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("admin.selectRestrictionList", null, rowBounds);
	}
	
	@Override
	public List<Map<String, Object>> selectSearchStatistics(Map<String, Object> param) {
		return session.selectList("admin.selectSearchStatistics",param);
	}

	@Override
	public int insertHashtag(String name) {
		return session.insert("admin.insertHashtag",name);
	}

	@Override
	public int deleteHashtag(String name) {
		return session.delete("deleteHashtag",name);
	}

	@Override
	public int selectRestrictionListTotalCount() {
		return session.selectOne("admin.selectRestrictionListTotalCount", null);
	}

	@Override
	public List<Map<String, Object>> selectAppealList(int limit, int offset) {
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("admin.selectAppealList", null, rowBounds);
	}

	@Override
	public int selectAppealListTotalCount() {
		return session.selectOne("admin.selectAppealListTotalCount", null);
	}

	@Override
	public List<Map<String, Object>> selectReportedHistory(String id) {
		return session.selectList("admin.selectReportedHistory", id);
	}

	@Override
	public int updateUserRestrictedDate(String id) {
		return session.update("admin.updateUserRestrictedDate", id);
	}

	
}
