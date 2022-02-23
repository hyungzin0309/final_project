package com.kh.hana.group.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.hana.chat.model.dao.ChatDao;
import com.kh.hana.group.model.dao.GroupDao;
import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

import com.kh.hana.group.model.vo.GroupMemberList;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupCalendar;

@Service
@Slf4j
@Transactional(rollbackFor=Exception.class) // 익셉션 발생시 롤백
public class GroupServiceImpl implements GroupService{

	@Autowired
	private GroupDao groupDao;
	@Autowired
	private ChatDao chatDao;
	
	@Override
	public Group selectOneGroup(String groupId) {
		return groupDao.selectOneGroup(groupId);
	}

	@Override
	public int insertOneGroup(Group group) {
		Map<String, Object> param = new HashMap<String, Object>();
		int result = 0;
		int roomNo = 0;
		try {
			result = groupDao.insertOneGroup(group);
			if(result>0) result = chatDao.CreateGroupChat(group);
			if(result>0) roomNo = chatDao.selectGroupRoomNo(group);			
			param.put("group", group);
			param.put("roomNo", roomNo);
			log.info("CreateGroupChat serviceImpl roomNo넣음= {}", param);
			if(result > 0)
				result = chatDao.insertGroupMessage(param);
		}catch(Exception e) {
			throw e;
		}
		return result;
	}

	@Override
	public List<Group> selectGroupList(Member member) {
		return groupDao.selectGroupList(member);
	}
	
  @Override
	public int insertGroupBoard(GroupBoard groupBoard) {
		return groupDao.insertGroupBoard(groupBoard);
	}

	@Override
	public GroupBoard selectOneBoard(int no) {
		return groupDao.selectOneBoard(no);
	}

	@Override
	public List<Member> selectTagMemberList(GroupBoard groupBoard) {
		return groupDao.selectTagMemberList(groupBoard);
	}

	@Override
	public List<Map<String,String>> selectGroupMemberList(String groupId) {
		return groupDao.selectGroupMemberList(groupId);
	}

	@Override
	public List<GroupBoard> selectGroupBoardList(String groupId) {
		return groupDao.selectGroupBoardList(groupId);
	}

	@Override
	public int insertEnrollGroupForm(Map<String, Object> map) {
		return groupDao.insertEnrollGroupForm(map);
	}

	@Override
	public List<Map<String, Object>> selectGroupApplyList(String groupId) {
		return groupDao.selectGroupApplyList(groupId);
	}

  
	 @Override
	 public int insertGroupBoardComment(GroupBoardComment groupBoardComment) {
		return groupDao.insertGroupBoardComment(groupBoardComment);
	 }
	
	@Override
	public int insertGroupMember(Map<String, Object> map) {
		int result = 0;
		try {
			result = groupDao.insertGroupMember(map); // 멤버 추가
			result = groupDao.updateApplyHandled(map); // 처리여부 업데이트
			result = chatDao.updateROOMOUTmessage(map); // 한번 탈퇴했었다면 이전 퇴장메세지 변경
    		result = chatDao.insertGroupMessage22(map); // 그룹톡 입장
		}catch(Exception e) {
			throw e;
		}
		return result;
	}

	@Override
	public int updateApplyHandled(Map<String, Object> map) {
		return groupDao.updateApplyHandled(map);
	}	

	@Override
	public List<GroupBoardComment> selectGroupBoardCommentList(int boardNo) {
		return groupDao.selectGroupBoardCommentList(boardNo);
	}
	
	@Override
	public int deleteBoardComment(int no) {
		return groupDao.deleteBoardComment(no);
	}

	@Override
	public int deleteGroupBoard(int no) {
		return groupDao.deleteGroupBoard(no);
	}

	@Override
	public int updateBoardContent(Map<String, Object> param) {
		return groupDao.updateBoardContent(param);
	}


	@Override
	public Group selectGroupInfo(String groupId) {
		return groupDao.selectGroupInfo(groupId);
	}

	public Map<String, Object> selectOneLikeLog(Map<String, Object> param) {
		return groupDao.selectOneLikeLog(param);
	}

	@Override
	public int deleteLikeLog(Map<String, Object> param) {
		return groupDao.deleteLikeLog(param);
	}

	@Override
	public int insertLikeLog(Map<String, Object> param) {
		return groupDao.insertLikeLog(param);
	}

	@Override
	public int selectLikeCount(Map<String, Object> param) {
		return groupDao.selectLikeCount(param);
	}

	@Override
	public int deleteGroupMember(Map<String,Object> param) {
		int result = 0;
		result = groupDao.deleteGroupMember(param);
		if(result>0) result = chatDao.GroupRoomOutMessage(param);
		return result;
	}

	@Override
	public int updateGroupMemberLevel(Map<String, Object> param) {
		int result = 0;
		//바꿀 레벨이 ld면
		if(param.get("updateLevel").equals("ld")) {
			result = groupDao.updateGroupLeader(param);
			if(result > 0) {
				result = groupDao.updateGroupMemberLevel(param);
			}
		}
		else {
			result = groupDao.updateGroupMemberLevel(param);
		}

		return result;
	}

	@Override
	public int updateGroup(Group group) {
		int result = chatDao.roomChatUpdate(group);
		return groupDao.updateGroup(group);
	}

	
	public int deleteAllCalendar(String groupId) {
		return groupDao.deleteAllCalendar(groupId);
	}

	@Override
	public int insertCalendarData(Map<String, Object> p) {
		return groupDao.insertCalendarData(p);
	}

	@Override
	public List<GroupCalendar> selectCalendarData(String groupId) {
		return groupDao.selectCalendarData(groupId);
	}

	@Override
	public int profileImage(Group group) {
		int result = groupDao.profileImage(group);
		result = chatDao.roomChatUpdateImage(group);
		return result;
	}

	public int deleteCalendarData(Map<String, Object> param) {
		return groupDao.deleteCalendarData(param);
	}

	@Override
	public List<GroupBoard> selectGroupBoardListByLocation(GroupBoard groupBoard) {
		return groupDao.selectGroupBoardListByLocation(groupBoard);
	}

	@Override
	public int insertGroupVisitLog(Map<String, Object> param) {
		int result = 0;
		Map<String,Object> map = groupDao.selectGroupVisitLog(param);
		if(map==null) {
			result = groupDao.insertGroupVisitLog(param);
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectVisitCountList(Map<String, Object> param) {
		return groupDao.selectVisitCountList(param);
	}

	@Override
	public List<Map<String, Object>> selectCommentCountList(Map<String, Object> param) {
		return groupDao.selectCommentCountList(param);
	}

	@Override
	public List<Map<String, Object>> selectLikeCountList(Map<String, Object> param) {
		return groupDao.selectLikeCountList(param);
	}

	@Override
	public List<String> selectHashtagList() {
		return groupDao.selectHashtagList();
	}

	@Override
	public List<String> selectLikeHashtagList(Member member) {
		return groupDao.selectLikeHashtagList(member);
	}

	@Override
	public int insertMemberLikeHashtag(Map<String, Object> param) {
		return groupDao.insertMemberLikeHashtag(param);
	}

	@Override
	public int deleteMemberLikeHashtag(Map<String, Object> param) {
		return groupDao.deleteMemberLikeHashtag(param);
	}

	@Override
	public List<Group> selectRecommendedGroupList(Member member) {
		return groupDao.selectRecommendedGroupList(member);
	}

	@Override
	public int deleteGroup(String groupId) {
		return groupDao.deleteGroup(groupId);
	}

	@Override
	public int selectOneId(String id) {
		return groupDao.selectOneId(id);
	}

	@Override
	public String selectGroupMemberLevel(Map<String, Object> map) {
		return groupDao.selectGroupMemberLevel(map);
	}

	@Override
	public int selectGroupApplyLog(Map<String, Object> map) {
		return groupDao.selectGroupApplyLog(map);
	}

	@Override
	public List<GroupBoard> selectGroupBoardListByHashtag(String hashtag) {
		return groupDao.selectGroupBoardListByHashtag(hashtag);
	}

	@Override
	public List<Map<String,Object>> selectGroupListByVisitCount(Map<String, Object> param) {
		return groupDao.selectGroupListByVisitCount(param);
	}

	@Override
	public int selectAllGroupCount() {
		return groupDao.selectAllGroupCount();
	}

	@Override
	public int selectAllGroupCountByHashtag(Map<String, Object> param) {
		return groupDao.selectAllGroupCountByHashtag(param);
	}

	@Override
	public List<Map<String, Object>> selectGroupListByMemberCount(Map<String, Object> param) {
		return groupDao.selectGroupListByMemberCount(param);
	}

	@Override
	public List<Map<String, Object>> selectGroupListByApplyCount(Map<String, Object> param) {
		return groupDao.selectGroupListByApplyCount(param);

	}

}
