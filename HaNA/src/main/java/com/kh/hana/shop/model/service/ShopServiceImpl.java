package com.kh.hana.shop.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.hana.common.util.CalculateArea;
import com.kh.hana.common.util.CalculateArea2;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.dao.ShopDao;
import com.kh.hana.shop.model.vo.HashTag;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Table;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ShopServiceImpl implements ShopService {

	@Autowired
	private ShopDao shopDao;

	@Override
	public List<Map<String, Object>> selectShopList(Map<String, Object> data,List<String> selectDataArr, int limit) {
		List<Map<String, Object>> shopList = new ArrayList<Map<String, Object>>();
		
		// 해시태그가 없을때 
		if(selectDataArr == null) {
			 shopList = shopDao.selectShopList(data);			
			log.info("해시태그가 없는 = {}", shopList);
		}else {
			// 해시태그가 있을때 
			List<String> tags = new ArrayList<>();
			for(String str : selectDataArr) {
				tags.add(str);
				data.put("tags", tags);				
			}
			 shopList = shopDao.selectHashTagShopList(data);			
			 log.info("해시태그가 있 = {}", shopList);
		}
		String locationX = (String)data.get("locationX");
		String locationY = (String)data.get("locationY");
		
		List<Map<String, Object>> lastShopList = new ArrayList<>();
		for(Map<String, Object> shop : shopList) {
			String x = (String) shop.get("locationX");
			String y = (String) shop.get("locationY");
			log.info("serv shop = {}", shop);
			boolean bool = CalculateArea.calculateArea(locationX, locationY, x, y, limit);
			log.info("calTest = {}", bool);
			
			if(bool == true) {
				lastShopList.add(shop);
			}
		}
		return lastShopList;
	}

	@Override
	public int insertHashTag(HashTag hashTag) {
		HashTag tag = shopDao.searchHashTag(hashTag);
		
		int result = 0;
		if(tag == null) {
			result = shopDao.insertHashTag(hashTag);
			if(result > 0) {
				result = shopDao.insertShopHashTag(hashTag);
			}
		} else {
			hashTag.setTagId(tag.getTagId());
			HashTag shopHashTag = shopDao.searchShopHashTag(hashTag);
			if(shopHashTag == null) {
				result = shopDao.insertShopHashTag(hashTag);				
			}
		}
		return result;
	}

	@Override
	public List<HashTag> selectShopHashTag(String memberId) {
		return shopDao.selectShopHashTag(memberId);
	}

	@Override public List<HashTag> hashTagAutocomplete(String search) { 
		  return shopDao.hashTagAutocomplete(search); 
	}
	
	@Override
	public int insertRankingData(Map<String, Object> rankingMap) {
	//	int count = 1;
	//	rankingMap.put("count", count);
		int selectData = shopDao.selectRankingData(rankingMap);
		log.info("selectData = {}" ,selectData );
		return selectData;
	}

	@Override
	public int insertShopTable(Table table) {
		String verifyName = shopDao.verifyTableName(table);
		log.info("verify? = {}", verifyName == null);
		int result = 0;
		if(verifyName == null) {
			result = shopDao.insertShopTable(table);			
			return result;
		} else {
			return result;
		}
	}

	@Override
	public List<Table> selectShopTableList(String id) {
		return shopDao.selectShopTableList(id);
	}

	@Override
	public int deleteShopTable(String tableId) {
		return shopDao.deleteShopTable(tableId);
	}

	@Override
	public int updateTable(Table table) {
		return shopDao.updateShopTable(table);
	}

	@Override
	public Table selectOneTable(Table table) {
		return shopDao.selectOneTable(table);
	}

	@Override
	public int insertReservation(Reservation reservation) {
		int result = shopDao.insertReservation(reservation);
		log.info("reservation = {}", reservation);
		
		if(result > 0) {
			String tableId = reservation.getReservationTableId();
			int originalPrice = shopDao.selectOneTablePrice(tableId);
			log.info("originalPrice = {}", originalPrice);
			Map<String, Object> map = new HashMap<>();
			map.put("originalPrice", originalPrice);
			map.put("reservationNo", reservation.getReservationNo());
			result = shopDao.insertReservationPrice(map);
		};
		
		return result;
	}

	@Override
	public List<Reservation> selectTableReservation(Map<String, Object> infoMap) {
		return shopDao.selectTableReservation(infoMap);
	}

	@Override
	public int shopReservationCount(String shopId) {
		return shopDao.shopReservationCount(shopId);
	}

	@Override
	public List<Reservation> selectShopReservationListByDate(Map<String, Object> map) {
		return shopDao.selectShopReservationListByDate(map);
	}

	@Override
	public Map<String, Object> selectMyReservationList(Map<String, Object> map) {
		return shopDao.selecetMyReservationList(map);
	}

	@Override
	public int cancleReservation(String reservationNo) {
		return shopDao.cancleReservation(reservationNo);
	}

	@Override
	public Reservation selectOneReservation(String reservationNo) {
		return shopDao.selectOneReservation(reservationNo);
	}

	@Override
	public int insertReservationShare(Reservation reservation) {
		return shopDao.insertReservationShare(reservation);
	}

	@Override
	public Reservation checkShareAccepted(Map<String, String> map) {
		return shopDao.checkShareAccepted(map);
	}

	@Override
	public List<Member> selectAcceptedFriends(String reservationNo) {
		return shopDao.selectAcceptedFriends(reservationNo);
	}

	@Override
	public List<String> selectTodayRankingdatas() {
		return shopDao.selectTodayRankingdatas();
	}

	@Override
	public List<String> selectThisMonthRankingdatas() {
		return shopDao.selectThisMonthRankingdatas();
	}

	@Override
	public List<String> selectThisWeekRankingdatas() {
		return shopDao.selectThisWeekRankingdatas();
	}


	public List<Table> selectTablePrice(String id) {
		return shopDao.selectTablePrice(id);
	}

	@Override
	public int updateTablePrice(Table table) {
		return shopDao.updateTablePrice(table);
	}

	@Override
	public int updateReqDutchpay(Map<String, Object> map) {
		return shopDao.updateReqDutchpay(map);
	}

	@Override
	public List<Map<String, Object>> selectPriceAndVisitors(String reservationNo) {
		return shopDao.selectPriceAndVisitors(reservationNo);
	}

	
	@Override
	public Map<String, Object> selectPriceAndMember(Map<String, Object> map) {
		return shopDao.selectPriceAndMember(map);
	}

	@Override
	public int insertPurchaseHistory(Map<String, Object> reqMap) {
		return shopDao.insertPurchaseHistory(reqMap);
	}

	@Override
	public int purchaseAsDutchpay(Map<String, Object> reqMap) {
		reqMap.put("status", "S");
		int result = shopDao.updateReqDutchpay(reqMap);
		result = shopDao.updateRestPrice(reqMap);
		
		return result;
	}

	@Override
	public int purchaseAll(Map<String, Object> reqMap) {
		return shopDao.updateRestPrice(reqMap);
	}

	@Override
	public List<String> selectHashTagClickShopList(String tagName) {
		return shopDao.selectHashTagClickShopList(tagName);
	}
	
	@Override
	public List<Map<String, Object>> selectShopGrade(String shopId) {
		return shopDao.selectShopGrade(shopId);

	}

	@Override
	public Map<String, Object> reservationStatistics(Member member) {
		String shopId = member.getId();
		
		// 연령 및 성별 통계 구해오기
		List<Map<String, Object>> userList = shopDao.selectShopReservationUserList(shopId);
		log.info("userList = {}", userList);
		
		// 전체 예약 인원
		int visitorAll = userList.size();
		
		// 시간대별 예약 불러오기
		// 새벽
		int dawnList = shopDao.selectShopReservationDawnList(shopId);
		// 주간
		int dayList = shopDao.selectShopReservationDayList(shopId);
		// 야간
		int nightList = shopDao.selectShopReservationNightList(shopId);
		Map<String, Integer> timeMap = new HashMap<>();
		timeMap.put("dawnList", dawnList);
		timeMap.put("dayList", dayList);
		timeMap.put("nightList", nightList);
		
		// 테이블별 예약 수 불러오기
		List<Map<String, Object>> tableList = shopDao.selectShopReservationTableList(shopId);
		
		// 방문자 리스트 불러오기
		List<Map<String, Object>> visitorList = shopDao.selectShopReservationVisitorList(shopId);
		
		// 방문자와 업체의 거리 구해서 보내기
		String stdLocationX = member.getLocationX();
		String stdLocationY = member.getLocationY();
		
		List<Double> visitorDistance = new ArrayList<>();
		for(Map<String, Object> visitor : visitorList) {
			String locationX = (String) visitor.get("locationX");
			String locationY = (String) visitor.get("locationY");
			double distance = CalculateArea2.calculateArea(stdLocationX, stdLocationY, locationX, locationY);
			visitorDistance.add(distance);
		}
		
		// return할 data Map에 담아서 보내기
		Map<String, Object> returnMap = new HashMap<>();
		returnMap.put("userList", userList);
		returnMap.put("visitorAll", visitorAll);
		returnMap.put("timeMap", timeMap);
		returnMap.put("tableList", tableList);
		returnMap.put("visitorList", visitorList);
		returnMap.put("visitorDistance", visitorDistance);
		
		
		return returnMap;
	}

	@Override
	public Map<String, Object> getPrice(String reservationNo) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, Object>> list = shopDao.selectPriceAndVisitors(reservationNo);
		
		log.info("list = {}", list);
		log.info("list0 = {}", list.get(0));
		log.info("list0.ogp = {}", String.valueOf(list.get(0).get("ORIGINALPRICE")));
		int price = Integer.parseInt(String.valueOf(list.get(0).get("ORIGINALPRICE")));
		int visitors = list.size();
		
		map.put("price", price);
		map.put("visitors", visitors);
		
		return map;
	}

	@Override
	public Map<String, Object> selectShopRank() {
		Map<String, Object> returnMap = new HashMap<>();
		
		// 평점 1위 매장
		List<Map<String, Object>> avgShop = shopDao.selectRankShopAvg();
		returnMap.put("avgShop", avgShop.get(0));
		
		// 리뷰 수 1위 매장
		List<Map<String, Object>> revShop = shopDao.selectRankShopReview();
		returnMap.put("revShop", revShop.get(0));
		
		// 예약 수 1위 매장
		List<Map<String, Object>> resShop = shopDao.selectRankShopRes();
		returnMap.put("resShop", resShop.get(0));
		
		
		return returnMap;
	}

	





	

}
