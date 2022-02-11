<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="설정화면" name="memberSetting/"/>
</jsp:include>
 
<section>
<sec:authentication property="principal" var="loginMember"/>

<c:if test="${not empty msg}">
	<script>
		$(() => {
			alert("${msg}");
		})
	</script>	
</c:if>



<br><br><br>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/memberSetting'">프로필 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/updatePassword'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/accountPrivate'">계정 공개</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/myReservationList'">내 예약내역</li>
			</ul>
        </div>
   
<div id="enroll-container" class="mx-auto text-center">
	<form:form name="memberUpdateFrm" action="${pageContext.request.contextPath}/member/memberUpdate?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data" method="POST">
		<table class="mx-auto">
		 <input type="hidden" name="id" value="${loginMember.id}" />
			<tr>
				<th class="title">이름</th>
				<td>
					<div id="memberId-container">
						<input type="text" class="form-control" name="name" id="name" value="${loginMember.name}" required >
					 				
					</div>
				</td>
			</tr>		
			<tr>
				<th class="title">소개</th>
				<td>
				<!-- <input type="text" class="form-control" name="introduce" id="introduce" value="${loginMember.introduce}" required> -->	
				<textarea class="form-control" name="introduce" id="introduce" cols="55" rows="85" >  ${loginMember.introduce} </textarea>
				</td>
			</tr>
			<tr>
				<th class="title" rowspan="2">주소</th>
	  		  	<td>	
	        	<input type="text" class="form-control" name="addressAll" value="${loginMember.addressAll }"/>
	        	<input type="button" class="form-control" value="검색" onclick="execDaumPostcode();" />
	        </tr>
	        <tr>
	        	<td>
	        	<input type="text" class="form-control" name="addressFull" placeholder="상세주소" value="${loginMember.addressFull }" required/>
	        	<input type="hidden" name="locationX" value="${loginMember.locationX }"/>
	        	<input type="hidden" name="locationY" value="${loginMember.locationY }"/>
				<td>
			</tr>  
		</table>
		<br/><br/>
		<input type="submit" class="btn btn-dark" value="저장">
		<input type="reset" class="btn btn-dark">
	</form:form>
		</div>
	</div>
</div>

<script type="text/javascript" 
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ik4yiy9sdi&submodules=geocoder">
</script>
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

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("roadAddress").value = roadAddr;
            
            $("[name=addressAll]").val(data.roadAddress);
            
        	var Addr_val = $('[name=addressAll]').val();

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
                
                $('[name=locationX]').val(x);
                $('[name=locationY]').val(y);
            	
                console.log(x);
                console.log(y);
                
                close();
            });
        	
        }
    }).open();
}
</section>
</script>

<style>
.col-sm-4{
	width : 350px;
	margin-right: -290px;
	}
.list-group-item {
    position: relative;
    display: block;
    padding: 0.5rem 1rem;
    color: #212529;
    text-decoration: none;
    background-color: #fff;
    border: 1px solid rgba(0,0,0,.125);
    cursor: pointer;
    text-align: center;
}
.list-group-item.active {
    z-index: 2;
    color: #fff;
    background-color: gray;
    border-color: gray;
    }
.form-control {
    display: block;
    width: 460px;
    height : 50px;
    padding: 0.375rem 0.75rem;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #212529;
    background-color: #fff;
    background-clip: padding-box;
    border: 1px solid #ced4da;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    border-radius: 0.25rem;
    transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
    margin-bottom : 15px;
    margin-left: 30px;
} 
.custom-select{
	width : 450px;
	height : 38px;
	margin-bottom : 15px;
}
.mx-auto{
	width : 430px;
	padding-left:50px;
}
.mx-auto text-center{
	margin-left : 10px;
}
textarea.form-control {
    min-height: 150px;
}
</style>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>