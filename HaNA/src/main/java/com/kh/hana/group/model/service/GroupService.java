package com.kh.hana.group.model.service;

import java.util.List;
import java.util.Map;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Member;

import com.kh.hana.group.model.vo.GroupMemberList;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupCalendar;


public interface GroupService {

	Group selectOneGroup(String groupId);

	int insertOneGroup(Group group);

	List<Group> selectGroupList(Member member);

	int insertGroupBoard(GroupBoard groupBoard);

	GroupBoard selectOneBoard(int no);

	List<Member> selectTagMemberList(GroupBoard groupBoard);

	List<Map<String,String>> selectGroupMemberList(String groupId);

	List<GroupBoard> selectGroupBoardList(String groupId);

	int insertGroupBoardComment(GroupBoardComment groupBoardComment);

	int insertEnrollGroupForm(Map<String, Object> map);

	List<Map<String, Object>> selectGroupApplyList(String groupId);

	List<GroupBoardComment> selectGroupBoardCommentList(int boardNo);

	int deleteBoardComment(int no);
	
	int insertGroupMember(Map<String, Object> map);

	int updateApplyHandled(Map<String, Object> map);

	int deleteGroupBoard(int no);

	int updateBoardContent(Map<String, Object> param);
	
//	List<Map<String, Object>> groupMemberList(String groupId);

	Group selectGroupInfo(String groupId);

	Map<String, Object> selectOneLikeLog(Map<String, Object> param);

	int deleteLikeLog(Map<String, Object> param);

	int insertLikeLog(Map<String, Object> param);

	int selectLikeCount(Map<String, Object> param);

	int deleteGroupMember(Map<String,Object> param);

	int updateGroupMemberLevel(Map<String, Object> param);

	int updateGroup(Group group);

	int deleteAllCalendar(String groupId);

	int insertCalendarData(Map<String, Object> p);

	List<GroupCalendar> selectCalendarData(String groupId);

	int profileImage(Group group);

	int deleteCalendarData(Map<String, Object> param);

	List<GroupBoard> selectGroupBoardListByLocation(GroupBoard groupBoard);

	int insertGroupVisitLog(Map<String, Object> param);

	List<Map<String, Object>> selectVisitCountList(Map<String, Object> param);

	List<Map<String, Object>> selectCommentCountList(Map<String, Object> param);

	List<Map<String, Object>> selectLikeCountList(Map<String, Object> param);

	List<String> selectHashtagList();

	List<String> selectLikeHashtagList(Member member);

	int insertMemberLikeHashtag(Map<String, Object> param);

	int deleteMemberLikeHashtag(Map<String, Object> param);

	List<Group> selectRecommendedGroupList(Member member);

	int deleteGroup(String groupId);

	int selectOneId(String id);

	String selectGroupMemberLevel(Map<String, Object> map);

	int selectGroupApplyLog(Map<String, Object> map);

	List<GroupBoard> selectGroupBoardListByHashtag(String hashtag);

	List<Map<String,Object>> selectGroupListByVisitCount(Map<String, Object> param);

	int selectAllGroupCount();

	int selectAllGroupCountByHashtag(Map<String, Object> param);

	List<Map<String, Object>> selectGroupListByMemberCount(Map<String, Object> param);

	List<Map<String, Object>> selectGroupListByApplyCount(Map<String, Object> param);

	
}
