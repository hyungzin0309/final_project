<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="AroundME" name="title" />
</jsp:include>
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/shop/shopMain.css" />

<!-- autocomplete 라이브러리 -->
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<section class="body-section">
	<sec:authentication property="principal" var="loginMember" />

	<div class="container mb-4">
		<div class="row hashTagRank">
			<table class="table table-striped table-dark my-0">
				<thead>
					<tr>
						<th colspan="5" class="bg-white text-dark" id="hashTagRankTitle"><img class="shopCrownImg"src="${pageContext.request.contextPath }/resources/images/icons/crownblack.png"/>
						HashTag Ranking<img class="shopCrownImg" src="${pageContext.request.contextPath }/resources/images/icons/crownblack.png"/></th>
					</tr>
					<tr id="rankingTrColor">
						<th scope="col" id ="thNo">no</th>  
						<th scope="col" id="thNo2">일간</th>  
						<th scope="col" id="thNo3">주간</th>  
						<th scope="col" id="thNo4">월간</th>	
					</tr>
				</thead>
				<tbody>
					 <tr>
						<th scope="row" class="rankingThColor" id ="rankingThColor_1">1</th>
						<td id="toDayFirstRanking" class="tagClick" onClick="hashTagClick()">Mark ★</td>
						<td id="weekFirstRanking" class="tagClick" onClick="hashTagClick()" >@mdo ★</td>
						<td id="monthFirstRanking" class="tagClick" onClick="hashTagClick()">Otto ★</td>
					</tr> 
					 <tr>
						<th scope="row" class="rankingThColor" id ="rankingThColor_2">2</th>
						<td id="toDaySecondRanking" class="tagClick" onClick="hashTagClick()">Jacob</td>
						<td id="weekSecondRanking" class="tagClick" onClick="hashTagClick()">@fat</td>
						<td id="monthSecondRanking" class="tagClick" onClick="hashTagClick()">Thornton</td>
					</tr> 
					<tr>
						<th scope="row" class="rankingThColor" id ="rankingThColor_3">3</th>
						 <td id="toDayThirdTagRanking" class="tagClick" onClick="hashTagClick()">Larry</td>
						<td id="weekThirdRanking" class="tagClick" onClick="hashTagClick()">@test!!</td>
						<td id="monthThirdRanking" class="tagClick" onClick="hashTagClick()">the Bird</td>
					</tr>
					<tr>
						<th scope="row" class="rankingThColor" id ="rankingThColor_4">4</th>
						<td id="toDayFourthTagRanking" class="tagClick" onClick="hashTagClick()">Larry</td>
						<td id="weekFourthRanking" class="tagClick" onClick="hashTagClick()">@twitter</td>
						<td id="monthFourthRanking" class="tagClick" onClick="hashTagClick()">the Bird</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<!-- 거리 설정 영역 -->
		<div class="row searchArea my-0">		
			<div class="radioStyle">
				<input type="radio" name="maxDistance" id="dis1" value="8"checked/>
				<label for="dis1"  class="lableStyle">8km</label>
				<input type="radio" name="maxDistance" id="dis2" value="4"/>
				<label for="dis2" class="lableStyle">4km</label>
				<input type="radio" name="maxDistance" id="dis3" value="2" />
				<label for="dis3" class="lableStyle" >2km</label>
			</div>
		</div>
		<!-- 검색 영역 -->
		<div class="row searchArea my-0">
			<nav class="navbar navbar-light bg-light justify-content-end">
				<span class="navbar-brand mb-0 h1" id="searchTitle"><img class = "shopSearchImg" src="${pageContext.request.contextPath }/resources/images/icons/search.png"/></span>
				<form class="form-inline d-flex">
					<input class="form-control mr-sm-2" type="search"
						placeholder="# 해시태그를 검색하세요." aria-label="Search" id="searchInput">
				</form>
			</nav>
		</div>

		<div class="row searchResultArea my-0">
			<div class="hashTagResult" id="hashTagResult">
				<!-- HashTag 검색 후 클릭/엔터 시 동적으로 버튼 생길 공간  -->
			</div>
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit"
				id="searchBtn" onclick="clickList();">Search</button>
		</div>


		<!-- 매장 랭킹 영역 -->
		<div class="row shopRank bg-dark text-white">
			<div 	
				class="col-md-4 d-flex justify-content-center align-items-center flex-column">
				<span class="d-flex align-items-start"><img class="shopRankingImg"src="${pageContext.request.contextPath }/resources/images/icons/free-icon-crown-1804177.png" />
				</span><span class="mb-4">"평점 1위"</span>
				<div class="shopProfile d-flex">
					<!-- 프로필사진 영역 -->
					<a href="#"> <img class="shopProfileImg"
						src="${pageContext.request.contextPath }/resources/upload/member/profile/${rankingList.avgShop.picture}"
						alt="" />
					</a>
				</div>
				<span class="rankingTop3"><img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>${rankingList.avgShop.shop }</span>
				<span class="rankingTop3"><img class="shopRankingNumberImg" src="${pageContext.request.contextPath }/resources/images/icons/premium-icon-thumbs-up-2415237.png"/>${rankingList.avgShop.avg }</span>
			</div>
			<div
				class="col-md-4 d-flex justify-content-center align-items-center flex-column">
				<span class="d-flex align-items-start"><img  class="shopRankingImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-crown-1804177.png"/>
				</span><span class="mb-4">"리뷰수 1위"</span>
				<div class="shopProfile d-flex">
					<!-- 프로필사진 영역 -->
					<img class="shopProfileImg"
						src="${pageContext.request.contextPath }/resources/upload/member/profile/${rankingList.revShop.picture}"
						alt="" />
				</div>
				<span class="rankingTop3"><img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>${rankingList.revShop.id }</span>
				<span class="rankingTop3"><img class="shopRankingNumberImg" src="${pageContext.request.contextPath }/resources/images/icons/premium-icon-thumbs-up-2415237.png"/>${rankingList.revShop.count }</span>
			</div>
			<div
				class="col-md-4 d-flex justify-content-center align-items-center flex-column">
				<span class="d-flex align-items-start"><img class="shopRankingImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-crown-1804177.png"/>
				</span><span class="mb-4" >"예약수 1위"</span>
				<div class="shopProfile d-flex">
					<!-- 프로필사진 영역 -->
					<img class="shopProfileImg"
						src="${pageContext.request.contextPath }/resources/upload/member/profile/${rankingList.resShop.picture}"
						alt="" />
				</div>
				<span class="rankingTop3"><img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>${rankingList.resShop.id }</span>
				<span class="rankingTop3"><img class="shopRankingNumberImg" src="${pageContext.request.contextPath }/resources/images/icons/premium-icon-thumbs-up-2415237.png"/>${rankingList.resShop.count }</span>
			</div>
		</div>
		<div class="row shopList bg-secondary text-white" id="shopList" style="background-color: #e9ecef !important;">
			<!-- 
       <div class="col-md-4 d-flex justify-content-center align-items-center flex-column">
        	<div class="shopProfile d-flex">
	             프로필 사진 영역   	
	        	<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/images/duck.png" alt=""/>
       		</div>
       		<span class = "shopScroll">매장ID</span>
        </div>
       -->
		</div>

		<!-- pageBar -->
		<div>pageNation</div>
	</div>

<script type="text/javascript"src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ik4yiy9sdi&submodules=geocoder"></script>

<script>



var loading = false;
var page = 1;
var endNum = 6;
var startNum = 0;
var selectDataArr = []; //hashTag 담을 배열
var hashTagData = ""; // 검색 데이터 잠시 담을 변수 


function scrollPage(){	
	
		//  페이지 들어 왔을때 (태그 선택 후 검색 버튼을 클릭 하지 않았을 경우) 스크롤을 하면 거리기반 매장만 뜨게 
		if(chkClick == false) {
			 selectDataArr.length = 0; // 태그 데이터 삭제 
			 $("#hashTagResult").empty(); // 버튼 내역 삭제 
		} 
		
		// km 라디오 박스 선택 후 태그 검색을 할때 데이터가 두번(해시태그 검색 + 스크롤page) 나오지 않도록 삭제 
		if(kmChange = true){
			startNum = 0;
			$("#shopList").empty();
			kmChange = false;
		}

		var Addr_val = "${loginMember.addressAll}";
	
		// 도로명 주소를 좌표 값으로 변환(API)
		naver.maps.Service.geocode({
	        query: Addr_val
	    }, function(status, response) {
	        if (status !== naver.maps.Service.Status.OK) {
	            return alert('잘못된 주소값입니다.');
	        }

	        var result = response.v2, // 검색 결과의 컨테이너
	            items = result.addresses; // 검색 결과의 배열
	            
	        // 리턴 받은 좌표 값을 변수에 저장
	        let x = parseFloat(items[0].x);
	        let y = parseFloat(items[0].y);

	    	$.ajax({
				url: `${pageContext.request.contextPath}/shop/shopList`,
				data: {
						id : "${loginMember.id}",
						locationX : x,
						locationY : y,
						maxDistance : $("[name=maxDistance]:checked").val(),
						selectDataArr : selectDataArr
				},
				success(res){	
					var  list = res;
					const max = list.length;
					console.log("list" , list);	
					// list.TAG_NAME 값 비교가 안되서 어차피 tag_name은 있거나 없거나 이니까 변수로 옮겨서 null 체크 
				 	var  tagName = 0;				 	
					for(var i =0; i<list.length; i++){
						 tagName = list[i].hashTags.length;
					}
					 
					
				if(tagName == 0){ // 해시태그 없을때
					if(startNum == 0 ){
							  for(var i=0; i<endNum; i++){
								var htmlOut='';
								htmlOut += '<div class="col-md-4 d-flex justify-content-center align-items-center flex-column" id ="divCheck" onclick="location.href=\'http://localhost:9090/hana/member/shopView/'+ list[i].id +'\'">';
								htmlOut += '<div class="shopProfile d-flex">';
							    htmlOut += '<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/upload/member/profile/'+ list[i].picture +'"/>';
							    htmlOut += '</div>';
								htmlOut += '<span class = "shopScroll">'+'<img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>'+ list[i].shopName + '</span>';
								htmlOut += '<span class = "shopScroll">'+'<img class="shopAddresseImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-pin-6832990.png"/>'+ list[i].address + '</span>';
							    for(var j = 0; j < list[i].hashTags.length; j++){
							    	if(j == 0){
							    		 htmlOut += '<span class = "shopScroll">'+'<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];	
							    	} else if(j == list[i].hashTags.length - 1){
							    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j] + '</span>';
							    	} else {
							    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];
							    	}
							    };
								$('#shopList').append(htmlOut);
								// list[i].ID가 마지막이라면 return
								if(i == max -1){
									return;
							}
							
						}  
					}else{ 
						 	for(var i=startNum; i<endNum; i++){  
									var htmlOut='';
									htmlOut += '<div class="col-md-4 d-flex justify-content-center align-items-center flex-column" id ="divCheck" onclick="location.href=\'http://localhost:9090/hana/member/shopView/'+ list[i].id +'\'">';
									htmlOut += '<div class="shopProfile d-flex">';
									htmlOut += '<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/upload/member/profile/'+ list[i].picture +'"/>';
								    htmlOut += '</div>';
								    htmlOut += '<span class = "shopScroll">'+'<img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>'+ list[i].shopName + '</span>';
								    htmlOut += '<span class = "shopScroll">'+'<img class="shopAddresseImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-pin-6832990.png"/>'+ list[i].address + '</span>';
								    for(var j = 0; j < list[i].hashTags.length; j++){
								    	if(j == 0){
								    		 htmlOut +='<span class = "shopScroll">'+'<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];	
								    	} else if(j == list[i].hashTags.length - 1){
								    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j] + '</span>';
								    	} else {
								    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];
								    	}
								    };
									$('#shopList').append(htmlOut);
									// list[i].ID가 마지막이라면 return
									if(i == max -1){
										return;
								}
								
						 	}
						}
				}else if (tagName != 0){ // 해시태그 있을때	
					/* $("#shopList").empty(); */ //검색과 스크롤 동시에 작동 될때 연속으로 나와서 요소 삭제 해줌 
					if(startNum == 0 || startNum == 12 ){ // 리스트 스크롤 후 해시태그 검색시 startNum이 12 이여서 
							  for(var i=0; i<list.length; i++){
								var htmlOut='';
								htmlOut += '<div class="col-md-4 d-flex justify-content-center align-items-center flex-column" id ="divCheck" onclick="location.href=\'http://localhost:9090/hana/member/shopView/'+ list[i].id +'\'">';
								htmlOut += '<div class="shopProfile d-flex">';
							    htmlOut += '<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/upload/member/profile/'+ list[i].picture +'"/>';
							    htmlOut += '</div>';
							    htmlOut += '<span class = "shopScroll">'+'<img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>'+ list[i].shopName + '</span>';
							    htmlOut += '<span class = "shopScroll">'+'<img class="shopAddresseImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-pin-6832990.png"/>'+ list[i].address + '</span>';
							    for(var j = 0; j < list[i].hashTags.length; j++){
							    	if(j == 0){
							    		 htmlOut +='<span class = "shopScroll">'+'<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];	
							    	} else if(j == list[i].hashTags.length - 1){
							    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j] + '</span>';
							    	} else {
							    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];
							    	}
							    };	

								$('#shopList').append(htmlOut); 
								$("#hashTagResult").empty(); // 해시 태그 클릭 후 검색 안하고 스크롤 시 해시태그 버튼 내역 삭제 
								// list[i].ID가 마지막이라면 return 이부분은 데이터가 많아지면 지워도 되는 부분
								if(i == max -1){
									return;
								}
							}  
					}else{ 
						 	for(var i=startNum; i<list.length; i++){  
									var htmlOut='';
									htmlOut += '<div class="col-md-4 d-flex justify-content-center align-items-center flex-column" id ="divCheck" onclick="location.href=\'http://localhost:9090/hana/member/shopView/'+ list[i].id +'\'">';
									htmlOut += '<div class="shopProfile d-flex">';	
									htmlOut += '<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/upload/member/profile/'+ list[i].picture +'"/>';
								    htmlOut += '</div>';
								    htmlOut += '<span class = "shopScroll">'+'<img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>'+ list[i].shopName + '</span>';
								    htmlOut += '<span class = "shopScroll">'+'<img class="shopAddresseImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-pin-6832990.png"/>'+ list[i].address + '</span>';
								    for(var j = 0; j < list[i].hashTags.length; j++){
								    	if(j == 0){
								    		 htmlOut +='<span class = "shopScroll">'+'<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];	
								    	} else if(j == list[i].hashTags.length - 1){
								    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png" />'+ list[i].hashTags[j] + '</span>';
								    	} else {
								    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];
								    	}
								    };	
									$('#shopList').append(htmlOut);
									$("#hashTagResult").empty(); // 해시 태그 클릭 후 검색 안하고 스크롤 시 해시태그 버튼 내역 삭제
									// list[i].ID가 마지막이라면 return
									if(i == max -1){ 
										return;
								}
						 	}
						}
					}
				page++;
				endNum -= 1; //  6-1 = 5 
				startNum = (endNum +1) ;  // 6 12
				endNum += 7; //12 18

				loading = false;
				if(list.length === 0){	
					loading = true;
				}
				},
				error:console.log			
			});
	    });
};
	// scroll 위치지정 및 ajax실행
	$(window).scroll(function(){
		if($(window).scrollTop() + 10 >= $(document).height() - $(window).height()){
			if(!loading){
				loading = true;
				scrollPage();
			}
		}
		
	});

	
 // Autocomplete  부분 
    $("#searchInput").autocomplete({
        source : function(request, response) {	
            $.ajax({
                  url : "${pageContext.request.contextPath}/shop/hashTagAutocomplete",
                 data : {search : $("#searchInput").val()},
                 success : function(data){ 
                    		console.log(data)	
                    response(
                        $.map(data, function(item) {
                            return {
                                  label : item.tagName  //목록에 표시되는 값 
                            };
                        })
                    );  	
                },
                error : function(){ //실패
						console.log("실패")
                }
            });
        	}
        , minLength : 1  // 조회를 위한 최소 글자수  
        , autoFocus : true // 첫번째 항목 자동 포커스(기본값 : false) 
        , select: function( event, ui) {  //  리스트에서 태크 선택 하였을때 선택한 데이터에 의한 이벤트발생
        	
        	// 검색을 했을때는 기존에 남아 있는 selectDataArr 에 데이터들을 삭제 
        	  if(chkClick == true) {
        		 selectDataArr.length = 0;
					 chkClick = false;
        	} 

        	// 검색 데이터 변수에 담기  
        	hashTagData  = ui.item.value;
        	console.log("변수 " +  hashTagData)

        	// 검색 데이터를 클릭/엔터 하면 버튼이 동적으로 생성  
			var hashTagBtn = document.createElement( 'button' );
        	var tagData = document.createTextNode(hashTagData);     	
		    document.getElementById('hashTagResult').appendChild(hashTagBtn);
		    // button style
		    hashTagBtn.style = 'background-color: #ecb61f;border-radius:13px;border: 2px solid #f8fbff;color: #f9fafb;font-size:16px;padding:5px 10px;font-weight:bold;margin: 4px;';
		    hashTagBtn.appendChild( tagData );
		    console.log( tagData.nodeValue) // 텍스트 노드의 값을 가져오는 API .nodeValue
        }
        , focus : function(evt, ui) { //  한글 오류 방지
            return false;
        }
        , close : function(evt){
        	// input에 있는 text  사라지게
        	$("#searchInput").val('');
        	selectDataArr.push(hashTagData);
        	
        	
        }
        
    }).autocomplete('instance')._renderItem = function(ul, item) {
		return $('<li>')
        .append('<div>' + item.label + '</div>') 
        .appendTo(ul);   
		
    };
    
    
 //  엔터시 submit 막기  
 document.addEventListener('keydown', function(event) {
  if (event.keyCode === 13) {
    event.preventDefault();
  };
});
  

// 해시 태그 선택 후 검색 버튼 클릭시 
var chkClick = false;
var kmChange = false;


function clickList(){
	chkClick = true;
	startNum = 0;
	$("#shopList").empty();
	scrollPage();
	// 태그 버튼 내역 삭제 
	$("#hashTagResult").empty();

$("[name=maxDistance]").change((e) => {
	kmChange = true;
	console.log($("[name=maxDistance]:checked").val());
	scrollPage();
});
	
	
	// 날짜 
	var today = new Date();   
	var year = today.getFullYear(); // 년도
	var month = today.getMonth() + 1;  // 월
	var date = today.getDate();  // 날짜
	var tagDate = year + '-' + month  + '-' + date;
	
	// 검색 버튼 클릭시 태그 , 해당 날짜 DB 저장
 	$.ajax({
		url : "${pageContext.request.contextPath}/shop/insertRankingData",
		data : {
			id : "${loginMember.id}",
			selectDataArr : selectDataArr,
			tagDate : tagDate
		},
		success(data) {
			console.log(data)
		},
		error: console.log
		
	}); 

}

// 페이지 로딩시 랭킹 불러오기  오늘, 월간, 주간

$(()=>{

     // 오늘 데이터 구하기 
      $.ajax({
 		url : "${pageContext.request.contextPath}/shop/selectTodayRankingdatas",
 		success(data) {

 			console.log(data)	
			var toDay = []; 
 			toDay = data; 
 			console.log(toDay)
 			
 			 $('#toDayFirstRanking').text('# '+toDay[0].TAG_NAME);
 			 $('#toDaySecondRanking').text('# '+toDay[1].TAG_NAME);
 			 $('#toDayThirdTagRanking').text('# '+toDay[2].TAG_NAME);
 			 $('#toDayFourthTagRanking').text('# '+toDay[3].TAG_NAME);
 		},
		error: console.log
 		
 	});
     
     // 이번주 데이터 구하기 
     $.ajax({
 		url : "${pageContext.request.contextPath}/shop/selectThisWeekRankingdatas",
 		success(data) {
 			console.log(data)	
 	 		var week = [];
 			week = data; 
 			console.log(week)
 		
 			 $('#weekFirstRanking').text('# '+week[0].TAG_NAME);
			 $('#weekSecondRanking').text('# '+week[1].TAG_NAME);
			 $('#weekThirdRanking').text('# '+week[2].TAG_NAME);
			 $('#weekFourthRanking').text('# '+week[3].TAG_NAME);
 		},
 		error: console.log
 		
 	}); 
     
      // 이번달 데이터 구하기 
     $.ajax({
 		url : "${pageContext.request.contextPath}/shop/selectThisMonthRankingdatas",
 		success(data) {
 			
 			console.log(data)
 			var month = [];// 이번달
 			month = data; 
 			console.log(month)
 			
 			 $('#monthFirstRanking').text('# '+month[0].TAG_NAME);
			 $('#monthSecondRanking').text('# '+month[1].TAG_NAME);
			 $('#monthThirdRanking').text('# '+month[2].TAG_NAME);
			 $('#monthFourthRanking').text('# '+month[3].TAG_NAME);
 			
 		},
 		error: console.log
 		
 	});  
}); 

// 랭킹 태그 클릭시 
$(".tagClick").click(function(){

	$("#shopList").empty();
	
	
	// td 안에 값 가져와서 #는 잘라줌  
	var tr = $(this);
	var td = tr.children();
	var name = tr.text();

	console.log("클릭한 Row의 모든 데이터 : "+name);
	tagName = name.substring(2);
	console.log("문자열자르기  : "+ tagName);

	  $.ajax({
	 		url : "${pageContext.request.contextPath}/shop/selectHashTagClickShopList",
	 		data: {
	 			tagName : tagName
			},
	 		success(data) {
	 			console.log(data)
	 			var  list = data;
	 			console.log(list)
	 			   for(var i=0; i<list.length; i++){
						var htmlOut='';
						htmlOut += '<div class="col-md-4 d-flex justify-content-center align-items-center flex-column" id ="divCheck" onclick="location.href=\'http://localhost:9090/hana/member/shopView/'+ list[i].id +'\'">';
						htmlOut += '<div class="shopProfile d-flex">';	
						htmlOut += '<img class="shopProfileImg" src="${pageContext.request.contextPath }/resources/upload/member/profile/'+ list[i].picture +'"/>';
					    htmlOut += '</div>';
					    htmlOut += '<span class = "shopScroll">'+'<img class="shopNameImg" src="${pageContext.request.contextPath }/resources/images/icons/home.png"/>'+ list[i].shopName + '</span>';
					    htmlOut += '<span class = "shopScroll">'+'<img class="shopAddresseImg" src="${pageContext.request.contextPath }/resources/images/icons/free-icon-pin-6832990.png"/>'+ list[i].address + '</span>';
					    for(var j = 0; j < list[i].hashTags.length; j++){
					    	if(j == 0){
					    		 htmlOut +='<span class = "shopScroll">'+'<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];	
					    	} else if(j == list[i].hashTags.length - 1){
					    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j] + '</span>';
					    	} else {
					    		htmlOut +='<img class="shopHashTagImg" src="${pageContext.request.contextPath }/resources/images/icons/hastag1.png"/>'+ list[i].hashTags[j];
					    	}
					    };
						$('#shopList').append(htmlOut);
	 			   }
	 		},
	 		error: console.log
	 		
	 	});

});

</script>

</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>