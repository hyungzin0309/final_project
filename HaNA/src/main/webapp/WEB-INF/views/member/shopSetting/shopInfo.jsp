<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="업체정보 수정" name="title"/>
</jsp:include>

<sec:authentication property="principal" var="loginMember"/>

<c:if test="${not empty msg}">
	<script>
		$(() => {
			alert('${msg}');
		});
	</script>
</c:if>

<h1>shop프로필설정</h1>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationPriceSetting'">요금 관리</li>
			</ul>
        </div>
        <!-- 설정 영역 -->
        <div class="col-sm-8">
        	<form:form action="${pageContext.request.contextPath }/member/shopSetting/shopInfo" method="post" name="updateFrm">  
        		<label for="shopName">매장명</label>
        		<br />
        		<input type="text" name="shopName" id="" value="${shop.shopName }"/> 
        		<br /> 	
	        	<label for="bussiness-hour-start">영업시간</label>
	        	<br />
	        	<input type="time" name="bussinessHourStart" value="${shop.bussinessHourStart }" step="1800"/>~<input type="time" name="bussinessHourEnd" value="${shop.bussinessHourEnd }" step="1800"/>        	
	        	<br />
	        	<br />
	        	<label for="introduce">매장소개</label>
	        	<br />
	        	<input type="text" name="shopIntroduce" value="${shop.shopIntroduce }"/>
	        	<br />
	        	<br />
	        	<label for="address">주소</label>
	        	<br />
	        	<input type="text" name="address" style="width:300px;" value="${shop.address }"/>
	        	<input type="button" value="검색" onclick="execDaumPostcode();" />
	        	<br />
	        	<label for="addressDetail">상세주소</label>
	        	<br />
	        	<input type="text" name="addressDetail" value="${shop.addressDetail }" required/>
	        	<input type="hidden" name="locationX" value="${shop.locationX }"/>
	        	<input type="hidden" name="locationY" value="${shop.locationY }"/>
	        	<input type="hidden" name="id" value="${loginMember.id }"/>
	        	<br />
	        	<br />
	        	<input type="submit" value="저장하기" id="formBtn"/>
        	</form:form>
        	
        </div>
    </div>
</div>
<script>
	$("#formBtn").click((e) =>{
		e.preventDefault();
		$('[name=updateFrm]').submit();
	})
	
</script>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a77e005ce8027e5f3a8ae1b650cc6e09&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            
            if(data.roadAddress == null){
            	alert("유효하지 않은 도로명 주소입니다. 다시 선택해주세요");
            }
            
            $("[name=address]").val(data.roadAddress);    
            
            /* kakao */
            var geocoder = new kakao.maps.services.Geocoder();

            var callback = function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    console.log(result[0].x);
                    console.log(result[0].y);
                    $('[name=locationX]').val(result[0].x);
                    $('[name=locationY]').val(result[0].y);
                }
            };

            geocoder.addressSearch(data.roadAddress, callback);
     
           	close();
        }
    }).open();
}
</script>



<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>