<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<section class="body-section"
	style="width: 200px; height: 100%; float: right; display: block;">
	<span style="float: right;"></span>
</section>
<section>
	<link rel="stylesheet"
		href="${pageContext.request.contextPath }/resources/css/mbti.css" />
	<div id="mbtiMain-Background">
		<img class ="mbtiMainImg" src="/hana/resources/images/learn-g9ed443a84_1920.png" alt="이미지" />
		<h1 id="mainPage-h1">나는 어떤 사람 일까 ?</h1>
		<span id="mainPage-span">"mbti로 알아보는 성격 유형 테스트"</span>
		<button id="mainPage-button"
			onclick="location.href='${pageContext.request.contextPath}/mbti/mbtiList.do?cPage=1'">START</button>
	</div>
</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>