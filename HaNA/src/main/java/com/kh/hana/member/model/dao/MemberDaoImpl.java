package com.kh.hana.member.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Follower;
import com.kh.hana.member.model.vo.FollowingRequest;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.Shop;

@Repository
public class MemberDaoImpl implements MemberDao {

	@Autowired
	private SqlSession session;
	
	@Override
	public int memberEnroll(Member member) {
		return session.insert("member.memberEnroll", member);
	}

	@Override
	public int updateMember(Member member) {
		return session.update("member.updateMember", member);
	}

	@Override
	public int addFollowing(Map<String, Object> map) {
		return session.insert("member.addFollowing", map);
	}

	@Override
	public int countFollowing(String id) {
		return session.selectOne("member.countFollowing",id);
	}

	@Override
	public int countFollower(String id) {
		return session.selectOne("member.countFollower", id);
	}
	
	@Override
	public Member selectOneMember(String id) {
		return session.selectOne("member.selectOneMember", id);
	}

	@Override
	public List<Follower> followerList(String friendId) {
		return session.selectList("member.followerList", friendId);
	}

	@Override
	public List<Follower> followingList(String friendId) {
		return session.selectList("member.followingList", friendId);
	}
	
	@Override
	public List<Map<String, Object>> followingListById(Map<String, Object> map) {
		return session.selectList("member.followingListById", map);
	}

	public Shop selectOneShopInfo(String memberId) {
		return session.selectOne("member.selectOneShopInfo", memberId);
	}

	@Override
	public int updateShopInfo(Shop shop) {
		return session.update("member.updateShopInfo", shop);
	}

	@Override
	public int insertShopInfo(String id) {
		return session.insert("member.insertShopInfo", id);
	}

	@Override
	public int insertMemberBoard(Board board) {
		return session.insert("member.insertMemberBoard", board);
	}
 
	@Override
	public int updatePassword(Member updateMember) {
		return session.update("member.updatePassword", updateMember);
	}

	@Override
	public Board selectOneBoard(int no) {
		return session.selectOne("member.selectOneBoard", no);
	}

	@Override
	public Map<String, Object> selectOneLikeLog(Map<String, Object> param) {
		return session.selectOne("member.selectOneLikeLog", param);
	}

	@Override
	public List<Board> selectBoardList(String id) {
		return session.selectList("member.selectBoardList", id);
	}

	@Override
	public int enrollBoardComment(BoardComment boardComment) {
		return session.insert("member.enrollBoardComment", boardComment);
	}

	@Override
	public int deleteBoard(int no) {
		return session.delete("member.deleteBoard", no);
	}

	@Override
	public List<BoardComment> selectBoardCommentList(int boardNo) {
		return session.selectList("member.selectBoardCommentList", boardNo);
	}

	@Override
	public int deleteBoardComment(int no) {
		return session.delete("member.deleteBoardComment", no);
	}

	@Override
	public int updateBoardContent(Map<String, Object> param) {
		return session.update("member.updateBoardContent", param);
				}

	@Override
	public int insertLikeLog(Map<String, Object> param) {
		return session.insert("member.insertLikeLog", param);
	}

	@Override
	public int deleteLikeLog(Map<String, Object> param) {
		return session.delete("member.deleteLikeLog", param);
	}

	@Override
	public int selectLikeCount(Map<String, Object> param) {
		return session.selectOne("member.selectLikeCount",param);
	}
			 

	@Override
	public int updateMemberProfile(Member member) {
		return session.update("member.updateMemberProfile", member);
	}

	@Override
	public int checkAccountPrivate(Map<String, Object> map) {
		return session.update("member.updateAccountPrivate",map);
	}

	@Override
	public int checkFriend(Map<String, Object> map) {
		return session.selectOne("member.checkFriend",map);
	}

	@Override
	public int requestFollowing(Map<String, Object> map) {
		return session.insert("member.requestFollowing", map);
	}

	@Override
	public int followingRequest(Map<String, Object> map) {
		return session.selectOne("member.followingRequest", map);
	}

	@Override
	public List<FollowingRequest> requestFollowingList(String myId) {
		return session.selectList("member.requestFollowingList",myId);
	
	}

	@Override
	public int applyFollowing(Map<String, Object> map) {
		return session.delete("member.applyFollowing",map);
	}

	@Override
	public int addRequestFollowing(Map<String, Object> map) {
		return session.insert("member.addRequestFollowing",map);
	}

	@Override
	public int refuseFollowing(Map<String, Object> map) {
		return session.delete("member.refuseFollowing", map);
	}

	@Override
	public int insertReview(Board board) {
		return session.insert("member.insertReview", board);
	}

	public int isRequestFriend(Map<String, Object> map) {
		return session.selectOne("member.isRequestFriend",map);
	}

	@Override
	public List<Board> selectShopReviewList(String id) {
		return session.selectList("member.selectShopReviewList", id);
	}

	@Override
	public int checkFollow(Map<String, Object> map) {
		return session.selectOne("member.checkFollow", map);
	}

	@Override
	public int insertReport(Map<String, Object> map) {
		return session.insert("member.insertReport", map);
	}

	@Override
	public int selectReportUser(Map<String, Object> map) {
		return session.selectOne("member.selectReportUser", map);
	}

	@Override
	public Map<String, Object> selectRestrictionData(String id) {
		return session.selectOne("member.selectRestrictionData", id);
	}

	@Override
	public int appealMyDistriction(String id) {
		return session.update("member.appealMyDistriction", id);
	}
	
	

//	@Override
//	public int checkRefuse(Map<String, Object> map) {
//		return session.selectOne("member.checkRefuse", map);
//	}

 
//	@Override
//	public int updateAccountPrivate(Map<String, Object> map) {
//		return session.update("member.updateAccountPrivate",map);
//	}

	 
 
 
	

 


 
	
	
}
