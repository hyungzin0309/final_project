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

<c:if test="${not empty msg}">
	<script>
	alert("${msg}");
	</script>
</c:if>

<sec:authentication property="principal" var="loginMember"/>
<br><br><br> 
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/memberSetting'">프로필 변경</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/updatePassword'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/accountPrivate'">계정 공개</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/myReservationList'">내 예약내역</li>
			</ul>
        </div>
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
        	<input type="submit" class="btn btn-outline-success" value="비밀번호 변경" style="margin-left:90px; margin-top:30px;">
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
.col-sm-4{
	width : 350px;
	margin-right: 190px;
	}
.col-sm-8 {
    flex: 0 0 auto;
    width: 250px;
}
.password{
    margin: 0;
    font-family: inherit;
    font-size: inherit;
    line-height: inherit;
    width: 350px;
    border-radius: 5px;
    height: 42px;
    border-color: gainsboro;
    border-style: solid; 
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
.btn-dark {
    color: #fff;
    background-color: #212529;
    border-color: #212529;
    margin-left: 100px;
}

</style>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>