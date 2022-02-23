<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reservationStatistics/reservationStatistics.css" />


<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="프로필 설정" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberSetting.css" />
<sec:authentication property="principal" var="loginMember"/>
<section>

<c:if test="${not empty msg}">
	<script>
		alert("${msg}");
	</script>
</c:if>

<br/><br/><br/><br/>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
        		<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationPriceSetting'">요금 관리</li>
				<li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/shop/reservationStatistics'">예약 통계</li>
			</ul>
        </div>
        
        <div class="col-sm-8">
		    <div class="row">   
		        <!-- 탭 영역 -->
		        <div class="col-sm-12 nav nav-pills nav-fill" id="tab" style="width:100%;">
					<!-- 예약 수 -->
					<div class="col-sm-2 nav-item d-flex justify-content-center align-items-center">
				    	<a class="nav-link statsTab active" href="#" id="timeStats">시간대별 예약</a>
				  	</div>
				  	
				  	<!-- 예약 수 -->
					<div class="col-sm-2 nav-item d-flex justify-content-center align-items-center">
				    	<a class="nav-link statsTab" href="#" id="tableStats">테이블 차트</a>
				  	</div>
				  	
				  	<!-- 방문자 평균 -->
					<div class="col-sm-2 nav-item d-flex justify-content-center align-items-center">
				    	<a class="nav-link statsTab" href="#" id="visitorStats">방문자 통계</a>
				  	</div>
				  	
				  	<!-- 방문 회원 랭킹 -->
				  	<div class="col-sm-2 nav-item d-flex justify-content-center align-items-center">
				    	<a class="nav-link statsTab" href="#" id="visitorRank">방문 회원 랭킹</a>
				  	</div>
				  	
				  	<!-- 방문 회원 리스트 -->
				  	<div class="col-sm-2 nav-item d-flex justify-content-center align-items-center">
				    	<a class="nav-link statsTab" href="#" id="visitorDistance">방문 거리 통계</a>
				  	</div>
				  	
		        </div>
   		    </div>
   		    <div class="row">
   		    	<!-- content 영역 -->
   		    	<div class="col-sm-12 d-flex justify-content-center align-items-center">
   		    		<!-- 예약 수 AREA -->
   		    		<div class="contentArea timeStats">
						<section>
							<div class="pieID pie">
							</div>
							<ul class="pieID legend">
							  <li>
							    <em>심야</em>
							    <span>${timeMap.dawnList }</span>
							  </li>
							  <li>
							    <em>주간</em>
							    <span>${timeMap.dayList }</span>
							  </li>
							  <li>
							    <em>야간</em>
							    <span>${timeMap.nightList}</span>
							  </li>
							</ul>
						</section>
					</div>
   		    	
			  		<!-- 방문자 평균 AREA -->
				  	<div class="contentArea visitorStats" style="display:none;">
						<h3>총 방문 인원은 ${visitorAll }명 입니다.</h3>
						<p>* 비공개 회원은 차트에 포함되지 않습니다.</p>
					  	<!-- google chart -->
				 		<div id="chart_div"></div>
					</div>
					
					<!-- 테이블 통계 AREA -->
					<div class="contentArea tableStats" style="display:none;">
					  	<!-- google chart -->
				 		<div id="chart_div2"></div>
					</div>
					
					<!-- 방문자 랭킹 AREA -->
					<div class="contentArea visitorRank" style="display:none">
						<h3>방문 회원 랭킹 입니다.</h3>
						<table id="visitorRankTable">
							<thead>
								<tr>
									<th>순위</th>
									<th>방문자 ID</th>
									<th>방문 횟수</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${visitorList }" var="visitor" varStatus="vs">
									<c:if test="${vs.count <= 10 }">
									<tr>
										<td>
											${vs.count }위
										</td>
										<td>${visitor.userId }</td>
										<td>${visitor.visitCount }</td>
									</tr>
									</c:if>
								</c:forEach>
							</tbody>
						</table>
					</div>
					
					<!-- 방문자 거리 AREA -->
					<div class="contentArea visitorDistance" style="display:none;">
						<h3>방문 회원의 거리 통계</h3>
						<!-- google chart -->
						<div id="chart_div3"></div>
					</div>
					<!-- cotent Area End -->
				</div>
			</div>
		</div>
	</div>		
</div>
<c:if test=""></c:if>

<br /><br /><br />
<script>
/*
	countStats
	tableStats
	visitorStats
	visitorDistance
	visitorRank
*/
$(".statsTab").click((e) => {
	let targetId = $(e.target).prop('id');
	$(".contentArea").hide();
	$(`.\${targetId}`).show();
	$(".statsTab").removeClass("active");
	$(e.target).addClass("active");
	drawStacked();
	drawStacked2();
	drawStacked3();
});

/* googleChart */
google.charts.load('current', {packages: ['corechart', 'bar']});
google.charts.setOnLoadCallback(drawStacked);
google.charts.setOnLoadCallback(drawStacked2);
google.charts.setOnLoadCallback(drawStacked3);
/*  1 : 방문자 평균 */
function drawStacked() {
      var data = google.visualization.arrayToDataTable([  
        ['연령대', '남', '여'],
        ['10대', ${ageGroup.groupOneMale}, ${ageGroup.groupOneFemale}],
        ['20대', ${ageGroup.groupTwoMale}, ${ageGroup.groupTwoFemale}],
        ['30대', ${ageGroup.groupThrMale}, ${ageGroup.groupThrFemale}],
        ['40대', ${ageGroup.groupFouMale}, ${ageGroup.groupFouFemale}],
        ['50대', ${ageGroup.groupFivMale}, ${ageGroup.groupFivFemale}],
        ['60대 이상', ${ageGroup.groupSixMale}, ${ageGroup.groupSixFemale}]
      ]);

      var options = {
        title: '연령대/성별 차트',
        chartArea: {width: '50%'},
        isStacked: true,
        hAxis: {
          title: 'Total Reservation',
          minValue: 0,
        },
        vAxis: {
          title: ''
        }
      };
      var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
      chart.draw(data, options);
}
/*  2 : 테이블 평균 */
function drawStacked2() {
      var data2 = google.visualization.arrayToDataTable([
   	  	['테이블', '예약 수'],
   		<c:forEach items="${tableList }" var="table" varStatus="vs">
    		['${table.tableName}', ${table.count}]
    		<c:if test="${not vs.last}">,</c:if>
   		</c:forEach>
      ]);

      var options = {
        title: '테이블 누적 예약 수',
        chartArea: {width: '50%'},
        isStacked: true,
        hAxis: {
          title: 'Table Reservation',
          minValue: 0,
        },
        vAxis: {
          title: ''
        }
      };
      var chart = new google.visualization.BarChart(document.getElementById('chart_div2'));
      chart.draw(data2, options);
}
/*  3 : 거리 평균 */
function drawStacked3() {
      var data3 = google.visualization.arrayToDataTable([
   	  	['거리', '방문자 수'],
   		['5km 이내', ${visitorDistance.innerFive}],
   		['10km 이내', ${visitorDistance.innerTen}],
   		['20km 이내', ${visitorDistance.innerTwenty}],
   		['20km 초과', ${visitorDistance.outterTwenty}]
      ]);

      var options = {
        title: '방문자 거리 통계',
        chartArea: {width: '50%'},
        isStacked: true,
        hAxis: {
          title: 'Distance Reservation',
          minValue: 0,
        },
        vAxis: {
          title: ''
        }
      };
      var chart = new google.visualization.BarChart(document.getElementById('chart_div3'));
      chart.draw(data3, options);
};


/* 1 graph script */
function sliceSize(dataNum, dataTotal) {
	  return (dataNum / dataTotal) * 360;
}

function addSlice(sliceSize, pieElement, offset, sliceID, color) {
  $(pieElement).append("<div class='slice "+sliceID+"'><span></span></div>");
  var offset = offset - 1;
  var sizeRotation = -179 + sliceSize;
  $("."+sliceID).css({
    "transform": "rotate("+offset+"deg) translate3d(0,0,0)"
  });
  $("."+sliceID+" span").css({
    "transform"       : "rotate("+sizeRotation+"deg) translate3d(0,0,0)",
    "background-color": color
  });
}
function iterateSlices(sliceSize, pieElement, offset, dataCount, sliceCount, color) {
  var sliceID = "s"+dataCount+"-"+sliceCount;
  var maxSize = 179;
  if(sliceSize<=maxSize) {
    addSlice(sliceSize, pieElement, offset, sliceID, color);
  } else {
    addSlice(maxSize, pieElement, offset, sliceID, color);
    iterateSlices(sliceSize-maxSize, pieElement, offset+maxSize, dataCount, sliceCount+1, color);
  }
}
function createPie(dataElement, pieElement) {
  var listData = [];
  $(dataElement+" span").each(function() {
    listData.push(Number($(this).html()));
  });
  var listTotal = 0;
  for(var i=0; i<listData.length; i++) {
    listTotal += listData[i];
  }
  var offset = 0;
  var color = [
    "cornflowerblue", 
    "olivedrab", 
    "orange", 
    "tomato", 
    "crimson", 
    "purple", 
    "turquoise", 
    "forestgreen", 
    "navy", 
    "gray"
  ];
  for(var i=0; i<listData.length; i++) {
    var size = sliceSize(listData[i], listTotal);
    iterateSlices(size, pieElement, offset, i, 0, color[i]);
    $(dataElement+" li:nth-child("+(i+1)+")").css("border-color", color[i]);
    offset += size;
  }
}
createPie(".pieID.legend", ".pieID.pie");
</script>


<%-- 
						원형그래프 원본
						<section>
						<div class="pieID pie">
						  
						</div>
						<ul class="pieID legend">
						  <li>
						    <em>Humans</em>
						    <span>718</span>
						  </li>
						  <li>
						    <em>Dogs</em>
						    <span>531</span>
						  </li>
						  <li>
						    <em>Cats</em>
						    <span>868</span>
						  </li>
						  <li>
						    <em>Slugs</em>
						    <span>344</span>
						  </li>
						  <li>
						    <em>Aliens</em>
						    <span>1145</span>
						  </li>
						</ul>
						</section> --%>





</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>