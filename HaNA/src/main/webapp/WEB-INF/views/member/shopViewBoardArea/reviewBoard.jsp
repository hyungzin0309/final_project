<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<fmt:requestEncoding value="utf-8" />

	<c:forEach items="${reviewList }" var="review">
		<div class="thumbnail col-sm-4">
	    	<input type="hidden" value="${review.no}" id="boardNo" name="no"/>
	    	<img src="${pageContext.request.contextPath}/resources/upload/member/board/${review.picture[0] }" alt="" class="board-main-image"
	    	style="width:80%; height:80%;  margin-left : 20%;"/>
	    </div>
	
	</c:forEach>
	