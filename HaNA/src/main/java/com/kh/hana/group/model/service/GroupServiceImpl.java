package com.kh.hana.group.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.hana.group.model.dao.GroupDao;
import com.kh.hana.group.model.vo.Group;
import com.kh.hana.member.model.vo.Member;


@Service
public class GroupServiceImpl implements GroupService{

	@Autowired
	private GroupDao groupDao;
	
	@Override
	public Group selectOneGroup(String groupId) {
		return groupDao.selectOneGroup(groupId);
	}

	@Override
	public int insertOneGroup(Group group) {
		return groupDao.insertOneGroup(group);
	}

	@Override
	public Map<String, String> selectGroupEnrolled(Map<String, String> map) {
		return groupDao.selectGroupEnrolled(map);
	}

	@Override
	public List<Group> selectGroupList(Member member) {
		return groupDao.selectGroupList(member);
	}

}
