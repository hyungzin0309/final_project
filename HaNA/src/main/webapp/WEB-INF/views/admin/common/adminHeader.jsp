<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="관리자페이지" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/adminMain.css" />
<section>
<div class="row admin-total" >
	<div class="col-sm-3 admin-side">
		<div class="admin-side-menu">
			<ul>
			<li><a href="${pageContext.request.contextPath }/admin/restrictionList">제제 내역</a></li>
			<li><a href="${pageContext.request.contextPath }/admin/restrictionAppealList">항소 내역</a></li>
			<li><a href="${pageContext.request.contextPath}/admin/searchStatistics">검색 통계</a></li>
			<li><a href="${pageContext.request.contextPath}/admin/modifyHashtag">소모임 해시태그 관리</a></li>
			</ul>
		</div>
	</div>
	<div class="col-sm-9">