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
	alert("${msg}");
	</script>
</c:if>

<br><br><br>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/memberSetting'">프로필 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/updatePassword'">비밀번호 변경</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/accountPrivate'">계정 공개</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/myReservationList'">내 예약내역</li>
			</ul>
        </div>
        
        
         <div class="col-sm-8">
        <form:form name="accountPrivateFrm" 
        	action="${pageContext.request.contextPath}/member/accountPrivate?${_csrf.parameterName}=${_csrf.token}" 
        	enctype="multipart/form-data" 
        	method="POST">
       			<input type="hidden" name="id" value="${loginMember.id}" />
       			<c:choose>
       			<c:when test="${publicProfile eq 2}">
        		<input type="checkbox" name="publicProfile" id="publicProfile" checked>계정 비공개
        		</c:when>
        		<c:otherwise>
        		<input type="checkbox" name="publicProfile" id="publicProfile" >계정 비공개
        		</c:otherwise>
        		</c:choose>
        		 &nbsp;
        		<input type="submit" class="changeButton" value="변경" style="color:green;">
        	<br><br>     	 
        </form:form>
        </div>
</div>
<script>
$(accountPrivateFrm).submit((e) => {
	if ($("input[name='publicProfile']").is(":checked")) {
	$("input[name='publicProfile']").val(2);

	} else {
		$("input[name='publicProfile']").val(1);
	}
});
//if(document.getElementById("account").checked) {
 //   document.getElementById("input_check_hidden").disabled = true;
//}
</script>
<style>
.changeButton {
    width: 65px;
    height: 30px;
    margin-top: 10px;
    border-style: none;
    border-bottom: solid;
    background-color: white;
    border-width: 1px;
}
.col-sm-8 {
    flex: 0 0 auto;
    width: 250px;
    font-size:17px;
}
.col-sm-4{
	width : 350px;
	margin-right: 100px;
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
#publicProfile{
margin-right : 10px;
}
.list-group-item.active {
    z-index: 2;
    color: #fff;
    background-color: gray;
    border-color: gray;
}
</style>