package com.kh.hana.group.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupMemberList;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupCalendar;

public interface GroupDao {
	
	public Group selectOneGroup(String groupId);

	public int insertOneGroup(Group group);

	public List<Group> selectGroupList(Member member);
	
	public int insertGroupBoard(GroupBoard groupBoard);

	public GroupBoard selectOneBoard(int no);

	List<Member> selectTagMemberList(GroupBoard groupBoard);

	public List<Map<String,String>> selectGroupMemberList(String groupId);

	public List<GroupBoard> selectGroupBoardList(String groupId);

	public int insertGroupBoardComment(GroupBoardComment groupBoardComment);

	public int insertEnrollGroupForm(Map<String, Object> map);

	public List<Map<String, Object>> selectGroupApplyList(String groupId);

	public List<GroupBoardComment> selectGroupBoardCommentList(int boardNo);

	public int deleteBoardComment(int no);

	public int insertGroupMember(Map<String, Object> map);

	public int updateApplyHandled(Map<String, Object> map);

	public int deleteGroupBoard(int no);

	public int updateBoardContent(Map<String, Object> param);
	
//	public List<Map<String, Object>> groupMemberList(String groupId);

	public Group selectGroupInfo(String groupId);

	public Map<String, Object> selectOneLikeLog(Map<String, Object> param);

	public int deleteLikeLog(Map<String, Object> param);

	public int insertLikeLog(Map<String, Object> param);

	public int selectLikeCount(Map<String, Object> param);

	public int deleteGroupMember(Map<String,Object> param);

	public int updateGroupMemberLevel(Map<String, Object> param);

	public int updateGroup(Group group);

	public int deleteAllCalendar(String groupId);

	public int insertCalendarData(Map<String, Object> p);

	public List<GroupCalendar> selectCalendarData(String groupId);

	public int profileImage(Group group);

	public int deleteCalendarData(Map<String, Object> param);

	public List<GroupBoard> selectGroupBoardListByLocation(GroupBoard groupBoard);

	public int insertGroupVisitLog(Map<String, Object> param);

	public Map<String, Object> selectGroupVisitLog(Map<String, Object> param);

	public List<Map<String, Object>> selectVisitCountList(Map<String, Object> param);

	public List<Map<String, Object>> selectCommentCountList(Map<String, Object> param);

	public List<Map<String, Object>> selectLikeCountList(Map<String, Object> param);

	public List<String> selectHashtagList();

	public List<String> selectLikeHashtagList(Member member);

	public int insertMemberLikeHashtag(Map<String, Object> param);

	public int deleteMemberLikeHashtag(Map<String, Object> param);

	public List<Group> selectRecommendedGroupList(Member member);

	public int updateGroupLeader(Map<String, Object> param);

	public int deleteGroup(String groupId);

	public int selectOneId(String id);

	public String selectGroupMemberLevel(Map<String, Object> map);

	public int selectGroupApplyLog(Map<String, Object> map);

	public List<GroupBoard> selectGroupBoardListByHashtag(String hashtag);

	public List<Map<String,Object>> selectGroupListByVisitCount(Map<String, Object> param);

	public int selectAllGroupCount();

	public int selectAllGroupCountByHashtag(Map<String, Object> param);

	public List<Map<String, Object>> selectGroupListByMemberCount(Map<String, Object> param);

	public List<Map<String, Object>> selectGroupListByApplyCount(Map<String, Object> param);
}
