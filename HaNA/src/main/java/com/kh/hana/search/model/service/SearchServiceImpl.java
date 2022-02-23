package com.kh.hana.search.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.search.model.dao.SearchDao;

@Service
@Transactional(rollbackFor=Exception.class)
public class SearchServiceImpl implements SearchService{

	@Autowired
	private SearchDao searchDao;

	@Override
	public List<Member> selectMemberListBySearch(String keyword) {
		return searchDao.selectMemberListBySearch(keyword);
	}

	@Override
	public List<Group> selectGroupListBySearch(String keyword) {
		return searchDao.selectGroupListBySearch(keyword);
	}

	@Override
	public List<Member> selectShopListBySearch(String keyword) {
		return searchDao.selectShopListBySearch(keyword);
	}

	@Override
	public List<Map<String, Object>> selectLocationListBySearch(String keyword) {
		return searchDao.selectLocationListBySearch(keyword);
	}

	@Override
	public int insertSearchKeywordLog(Map<String, Object> param) {
		return searchDao.insertSearchKeywordLog(param);
	}
	
}
