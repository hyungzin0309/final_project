package com.kh.hana.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.hana.member.model.dao.MemberDao;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Follower;
import com.kh.hana.member.model.vo.FollowingRequest;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.dao.ShopDao;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Shop;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional(rollbackFor=Exception.class) // 익셉션 발생시 롤백
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberDao memberDao;
	
	@Autowired
	private ShopDao shopDao;

	@Override
	public int memberEnroll(Member member) {
		int result = memberDao.memberEnroll(member);
		if(member.getAccountType() == 0) {
			result = memberDao.insertShopInfo(member.getId());
		}
		return result;
	}

	@Override
	public int updateMember(Member member, Member oldMember) {
		int result = memberDao.updateMember(member);
		log.info("result ={}", result);
		return result;		
	}

	@Override
	public int updateShopInfo(Shop shop) {
		try {
			return memberDao.updateShopInfo(shop);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			return 0;
		}
	}

	@Override
	public Shop selectOneShopInfo(String memberId) {
		return memberDao.selectOneShopInfo(memberId);
	}

	@Override
	public int addFollowing(Map<String, Object> map) {
		return memberDao.addFollowing(map);
	}

	@Override
	public int countFollowing(String id) {
		return memberDao.countFollowing(id);
	}

	@Override
	public Member selectOneMember(String id) {
		return memberDao.selectOneMember(id);
	}

	@Override
	public int countFollower(String id) {
		return memberDao.countFollower(id);
	}

	@Override
	public List<Follower> followerList(String friendId) {
		return memberDao.followerList(friendId);
	}

	@Override
	public List<Follower> followingList(String friendId) {
		return memberDao.followingList(friendId);
	}
	
	@Override
	public List<Map<String, Object>> followingListById(Map<String, Object> map) {
		return memberDao.followingListById(map);
	}

	@Override
	public int insertMemberBoard(Board board) {
		return memberDao.insertMemberBoard(board);
	}

	@Override
	public int updateMemberProfile(Member member) {
		return memberDao.updateMemberProfile(member);
	}
	
	public int updatePassword(Member updateMember) {
		return memberDao.updatePassword(updateMember);
	}

	@Override
	public Board selectOneBoard(int no) {
		return memberDao.selectOneBoard(no);
	}

	@Override
	public List<Board> selectBoardList(String id) {
		return memberDao.selectBoardList(id);
	}

	@Override
	public int enrollBoardComment(BoardComment boardComment) {
		return memberDao.enrollBoardComment(boardComment);
	}

	@Override
	public int deleteBoard(int no) {
		return memberDao.deleteBoard(no);
	}

	@Override
	public List<BoardComment> selectBoardCommentList(int boardNo) {
		return memberDao.selectBoardCommentList(boardNo);
	}

	@Override
	public int deleteBoardComment(int no) {
		return memberDao.deleteBoardComment(no);
	}

	@Override
	public int updateBoardContent(Map<String, Object> param) {
		return memberDao.updateBoardContent(param);
	}

	@Override
	public int insertLikeLog(Map<String, Object> param) {
		return memberDao.insertLikeLog(param);
	}

	@Override
	public Map<String, Object> selectOneLikeLog(Map<String, Object> param) {
		return memberDao.selectOneLikeLog(param);
	}

	@Override
	public int deleteLikeLog(Map<String, Object> param) {
		return memberDao.deleteLikeLog(param);
	}

	@Override
	public int selectLikeCount(Map<String, Object> param) {
		return memberDao.selectLikeCount(param);
	}

	@Override
	public int checkAccountPrivate(Map<String, Object> map) {
		int publicProfile = (int)map.get("publicProfile"); 
		Member member = (Member)map.get("member");
		log.info("publicProfile={}",publicProfile);
		int result = 0;
		//	 if (member.getPublicProfile() == 2) {
		 	  result = memberDao.checkAccountPrivate(map);
		//  }else {
		//	  result = memberDao.updateAccountPrivate(map);			
	//	  }
		
		return result;
	 
	}

	@Override
	public int checkFriend(Map<String, Object> map) {
		return memberDao.checkFriend(map);
	}

	@Override
	public int requestFollowing(Map<String, Object> map) {
		return memberDao.requestFollowing(map);
	}

	@Override
	public int followingRequest(Map<String, Object> map) {
		return memberDao.followingRequest(map);
	}

	@Override
	public List<FollowingRequest> requestFollowingList(String myId) {
		log.info("Service.myIddddddddddd={}", myId);
		return memberDao.requestFollowingList(myId);
	}

	@Override
	public int applyFollowing(Map<String, Object> map) {
		return memberDao.applyFollowing(map);
	}

	@Override
	public int addRequestFollowing(Map<String, Object> map) {
		return memberDao.addRequestFollowing(map);
	}

	@Override
	public int refuseFollowing(Map<String, Object> map) {
		return memberDao.refuseFollowing(map);
	}

	@Override
	public int insertReview(Map<String, Object> map) {
		Board board = (Board) map.get("board");
		String reservationNo = (String) map.get("reservationNo");
		log.info("reservationNo = {}", reservationNo);
		
		// board table에 review insert		
		int result = memberDao.insertReview(board);
		log.info("reviewInsert result = {}", result);
		int boardNo = board.getNo();
		log.info("return boardNo = {}", boardNo);
		
		// board review table insert
		map.put("boardNo", boardNo);
		int reviewInsert = shopDao.insertBoardReview(map);
		log.info("board_review table insert result = {}", reviewInsert);
		
		// shop_table_reservaton_share 상태 변경
		String attendUser = board.getWriter();
		map.put("attendUser", attendUser);
		int reviewStatusUpdateResult = shopDao.updateReviewStatus(map);
		log.info("reviewStatus update result = {}", reviewStatusUpdateResult);
		
		if(result > 0 && reviewInsert > 0 && reviewStatusUpdateResult > 0) {
			return 1;
		} else {
			return 0;			
		}
	}	

	public int isRequestFriend(Map<String, Object> map) {
		return memberDao.isRequestFriend(map);
	}

	@Override
	public List<Board> selectShopReviewList(String id) {
		return memberDao.selectShopReviewList(id);
	}

	@Override
	public int checkFollow(Map<String, Object> map) {
		return memberDao.checkFollow(map);
	}

	@Override
	public int insertReport(Map<String, Object> map) {
		// 제제 전 신고내역에 신고한 유저 포함 여부 확인
		int checkReport = memberDao.selectReportUser(map);
		// 신고내역이 없는 경우에만 신고되도록 처리
		if(checkReport == 0) {
			return memberDao.insertReport(map);
		} else {
			return 0;
		}
	}

	@Override
	public Map<String, Object> selectRestrictionData(String id) {
		return memberDao.selectRestrictionData(id);
	}

	@Override
	public int appealMyDistriction(String id) {
		return memberDao.appealMyDistriction(id);
	}

//	@Override
//	public int checkRefuse(Map<String, Object> map) {
//		return memberDao.checkRefuse(map);
//	}

 
 

 
	
}
              

