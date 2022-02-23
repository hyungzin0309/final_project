package com.kh.hana.shop.controller;
import java.beans.PropertyEditor;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.common.util.CreateCalendar;
import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.service.ShopService;
import com.kh.hana.shop.model.vo.HashTag;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Table;

import lombok.extern.slf4j.Slf4j;
@Controller
@Slf4j
@RequestMapping("/shop")
public class ShopController {
    @Autowired
    private ShopService shopService;
    
    @GetMapping("/shopMain")
    public void shopMain(Model model) {
    	// 매장 랭킹 구해오기
    	Map<String, Object> rankingList = shopService.selectShopRank();
    	log.info("rankingList = {}", rankingList);
    	
    	model.addAttribute("rankingList", rankingList);
    }
    
    @GetMapping("/shopList")
    public ResponseEntity<?> selectShopList(@RequestParam(value="selectDataArr[]",required=false) List<String> selectDataArr , @RequestParam String id, @RequestParam String locationX, @RequestParam String locationY, @RequestParam int maxDistance) {
    	log.info("github testd");
        Map<String, Object> data = new HashMap<>();
        data.put("id", id);
        data.put("locationX", locationX);
        data.put("locationY", locationY);
        
//      8.23km내 -> 11km 범위 내로 추려오기
        double maxX = Double.parseDouble(locationX) + 0.0927;
        double maxY = Double.parseDouble(locationY) + 0.074;
        
        String maxLocationX = Double.toString(maxX);
        String maxLocationY = Double.toString(maxY);
        
        data.put("maxLocationX", maxLocationX);
        data.put("maxLocationY", maxLocationY);
        
        log.info("data = {}", data);
   
        List<Map<String, Object>> shopList = shopService.selectShopList(data,selectDataArr, maxDistance);
        log.info("length = {}", shopList.size());
        log.info("shopList = {}", shopList);
        
        return ResponseEntity.ok(shopList);
    }
    
    @PostMapping("/insertHashTag")
    public String insertHashTag(HashTag hashTag, RedirectAttributes redirectAttr) {
        log.info("hashTag = {}", hashTag);
        hashTag.setTagId("shop-hashtag-");
        
        int result = shopService.insertHashTag(hashTag);
        log.info("hashTag Result = {}", result);
        
        String msg = "";
        if(result > 0) {
        	msg = "등록에 성공했습니다.";
        } else {
        	msg = "이미 등록된 해시태그 입니다.";
        }
        
        redirectAttr.addFlashAttribute("msg", msg);
        
        return "redirect:/member/shopSetting/hashtag";
    }
    
    @GetMapping("/selectShopHashTag")
    public ResponseEntity<?> selectShopHashTag(@RequestParam String memberId){
    	log.info("memberId = {}", memberId);
    	
    	List<HashTag> shopHashTagList = shopService.selectShopHashTag(memberId);
    	log.info("shopHashTag List = {}", shopHashTagList);
    	
    	return ResponseEntity.ok(shopHashTagList);
    }
    
    @GetMapping("/hashTagAutocomplete")
    public ResponseEntity<?> hashTagAutocomplete( String search) {
        log.info("search = {}", search);
        List<HashTag> tagList = shopService.hashTagAutocomplete(search);
        log.info("tagList = {}", tagList);
        
        return ResponseEntity.ok(tagList);
    }
    
    @GetMapping("/insertRankingData") 
    public ResponseEntity<?> insertRankingData(@RequestParam(value="selectDataArr[]") List<String> selectDataArr , @RequestParam String tagDate , @RequestParam String id) {
        log.info("selectDataArr = {}", selectDataArr);
        log.info("tagDate = {}", tagDate);
       
        int result = 0;
        Map<String, Object> rankingMap = new HashMap<>();
        	rankingMap.put("tagDate", tagDate);
        	rankingMap.put("id", id);

		for(String data : selectDataArr) {		
			rankingMap.put("tags", data);
			result = shopService.insertRankingData(rankingMap);	
			
			log.info("data = {}", data);
			log.info("result = {}", result);	
		}
        return ResponseEntity.ok(result);
    }

    @PostMapping("/insertShopTable")
    public ResponseEntity<?> insertShopTable(@RequestBody Table table){
    	log.info("table = {}", table);
    	
    	int result = shopService.insertShopTable(table);
    	log.info("insertTable result = {}", result);
    	
    	String msg = "";
    	if(result == 1) {
    		msg = "등록되었습니다.";
    	} else {
    		msg = "중복된 테이블명 입니다. 테이블명을 수정해주세요";
    	}
    	Map<String, Object> msgMap = new HashMap<>();
    	msgMap.put("msg", msg);
    	
    	return ResponseEntity.ok(msgMap);
    }
    
    @GetMapping("/loadShopTable")
    public ResponseEntity<?> selectShopTableList(@RequestParam String id){
    	log.info("loadShopTable id = {}", id);
    	
    	List<Table> tableList = shopService.selectShopTableList(id);
    	
    	return ResponseEntity.ok(tableList);
    }
    
    @DeleteMapping(value="/deleteShopTable", produces="application/text;charset=utf8")
    @ResponseBody
    public ResponseEntity<?> deleteShopTable(@RequestBody Table table){
    	String tableId = table.getTableId();
    	
    	int result = shopService.deleteShopTable(tableId);
    	 
    	return ResponseEntity.ok(result);
    }
    
    @PutMapping(value="/updateShopTable", produces="application/text;charset=utf8")
    @ResponseBody
    public ResponseEntity<?> updateShopTable(@RequestBody Table table){
    	log.info("updateTable = {}", table);
    	
    	int result = shopService.updateTable(table);
    	log.info("updateResult = {}", result);
    	 
    	return ResponseEntity.ok().build();
    }
    
    @GetMapping("/selectOneTable/getReservationTime")
    public ResponseEntity<?> getReservationTime(Table reqTable, @RequestParam Date date){    	
    	Table table = shopService.selectOneTable(reqTable);
    	
    	Map<String, Object> infoMap = new HashMap<>();
    	infoMap.put("date", date);
    	infoMap.put("tableId", reqTable.getTableId());
    	
    	List<Reservation> reservation = shopService.selectTableReservation(infoMap);
    	
    	List<Map<String, Object>> timeMapList = new ArrayList<>();
    	
    	String startTime = table.getAllowStart();
    	int timeDiv = table.getTimeDiv();
    	String endTime = table.getAllowEnd();
    	
    	SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    	
    	Date psStartTime = new Date();
    	Date psEndTime = new Date();
    	try {
			psStartTime = sdf.parse(startTime);
			psEndTime = sdf.parse(endTime);
			
			while(true) {
				Date eachStartTime = psStartTime;  
				Calendar cal = Calendar.getInstance();
				cal.setTime(psStartTime);
				cal.add(Calendar.MINUTE, timeDiv);
				psStartTime = cal.getTime();
				if(psStartTime.after(psEndTime)) {
					cal.add(Calendar.MINUTE, -timeDiv);
					psStartTime = cal.getTime();
					break;
				}
		    	Map<String, Object> timeMap = new HashMap<>();
				timeMap.put("startTime", sdf.format(eachStartTime));
				timeMap.put("endTime", sdf.format(psStartTime));
		    	for(Reservation res : reservation) {
		    		if(res.getTimeStart().equals(sdf.format(eachStartTime))) {
		    			timeMap.put("status", res.getReservationStatus());
		    		}
		    	}
		    	
				timeMapList.add(timeMap);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	
    	log.info("timeList = {}", timeMapList);
    	
    	
    	return ResponseEntity.ok(timeMapList);
    }
    
    @PostMapping(value="/reservation/insert", produces="application/text;charset=utf8")
    @ResponseBody
    public ResponseEntity<?> insertReservation(@RequestBody Reservation reservation){
    	
    	log.info("insertReservation REs = {}", reservation);
    	
    	int result = shopService.insertReservation(reservation);
    	
    	String msg = result > 0 ? "등록되었습니다." : "예약 실패, 다시 시도해주세요";
    	
    	return ResponseEntity.ok(msg);
    }
    
    @GetMapping("/createCalendar")
    @ResponseBody
    public ResponseEntity<?> createCalendar(@RequestParam int year, @RequestParam int month){    	
    	Map<String, Object> map = CreateCalendar.createCalendar(year, month);
    	
    	return ResponseEntity.ok(map);
    }
    
    @GetMapping("/shopReservationCount")
    public ResponseEntity<?> shopReservationCount(@RequestParam String shopId){
    	int count = shopService.shopReservationCount(shopId);
    	return ResponseEntity.ok(count);
    }
    
    @GetMapping("/selectShopReservationListByDate")
    public ResponseEntity<?> selectShopReservationListByDate(@RequestParam String date, @RequestParam String id){    	
    	Map<String, Object> map = new HashMap<>();
    	map.put("date", date);
    	map.put("shopId", id);
    	
    	List<Reservation> reservationList = shopService.selectShopReservationListByDate(map);
    	log.info("reservationList by Date = {}", reservationList);
    	
    	return ResponseEntity.ok(reservationList);
    }
    
    @GetMapping("/myReservation")
    public ResponseEntity<?> selectMyReservation(@RequestParam int state, @RequestParam(defaultValue="1") int cPage, @AuthenticationPrincipal Member member){
    	int limit = 10;
    	int offset = (cPage -1) * limit;
    	
    	Map<String, Object> map = new HashMap<>();
    	map.put("state", state);
    	map.put("id", member.getId());
    	map.put("limit", limit);
    	map.put("offset", offset);
    	
    	 
    	Map<String, Object> myList = shopService.selectMyReservationList(map);
    	int totalBoardCount = (int) myList.get("totalBoard");
    	log.info("myList = {}", myList);
    	
    	String func = "";
    	if(state == 1) {
    		func = "myPresentReservation";
    	} else {
    		func = "myPastReservation";
    	}
    	
    	String pageBar = HanaUtils.getPagebarAjax(cPage, 10, totalBoardCount, func);
    	
    	Map<String, Object> result = new HashMap<>();
    	result.put("myList", myList.get("rowBoundsReservation"));
    	result.put("pageBar", pageBar);
    	
    	return ResponseEntity.ok(result);
    }
    
    @PutMapping(value="/cancleReservation")
    public ResponseEntity<?> cancleReservation(@RequestBody String reservationNo) {
    	
    	log.info("resNo = {}", reservationNo);
    	
    	int result = shopService.cancleReservation(reservationNo);
    	
    	return ResponseEntity.ok(result);
    }
    
    @GetMapping("/selectOneReservation")
    public ResponseEntity<?> selectOneReservation(@RequestParam String reservationNo, @RequestParam String id){    	
    	Reservation reservation = shopService.selectOneReservation(reservationNo);
    	log.info("reservation = {}", reservation);
    	
    	Map<String, String> map = new HashMap<>();
    	map.put("reservationNo", reservationNo);
    	map.put("id", id);
    	Reservation checkRes = shopService.checkShareAccepted(map);
    	log.info("check result = {}", checkRes);
    	
    	Map<String, Object> returnMap = new HashMap<>();
    	returnMap.put("reservation", reservation);
    	returnMap.put("checkRes", checkRes);
    	
    	return ResponseEntity.ok(returnMap);
    }
    
    @PostMapping("/insertReservationShare")
    public ResponseEntity<?> insertReservationShare(Reservation reservation){
    	log.info("reservation = {}", reservation);
    	
    	int result = shopService.insertReservationShare(reservation);
    	
    	return ResponseEntity.ok(result);
    }
    
    @GetMapping("/selectAcceptedFriends")
    public ResponseEntity<?> selectAcceptedFriends(@RequestParam String reservationNo){
    	List<Member> memberList = shopService.selectAcceptedFriends(reservationNo);
    	
    	return ResponseEntity.ok(memberList);
    }
    
    @GetMapping("/selectTablePrice")
    public ResponseEntity<?> selectTablePrice(@RequestParam String memberId){
    	log.info("id = {}", memberId);
    	
    	List<Table> list = shopService.selectTablePrice(memberId);
    	log.info("list = {}", list);
    	
    	return ResponseEntity.ok(list);
    }
    
    @PostMapping("/updateTablePrice")
    public ResponseEntity<?> updateTablePrice(Table table){
    	int result = shopService.updateTablePrice(table);
    	
    	return ResponseEntity.ok(result);
    }
    
    @PostMapping("/updateReqDutchpay")
    public ResponseEntity<?> updateReqDutchpay(@RequestParam String reservationNo, @RequestParam String status){
    	Map<String, Object> map = new HashMap<>();
    	map.put("reservationNo", reservationNo);
    	map.put("status", status);
    	
    	int result = shopService.updateReqDutchpay(map);
    	log.info("updateResult = {}", result);
    	
    	return ResponseEntity.ok(result);
    }
    
    @GetMapping("/selectPriceAndVisitors")
    public ResponseEntity<?> selectPriceAndVisitors(@RequestParam String reservationNo){
    	List<Map<String, Object>> list = shopService.selectPriceAndVisitors(reservationNo);
    	log.info("list = {}", list);
    	
    	return ResponseEntity.ok(list);
	}
    
    @GetMapping("/selectPriceAndMember")
    public ResponseEntity<?> selectPriceAndMember(@RequestParam String reservationNo, @RequestParam String id){
    	Map<String, Object> map = new HashMap<>();
    	map.put("reservationNo", reservationNo);
    	map.put("id", id);
    	Map<String, Object> resultMap = shopService.selectPriceAndMember(map);
    	log.info("resultMap = {}", resultMap);
    	
    	return ResponseEntity.ok(resultMap);
	}
    
    @PostMapping("/insertPurchaseHistory")
    public ResponseEntity<?> insertPurchaseHistory(@RequestBody Map<String, Object> reqMap){
    	log.info("reqMap = {}", reqMap);
    	
    	int result = shopService.insertPurchaseHistory(reqMap);
    	
    	return ResponseEntity.ok(result);
    }
    
    @PostMapping("/purchaseAsDutchpay")
    public ResponseEntity<?> purchaseAsDutchpay(@RequestBody Map<String, Object> reqMap){
    	
    	int result = shopService.purchaseAsDutchpay(reqMap);
    	
    	return ResponseEntity.ok(result);
    }
    
    @PostMapping("/purchaseAll")
    public ResponseEntity<?> purchaseAll(@RequestBody Map<String, Object> reqMap){
    	
    	int result = shopService.purchaseAll(reqMap);
    	
    	return ResponseEntity.ok(result);
    }
    
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	PropertyEditor editor = new CustomDateEditor(sdf, true);
    	binder.registerCustomEditor(Date.class, editor);
    }
    
    @GetMapping("/selectTodayRankingdatas")
    public ResponseEntity<?> selectTodayRankingdatas(){
    	List<String> rankingTodayDatas  = shopService.selectTodayRankingdatas();
    	return ResponseEntity.ok(rankingTodayDatas);
    }
    
    @GetMapping("/selectThisMonthRankingdatas")
    public ResponseEntity<?> selectThisMonthRankingdatas(){
    	List<String> rankingMonthDatas  = shopService.selectThisMonthRankingdatas();
    	return ResponseEntity.ok(rankingMonthDatas);
    }
    
    @GetMapping("/selectThisWeekRankingdatas")
    public ResponseEntity<?> selectThisWeekRankingdatas(){
    	List<String> rankingWeekDatas  = shopService.selectThisWeekRankingdatas();
    	return ResponseEntity.ok(rankingWeekDatas);
    }
    

    @GetMapping("/selectHashTagClickShopList")
    public ResponseEntity<?> selectHashTagClickShopList(@RequestParam String tagName){
    	log.info("tagName = {}", tagName);
    	List<String> HashTagClickShopList = new ArrayList<>();
    	 HashTagClickShopList  = shopService.selectHashTagClickShopList(tagName);
    	log.info("tagName = {}", HashTagClickShopList);
    	return ResponseEntity.ok(HashTagClickShopList);
    }
    
    
    @GetMapping("/getShopGrade")
    public ResponseEntity<?> selectShopGrade(@RequestParam String shopId){
    	log.info("shopId = {}", shopId);
    	
    	List<Map<String, Object>> reviewList = shopService.selectShopGrade(shopId);
    	log.info("reviewList = {}", reviewList);
    	
    	// 리뷰 개수 구하기
    	int reviewCount = reviewList.size();
    	
    	// 평점 평균 구하기
    	int totalGrade = 0;
    	for(Map<String, Object> list : reviewList) {
    		int grade = Integer.parseInt(String.valueOf(list.get("GRADE")));
    		totalGrade += grade;
    	}
    	
    	double average = (double) Math.round((double) totalGrade / (double) reviewCount * 10) / 10;
    	
    	Map<String, Object> returnMap = new HashMap<>();
    	returnMap.put("reviewCount", reviewCount);
    	returnMap.put("average", average);
    	
    	
    	return ResponseEntity.ok(returnMap);
    }
    
    @GetMapping("/reservationStatistics")
    public String reservationStatistics(@AuthenticationPrincipal Member member, Model model) {   	
    	// 통계 구해서 오기
    	Map<String, Object> map = shopService.reservationStatistics(member);
    	
    	// 연령대별 예약인원 수    	
    	Map<String, Object> ageGroup =  ageGroupStatistics((List) map.get("userList"));
    	log.info("ageGroup = {}", ageGroup);
    	model.addAttribute("ageGroup", ageGroup);
    	
    	// 전체 예약인원 수
    	int visitorAll = Integer.parseInt(String.valueOf(map.get("visitorAll")));
    	model.addAttribute("visitorAll", visitorAll);
    	
    	// 시간대별 예약 수
    	Map<String, Integer> timeMap = (Map) map.get("timeMap");
    	model.addAttribute("timeMap", timeMap);
    	
    	// 테이블별 예약 리스트
    	List<Map<String, Object>> tableList = (List) map.get("tableList");
    	model.addAttribute("tableList", tableList);
    	
    	// 방문 회원 리스트
    	List<Map<String, Object>> visitorList = (List) map.get("visitorList");
    	model.addAttribute("visitorList", visitorList);
    	
    	// 방문 회원 업체와의 거리
    	List<Double> visitorDistanceList = (List) map.get("visitorDistance");
    	log.info("visitorDistanceLIst = {}", visitorDistanceList);
    	Map<String, Object> visitorDistance = visitorDistanceStatistics(visitorDistanceList);
    	log.info("visitorDistance = {}", visitorDistance);
    	model.addAttribute("visitorDistance", visitorDistance);
    	
    	return "forward:/member/shopSetting/reservationStatistics";
    }
    
    // 방문자 거리 통계 구하기
    public Map<String, Object> visitorDistanceStatistics(List<Double> list){
    	Map<String, Object> returnMap = new HashMap<>();
    	
    	int innerFive = 0;
    	int innerTen = 0;
    	int innerTwenty = 0;
    	int outterTwenty = 0;
    	
    	for(double dis : list) {
    		if(dis <= (double) 5) {
    			innerFive++;
    		}
    		if(dis > (double) 5 && dis <= (double) 10) {
    			innerTen++;
    		}
    		if(dis > (double) 10 && dis <= (double) 20) {
    			innerTwenty++;
    		}
    		if(dis > (double) 20) {
    			outterTwenty++;
    		}
    	}
    	returnMap.put("innerFive", innerFive);
    	returnMap.put("innerTen", innerTen);
    	returnMap.put("innerTwenty", innerTwenty);
    	returnMap.put("outterTwenty", outterTwenty);
    	
    	return returnMap;
    }
    
    // 연령대 통계 구하기    
    public Map<String, Object> ageGroupStatistics(List<Map<String, Object>> list){
    	Map<String, Object> returnMap = new HashMap<>();
    	
    	// 10대
    	int groupOneMale = 0;
    	int groupOneFemale = 0;
    	// 20대
    	int groupTwoMale = 0;
    	int groupTwoFemale = 0;
    	// 30대
    	int groupThrMale = 0;
    	int groupThrFemale = 0;
    	// 40대
    	int groupFouMale = 0;
    	int groupFouFemale = 0;
    	// 50대
    	int groupFivMale = 0;
    	int groupFivFemale = 0;
    	// 60대 이상
    	int groupSixMale = 0;
    	int groupSixFemale = 0;
    	
    	for(Map<String, Object> user : list) {
    		int age = Integer.parseInt(String.valueOf(user.get("age")));
    		String gender = String.valueOf(user.get("gender"));
    		if(0< age && age < 20) {
    			if(gender.equals("남")) {
    				groupOneMale++;
    			} else {
    				groupOneFemale++;
    			}
    		} else if(19 < age && age < 30) {
    			if(gender.equals("남")) {
    				groupTwoMale++;
    			} else {
    				groupTwoFemale++;
    			}
    		} else if(29 < age && age < 40){
    			if(gender.equals("남")) {
    				groupThrMale++;
    			} else {
    				groupThrFemale++;
    			}
    		} else if(39 < age && age < 50) {
    			if(gender.equals("남")) {
    				groupFouMale++;
    			} else {
    				groupFouFemale++;
    			}
    		} else if(49 < age && age < 60) {
    			if(gender.equals("남")) {
    				groupFivMale++;
    			} else {
    				groupFivFemale++;
    			}
    		} else if(59 < age) {
    			if(gender.equals("남")) {
    				groupSixMale++;
    			} else {
    				groupSixFemale++;
    			}
    		}
    	};
    	
    	returnMap.put("groupOneMale", groupOneMale);
    	returnMap.put("groupOneFemale", groupOneFemale);
    	returnMap.put("groupTwoMale", groupTwoMale);
    	returnMap.put("groupTwoFemale", groupTwoFemale);
    	returnMap.put("groupThrMale", groupThrMale);
    	returnMap.put("groupThrFemale", groupThrFemale);
    	returnMap.put("groupFouMale", groupFouMale);
    	returnMap.put("groupFouFemale", groupFouFemale);
    	returnMap.put("groupFivMale", groupFivMale);
    	returnMap.put("groupFivFemale", groupFivFemale);
    	returnMap.put("groupSixMale", groupSixMale);
    	returnMap.put("groupSixFemale", groupSixFemale);
    	
    	log.info("oneMale = {}", groupOneMale);
    	log.info("oneFeMale = {}", groupOneFemale);
    	
    	return returnMap;
    }
    
    @GetMapping("/getPrice")
    public ResponseEntity<?> getPrice(@RequestParam String reservationNo){
    	
    	Map<String, Object> ogPrice = shopService.getPrice(reservationNo);
    	log.info("ogPrice = {}", ogPrice);
    	
    	return ResponseEntity.ok(ogPrice);
    }

}