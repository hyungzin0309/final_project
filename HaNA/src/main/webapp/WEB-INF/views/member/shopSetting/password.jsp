<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="비밀번호 변경" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberSetting.css" />

<sec:authentication property="principal" var="loginMember"/>

<br/><br/><br/><br/>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
        	  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationPriceSetting'">요금 관리</li>
			<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/shop/reservationStatistics'">예약 통계</li>	
			</ul>
        </div>
        <!-- 설정 영역 -->
        <div class="col-sm-8">
        <form:form name="memberUpdateFrm" 
        	action="${pageContext.request.contextPath}/member/updatePassword?${_csrf.parameterName}=${_csrf.token}" 
        	enctype="multipart/form-data" 
        	method="POST">
       	 <input type="hidden" name="id" value="${loginMember.id}" />
        <!-- 설정 영역 -->
            <label for="password">현재 비밀번호&nbsp;&nbsp;&nbsp;&nbsp;</label>
        	<input type="password" name="password" id="password" class="password"/>
        	<br><br>
        	<label for="new-password">새 비밀번호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
        	<input type="password" name="newPassword" id="newPassword" class="password"/>
        	<br><br>
        	<label for="password-check">새 비밀번호 확인</label>
        	<input type="password" name="passwordCheck" id="passwordCheck" class="password"/>
        	<br><br>
        	<input type="submit" class="btn btn-outline-success" value="비밀번호 변경" style="margin-left:200px; margin-top:30px;">
        </form:form>
        </div>
    </div>
</div>
<script>
$("#passwordCheck").blur(passwordValidate);
 
function passwordValidate(){
	var $newPassword = $("#newPassword");
	var $passwordCheck = $("#passwordCheck");
	if($newPassword.val() != $passwordCheck.val()){
		alert("새 비밀번호가 일치하지 않습니다.");
		$newPassword.select();
		return false;
	}
	return true;	
}
</script>
<style>
label{
margin-left : 100px;
}
.password{
  	margin-left : 100px;
    font-family: inherit;
    font-size: inherit;
    line-height: inherit;
    width: 350px;
    border-radius: 5px;
    height: 42px;
    border-color: gainsboro;
    border-style: solid; 
}
</style>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>