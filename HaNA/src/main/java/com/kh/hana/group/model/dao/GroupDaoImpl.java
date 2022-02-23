package com.kh.hana.group.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupMemberList;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupCalendar;

@Repository
public class GroupDaoImpl implements GroupDao {

	@Autowired
	private SqlSession session;
	
	@Override
	public Group selectOneGroup(String groupId) {
		return session.selectOne("group.selectOneGroup",groupId);
	}

	@Override
	public int insertOneGroup(Group group) {
		return session.insert("group.insertOneGroup",group);
	}

	@Override
	public List<Group> selectGroupList(Member member) {
		return session.selectList("group.selectGroupList",member);
	}
  
    @Override
	public int insertGroupBoard(GroupBoard groupBoard) {
		return session.insert("group.insertGroupBoard", groupBoard);
	}

	@Override
	public GroupBoard selectOneBoard(int no) {
		return session.selectOne("group.selectOneBoard",no);
	}

	@Override
	public List<Member> selectTagMemberList(GroupBoard groupBoard) {
		return session.selectList("group.selectTagMemberList", groupBoard);
	}

	@Override
	public List<Map<String,String>> selectGroupMemberList(String groupId) {
		return session.selectList("group.selectGroupMemberList",groupId);
	}

	@Override
	public List<GroupBoard> selectGroupBoardList(String groupId) {
		return session.selectList("group.selectGroupBoardList",groupId);
	}

	@Override
	public int insertEnrollGroupForm(Map<String, Object> map) {
		return session.insert("group.insertEnrollGroupForm", map);
	}

	@Override
	public List<Map<String, Object>> selectGroupApplyList(String groupId) {
		return session.selectList("group.selectGroupApplyList", groupId);
	}
	  
    @Override
    public int insertGroupBoardComment(GroupBoardComment groupBoardComment) {
	 	return session.insert("group.insertGroupBoardComment",groupBoardComment);
	}

	@Override
	public List<GroupBoardComment> selectGroupBoardCommentList(int boardNo) {
		return session.selectList("group.selectGroupBoardCommentList",boardNo);
	}
	
	@Override
	public int deleteBoardComment(int no) {
		return session.delete("group.deleteBoardComment",no);
	}

	@Override
	public int insertGroupMember(Map<String, Object> map) {
		return session.insert("group.insertGroupMember", map);
	}

	@Override
	public int updateApplyHandled(Map<String, Object> map) {
		return session.update("group.updateApplyHandled", map);
	}

	@Override
	public int deleteGroupBoard(int no) {
		return session.delete("group.deleteGroupBoard",no);
	}

	@Override
	public int updateBoardContent(Map<String, Object> param) {
		return session.update("group.updateBoardContent",param);
	}

//	@Override
//	public List<Map<String, Object>> groupMemberList(String groupId) {
//		return session.selectList("groupMemberList", groupId);
//	}

	@Override
	public Group selectGroupInfo(String groupId) {
		return session.selectOne("group.selectGroupInfo", groupId);
	}

	@Override
	public Map<String, Object> selectOneLikeLog(Map<String, Object> param) {
		return session.selectOne("group.selectOneLikeLog",param);
	}

	@Override
	public int deleteLikeLog(Map<String, Object> param) {
		return session.delete("group.deleteLikeLog",param);
	}

	@Override
	public int insertLikeLog(Map<String, Object> param) {
		return session.insert("group.insertLikeLog",param);
	}

	@Override
	public int selectLikeCount(Map<String, Object> param) {
		return session.selectOne("group.selectLikeCount",param);
	}

	@Override
	public int deleteGroupMember(Map<String,Object> param) {
		return session.delete("group.deleteGroupMember", param);
	}

	@Override
	public int updateGroupMemberLevel(Map<String, Object> param) {
		return session.update("group.updateGroupMemberLevel", param);
	}
	
	@Override
	public int updateGroup(Group group) {
		return session.update("group.updateGroup", group);
	}
		
	@Override
	public int deleteAllCalendar(String groupId) {
		return session.delete("group.deleteAllCalendar",groupId);
	}

	@Override
	public int insertCalendarData(Map<String, Object> p) {
		return session.insert("group.insertCalendarData",p);
	}

	@Override
	public List<GroupCalendar> selectCalendarData(String groupId) {
		return session.selectList("group.selectCalendarData",groupId);
	}

	@Override
	public int profileImage(Group group) {
		return session.insert("group.profileImage", group);
	}
	
	@Override
	public int deleteCalendarData(Map<String, Object> param) {
		return session.delete("group.deleteCalendarData",param);
	}

	@Override
	public List<GroupBoard> selectGroupBoardListByLocation(GroupBoard groupBoard) {
		return session.selectList("group.selectGroupBoardListByLocation",groupBoard);
	}

	@Override
	public int insertGroupVisitLog(Map<String, Object> param) {
		return session.insert("group.insertGroupVisitLog",param);
	}

	@Override
	public Map<String, Object> selectGroupVisitLog(Map<String, Object> param) {
		return session.selectOne("group.selectGroupVisitLog", param);
	}

	@Override
	public List<Map<String, Object>> selectVisitCountList(Map<String, Object> param) {
		return session.selectList("group.selectVisitCountList",param);
	}

	@Override
	public List<Map<String, Object>> selectCommentCountList(Map<String, Object> param) {
		return session.selectList("group.selectCommentCountList",param);
	}

	@Override
	public List<Map<String, Object>> selectLikeCountList(Map<String, Object> param) {
		return session.selectList("group.selectLikeCountList",param);
	}

	@Override
	public List<String> selectHashtagList() {
		return session.selectList("group.selectHashtagList");
	}

	@Override
	public List<String> selectLikeHashtagList(Member member) {
		return session.selectList("group.selectLikeHashtagList",member);
	}

	@Override
	public int insertMemberLikeHashtag(Map<String, Object> param) {
		return session.insert("group.insertMemberLikeHashtag",param);
	}

	@Override
	public int deleteMemberLikeHashtag(Map<String, Object> param) {
		return session.delete("group.deleteMemberLikeHashtag",param);
	}

	@Override
	public List<Group> selectRecommendedGroupList(Member member) {
		return session.selectList("group.selectRecommendedGroupList",member);
	}

	@Override
	public int updateGroupLeader(Map<String, Object> param) {
		return session.update("group.updateGroupLeader", param);
	}

	@Override
	public int deleteGroup(String groupId) {
		return session.delete("group.deleteGroup", groupId);
	}

	@Override
	public int selectOneId(String id) {
		return session.selectOne("group.selectOneId",id);
	}

	@Override
	public String selectGroupMemberLevel(Map<String, Object> map) {
		return session.selectOne("group.selectGroupMemberLevel",map);
	}

	@Override
	public int selectGroupApplyLog(Map<String, Object> map) {
		return session.selectOne("group.selectGroupApplyLog",map);
	}

	@Override
	public List<GroupBoard> selectGroupBoardListByHashtag(String hashtag) {
		return session.selectList("group.selectGroupBoardListByHashtag",hashtag);
	}

	@Override
	public List<Map<String,Object>> selectGroupListByVisitCount(Map<String, Object> param) {
		int offset = (int) param.get("offset");
		int limit = (int) param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("group.selectGroupListByVisitCount",param,rowBounds);
	}

	@Override
	public int selectAllGroupCount() {
		return session.selectOne("group.selectAllGroupCount");
	}

	@Override
	public int selectAllGroupCountByHashtag(Map<String, Object> param) {
		return session.selectOne("group.selectAllGroupCountByHashtag",param);
	}

	@Override
	public List<Map<String, Object>> selectGroupListByMemberCount(Map<String, Object> param) {
		int offset = (int) param.get("offset");
		int limit = (int) param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("group.selectGroupListByMemberCount",param,rowBounds);
	}

	@Override
	public List<Map<String, Object>> selectGroupListByApplyCount(Map<String, Object> param) {
		int offset = (int) param.get("offset");
		int limit = (int) param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("group.selectGroupListByApplyCount",param,rowBounds);
	}
	


}
