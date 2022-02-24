<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="소그룹페이지" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/group.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />

<script src="https://kit.fontawesome.com/0748f32490.js"
	crossorigin="anonymous">
</script>
<script src="https://kit.fontawesome.com/0748f32490.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<sec:authentication property="principal" var="loginMember" />

<script>
//게시글 상세보기 시 페이지 이동 후 게시글 출력
$(document).ready( function() {
	let temp = location.href.split("?");
 	if(temp[1] !== undefined){		
 	getPageDetail(temp[1]);
	}
});
let gb; // 스크립트에서 사용할 게시물 정보 

//계정페이지로 이동
function goMemberView(memberId){
	location.href=`${pageContext.request.contextPath}/member/memberView/\${memberId}`;
}

<% 
String msg = (String)request.getAttribute("msg");
if(msg != null){
%>
	
	alert("<%=msg%>");

<%}%>
</script>


<!-- 그룹 프로필 -->
<jsp:include page="/WEB-INF/views/group/groupProfile.jsp"/>


<!-- 게시물 목록 -->
<div class="group-board-container">
	<c:forEach items="${groupBoardList}" var="board" varStatus="vs">
		<!-- row 클래스를 통해 개행 -->
		${vs.index%3 == 0? "<div style='margin-bottom:30px;' class='row'>" : ""}
	        <div class="col-sm-4" >
	        <div class="group-board-thumbnail-container">
	        	<input type="hidden" value="${board.no}" id="group-board-no"/>
				<img class="board-main-image"
					src="${pageContext.request.contextPath}/resources/upload/group/board/${board.image[0]}"
					alt="" />
	        </div>
	        </div>
		${vs.index%3 == 2? "</div>" : ""}
	</c:forEach>
</div>
<!-- 가입신청리스트 모달 -->
<jsp:include page="/WEB-INF/views/group/modal/groupApplyList.jsp"/>

<!-- 게시물 상세보기 모달 -->
<jsp:include page="/WEB-INF/views/group/modal/groupBoardDetail.jsp"/>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>