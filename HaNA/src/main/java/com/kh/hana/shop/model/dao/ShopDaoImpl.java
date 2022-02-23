package com.kh.hana.shop.model.dao;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.HashTag;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Table;
@Repository
public class ShopDaoImpl implements ShopDao {
	
    @Autowired
    public SqlSession session;
    
    @Override
    public List<Map<String, Object>> selectShopList(Map<String, Object> data) {
    		return session.selectList("shop.selectShopList", data);
    }
    
    @Override
	public HashTag searchHashTag(HashTag hashTag) {
		return session.selectOne("shop.searchHashTag", hashTag);
	}
    
	@Override
	public List<HashTag> selectShopHashTag(String memberId) {
		return session.selectList("shop.selectShopHashTag", memberId);
	}

	@Override
	public HashTag searchShopHashTag(HashTag hashTag) {
		return session.selectOne("shop.searchShopHashTag", hashTag);
	}

	@Override
	public int insertHashTag(HashTag hashTag) {
		return session.insert("shop.insertHashTag", hashTag);
	}

	@Override
    public int insertShopHashTag(HashTag hashTag) {
        return session.insert("shop.insertShopHashTag", hashTag);
    }
    
    @Override public List<HashTag> hashTagAutocomplete(String search) { 
        return session.selectList("shop.selectHashTagList", search); 
    }

	@Override
	public String verifyTableName(Table table) {
		return session.selectOne("shop.verifyTableName", table);
	}

	@Override
	public int insertShopTable(Table table) {
		return session.insert("shop.insertShopTable", table);
	}

	@Override
	public List<Table> selectShopTableList(String id) {
		return session.selectList("shop.selectShopTableList", id);
	}

	@Override
	public int deleteShopTable(String tableId) {
		return session.delete("shop.deleteShopTable", tableId);
	}

	@Override
	public int updateShopTable(Table table) {
		return session.update("shop.updateShopTable", table);
	}

	@Override
	public Table selectOneTable(Table table) {
		return session.selectOne("shop.selectOneTable", table);
	}

	@Override
	public List<Map<String, Object>> selectHashTagShopList(Map<String, Object> data) {
		return session.selectList("shop.selectHashTagShopList",data);
	}
	
	@Override
	public int insertReservation(Reservation reservation) {
		return session.insert("shop.insertReservation", reservation);
	}

	@Override
	public List<Reservation> selectTableReservation(Map<String, Object> infoMap) {
		return session.selectList("shop.selectTableReservation", infoMap);
	}

	@Override
	public int shopReservationCount(String shopId) {
		return session.selectOne("shop.shopReservationCount", shopId);
	}

	@Override
	public List<Reservation> selectShopReservationListByDate(Map<String, Object> map) {
		return session.selectList("shop.selectShopReservationListByDate", map);
	}

	@Override
	public Map<String, Object> selecetMyReservationList(Map<String, Object> map) {
		int offset = (int) map.get("offset");
		int limit = (int) map.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		Map<String, Object> result = new HashMap<>();
		List<Reservation> rowBoundsReservation = session.selectList("shop.selectMyReservationList", map, rowBounds);
		List<Reservation> totalReservation = session.selectList("shop.selectMyReservationList", map);
		int totalBoard = totalReservation.size();
		result.put("rowBoundsReservation", rowBoundsReservation);
		result.put("totalBoard", totalBoard);
		return result;
	}

	@Override
	public int cancleReservation(String reservationNo) {
		return session.update("shop.cancleReservation", reservationNo);
	}

	@Override
	public int selectRankingData(Map<String, Object> rankingMap) {
		return session.update("shop.selectRankingData",rankingMap);
	}

	@Override
	public Reservation selectOneReservation(String reservationNo) {
		return session.selectOne("shop.selectOneReservation", reservationNo);
	}

	@Override
	public int insertReservationShare(Reservation reservation) {
		return session.insert("shop.insertReservationShare", reservation);
	}

	@Override
	public Reservation checkShareAccepted(Map<String, String> map) {
		return session.selectOne("shop.checkShareAccepted", map);
	}

	@Override
	public List<Member> selectAcceptedFriends(String reservationNo) {
		return session.selectList("shop.selectAcceptedFriends", reservationNo);
	}

	@Override
	public List<String> selectTodayRankingdatas() {
		return session.selectList("shop.selectTodayRankingdatas");
	}

	@Override
	public List<String> selectThisMonthRankingdatas() {
		return session.selectList("shop.selectThisMonthRankingdatas");
	}

	@Override
	public List<String> selectThisWeekRankingdatas() {
		return session.selectList("shop.selectThisWeekRankingdatas");
	}


	public List<Table> selectTablePrice(String id) {
		return session.selectList("shop.selectTablePrice", id);
	}


	@Override
	public int updateTablePrice(Table table) {
		return session.update("shop.updateTablePrice", table);
	}

	@Override
	public int selectOneTablePrice(String reservationTableId) {
		return session.selectOne("shop.selectOneTablePrice", reservationTableId);
	}

	@Override
	public int insertReservationPrice(Map<String, Object> map) {
		return session.insert("shop.insertReservationPrice", map);
	}

	@Override
	public int updateReqDutchpay(Map<String, Object> map) {
		return session.update("shop.updateReqDutchpay", map);
	}

	@Override
	public List<Map<String, Object>> selectPriceAndVisitors(String reservationNo) {
		return session.selectList("shop.selectPriceAndVisitors", reservationNo);
	}
	
	@Override
	public Map<String, Object> selectPriceAndMember(Map<String, Object> map) {
		return session.selectOne("shop.selectPriceAndMember", map);
	}

	@Override
	public int insertPurchaseHistory(Map<String, Object> reqMap) {
		return session.insert("shop.insertPurchaseHistory", reqMap);
	}

	@Override
	public int updateRestPrice(Map<String, Object> reqMap) {
		return session.update("shop.updateRestPrice", reqMap);
	}

	@Override
	public List<String> selectHashTagClickShopList(String tagName) {
		return session.selectList("shop.selectHashTagClickShopList", tagName);
	}
	
	@Override
	public int insertBoardReview(Map<String, Object> map) {
		return session.insert("shop.insertBoardReview", map);
	}

	@Override
	public int updateReviewStatus(Map<String, Object> map) {
		return session.update("shop.updateReviewStatus", map);
	}

	@Override
	public List<Map<String, Object>> selectShopGrade(String shopId) {
		return session.selectList("shop.selectShopGrade", shopId);
	}

	@Override
	public List<Map<String, Object>> selectShopReservationUserList(String shopId) {
		return session.selectList("shop.selectShopReservationUserList", shopId);
	}

	@Override
	public int selectShopReservationDawnList(String shopId) {
		return session.selectOne("shop.selectShopReservationDawnList", shopId);
	}

	@Override
	public int selectShopReservationDayList(String shopId) {
		return session.selectOne("shop.selectShopReservationDayList", shopId);
	}

	@Override
	public int selectShopReservationNightList(String shopId) {
		return session.selectOne("shop.selectShopReservationNightList", shopId);
	}

	@Override
	public List<Map<String, Object>> selectShopReservationTableList(String shopId) {
		return session.selectList("shop.selectShopReservationTableList", shopId);
	}

	@Override
	public List<Map<String, Object>> selectShopReservationVisitorList(String shopId) {
		return session.selectList("shop.selectShopReservationVisitorList", shopId);
	}

	@Override
	public List<Map<String, Object>> selectRankShopAvg() {
		return session.selectList("shop.selectRankShopAvg", null);
	}

	@Override
	public List<Map<String, Object>> selectRankShopReview() {
		return session.selectList("shop.selectRankShopReview", null);
	}

	@Override
	public List<Map<String, Object>> selectRankShopRes() {
		return session.selectList("shop.selectRankShopRes", null);
	}



	

}