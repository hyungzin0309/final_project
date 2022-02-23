package com.kh.hana.member.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Follower;
import com.kh.hana.member.model.vo.FollowingRequest;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.Shop;

public interface MemberDao {

	int memberEnroll(Member member);

	int updateMember(Member member);

	//int updatePersonality(Member member);

	//int updateInterest(Member member);

	//Member selectPersonality(String id);

	//int insertPersonality(Member member);

	//int insertInterest(Member member);

	int addFollowing(Map<String, Object> map);

	int countFollowing(String id);

	Member selectOneMember(String id);

	int countFollower(String id);

	List<Follower> followerList(String friendId);

	List<Follower> followingList(String friendId);
	
	List<Map<String, Object>> followingListById(Map<String, Object> map);
 
	Shop selectOneShopInfo(String memberId);

	int updateShopInfo(Shop shop);

	int insertShopInfo(String id);

	int insertMemberBoard(Board board);

	int updateMemberProfile(Member member);

	int updatePassword(Member updateMember);

	Board selectOneBoard(int no);

	Map<String, Object> selectOneLikeLog(Map<String, Object> param);

	List<Board> selectBoardList(String id);

	int enrollBoardComment(BoardComment boardComment);

	int deleteBoard(int no);

	List<BoardComment> selectBoardCommentList(int boardNo);

	int deleteBoardComment(int no);

	int updateBoardContent(Map<String, Object> param);

	int insertLikeLog(Map<String, Object> param);

	int deleteLikeLog(Map<String, Object> param);

	int selectLikeCount(Map<String, Object> param);
 
	int checkAccountPrivate(Map<String, Object> map);

	int checkFriend(Map<String, Object> map);

	int requestFollowing(Map<String, Object> map);

	int followingRequest(Map<String, Object> map);

	List<FollowingRequest> requestFollowingList(String myId);

	int applyFollowing(Map<String, Object> map);

	int addRequestFollowing(Map<String, Object> map);

	int refuseFollowing(Map<String, Object> map);

	int insertReview(Board board);

	int isRequestFriend(Map<String, Object> map);

	List<Board> selectShopReviewList(String id);

	int checkFollow(Map<String, Object> map);

	int insertReport(Map<String, Object> map);

	int selectReportUser(Map<String, Object> map);

	Map<String, Object> selectRestrictionData(String id);

	int appealMyDistriction(String id);

	//int checkRefuse(Map<String, Object> map);

 

	 

 

}
