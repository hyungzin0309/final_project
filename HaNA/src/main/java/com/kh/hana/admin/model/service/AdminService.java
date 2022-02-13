package com.kh.hana.admin.model.service;

import java.util.List;
import java.util.Map;

public interface AdminService {

	List<Map<String, Object>> selectRestrictionList(int limit, int offset);

	List<Map<String, Object>> selectSearchStatistics(Map<String, Object> param);

	int insertHashtag(String name);

	int deleteHashtag(String name);

}
