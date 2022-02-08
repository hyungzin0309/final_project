package com.kh.hana.shop.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.HashTag;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Table;

public interface ShopDao {

	List<Map<String, Object>> selectShopList(Map<String, Object> data);

	int insertShopHashTag(HashTag hashTag);

	 List<HashTag> hashTagAutocomplete(String search);

	int insertShopTable(Table table);

	String verifyTableName(Table table);

	List<Table> selectShopTableList(String id);

	int deleteShopTable(String tableId);

	int updateShopTable(Table table);

	Table selectOneTable(Table table);

	List<Map<String, Object>> selectHashTagShopList(Map<String, Object> data);

	int insertReservation(Reservation reservation);

	List<Reservation> selectTableReservation(Map<String, Object> infoMap);

	HashTag searchHashTag(HashTag hashTag);

	int insertHashTag(HashTag hashTag);

	HashTag searchShopHashTag(HashTag hashTag);

	List<HashTag> selectShopHashTag(String memberId);

	int shopReservationCount(String shopId);

	List<Reservation> selectShopReservationListByDate(Map<String, Object> map);

	Map<String, Object> selecetMyReservationList(Map<String, Object> map);

	int cancleReservation(String reservationNo);
	
	int selectRankingData(Map<String, Object> rankingMap);

	Reservation selectOneReservation(String reservationNo);

	int insertReservationShare(Reservation reservation);

	Reservation checkShareAccepted(Map<String, String> map);

	List<Member> selectAcceptedFriends(String reservationNo);

	List<Map<String, String>> selectTodayRankingdatas(String tagDate);



	
	

}
