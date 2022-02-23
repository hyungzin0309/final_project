<%@page import="java.util.Map"%>
<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href='${pageContext.request.contextPath}/resources/fullcalendar/main.css' rel='stylesheet' />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/group.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />

<script src='${pageContext.request.contextPath}/resources/fullcalendar/main.js'></script>
<script src='${pageContext.request.contextPath}/resources/fullcalendar/ko.js'></script>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

	<!-- 그룹 프로필 -->
	<%@ include file="/WEB-INF/views/group/groupProfile.jsp"%>
 	<jsp:include page="/WEB-INF/views/group/modal/groupApplyList.jsp"/>
 		
	
	<div class="calendarPage-container">
	
	
<!-- 관리자인 경우 편집 가능한 캘린더 -->
<% 
		if(memberIdList.contains(loginMember.getId())){
			for(Map<String,String> m : memberList){
				if(m.get("memberId").equals(loginMember.getId())){
					if(m.get("memberLevelCode").equals("ld") || m.get("memberLevelCode").equals("mg")){	
%>
	 <jsp:include page="/WEB-INF/views/group/calendar/editable.jsp">
 	 	<jsp:param name="groupId" value="${group.groupId}" />
	 </jsp:include>	
	
<%
			}}}};
%>
<!-- 일반회원인 경우 readonly-->
<% 
		if(memberIdList.contains(loginMember.getId())){
			for(Map<String,String> m : memberList){
				if(m.get("memberId").equals(loginMember.getId())){
					if(m.get("memberLevelCode").equals("mb")){	
%>
	<jsp:include page="/WEB-INF/views/group/calendar/readonly.jsp">	
 		 <jsp:param name="groupId" value="${group.groupId}"/>
	 </jsp:include>	
<%
			}}}};
%>
  </div>
		

		
	

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
