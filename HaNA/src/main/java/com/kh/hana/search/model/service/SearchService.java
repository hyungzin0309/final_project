package com.kh.hana.search.model.service;

import java.util.List;
import java.util.Map;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.member.model.vo.Member;

public interface SearchService {

	List<Member> selectMemberListBySearch(String keyword);

	List<Group> selectGroupListBySearch(String keyword);
	
	List<Member> selectShopListBySearch(String keyword);
	
	List<Map<String,Object>> selectLocationListBySearch(String keyword);

	int insertSearchKeywordLog(Map<String, Object> param);

}
