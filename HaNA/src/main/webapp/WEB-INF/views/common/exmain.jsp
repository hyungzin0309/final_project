<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hi welcome to HaNA</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/exmain/assets/css/main.css" />
</head>
<body>
<body class="is-preload">

<!-- Header -->
	<header id="header">
		<div class="content">
			<h1>
				<a href="#">Around Us</a>
			</h1>
			<p>
				같은 동네, 같은 취미<br /> 공통사를 가진 친구를 사귀고 싶다면
			</p>
			<ul class="actions">
				<li><a href="${pageContext.request.contextPath}/member/login.jsp"
					class="button primary icon solid fa-chevron-down scrolly"> LOG IN</a></li>
				<li><a href="${pageContext.request.contextPath}/member/memberEnrollMain"  class="button icon solid fas fa-pencil-alt"> SIGN UP</a></li>
			</ul>
		</div>
		<div class="image phone">
			<div class="inner">
				<img src="${pageContext.request.contextPath}/resources/images/page.png" alt="" />
			</div>
		</div>
	</header>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/jquery.scrolly.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/browser.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/breakpoints.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/util.js"></script>
<script src="${pageContext.request.contextPath}/resources/exmain/assets/js/main.js"></script>
</body>
</html>