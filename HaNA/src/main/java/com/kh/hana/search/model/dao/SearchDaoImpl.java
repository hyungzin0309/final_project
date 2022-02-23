package com.kh.hana.search.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.member.model.vo.Member;

@Repository
public class SearchDaoImpl implements SearchDao{

	@Autowired
	private SqlSession session;
	
	@Override
	public List<Member> selectMemberListBySearch(String keyword) {
		return session.selectList("search.selectMemberListBySearch",keyword);
	}

	@Override
	public List<Group> selectGroupListBySearch(String keyword) {
		return session.selectList("search.selectGroupListBySearch",keyword);
	}

	@Override
	public List<Member> selectShopListBySearch(String keyword) {
		return session.selectList("search.selectShopListBySearch",keyword);
	}

	@Override
	public List<Map<String, Object>> selectLocationListBySearch(String keyword) {
		return session.selectList("search.selectLocationListBySearch",keyword);
	}

	@Override
	public int insertSearchKeywordLog(Map<String, Object> param) {
		return session.insert("search.insertSearchKeywordLog",param);
	}

}
