<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page autoFlush="true" buffer="1094kb"%>
<fmt:requestEncoding value="utf-8"/>


<sec:authorize access="isAnonymous()">
	<jsp:include page="/WEB-INF/views/common/exmain.jsp"></jsp:include>
</sec:authorize>

<!-- chatcontroller 맨 밑에서 requestmapping -->
<sec:authorize access="hasRole('USER')">
	<jsp:forward page="/common/main.do"/>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
	<jsp:include page="/WEB-INF/views/common/error/reportedUserPage.jsp"></jsp:include>
</sec:authorize>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>