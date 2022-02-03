<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="프로필 설정" name="title"/>
</jsp:include>

<sec:authentication property="principal" var="loginMember"/>

<h1>shop프로필설정</h1>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4">
        	<ul class="list-group">
        		<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
				<li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
			</ul>
        </div>
        
        <div class="col-sm-8">
        	<!-- 등록 해시태그 -->
			<div class="myHashTag">
				<span>등록된 해시태그</span>
				<div class="myTagArea">
				
				</div>
			</div>
        	<br />
        	<br />
        	<br />
        	<br />
        	<br />
        	<!-- 해시태그 등록 -->
        	<div class="regHashTag">
        		<form:form action="${pageContext.request.contextPath }/shop/insertHashTag" method="POST">
	        		<label for="regHashTag">해시태그 등록하기</label>
	        		<input type="text" name="tagName" id="" />
	        		<input type="hidden" name="memberId" value="${loginMember.id }" />
	        		<input type="submit" value="등록" />
        		</form:form>
        	</div>
        
        </div>
    </div>
    
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>