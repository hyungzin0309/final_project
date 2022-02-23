<%@page import="com.kh.hana.group.model.vo.GroupBoard"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/group.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<sec:authentication property="principal" var="loginMember" />
    
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fe4df2cda826ac2a53225fb7dea2a307&libraries=services"></script>

<script>
let gb; // 스크립트에서 사용할 게시물 정보 

//계정페이지로 이동
function goMemberView(memberId){
	location.href=`${pageContext.request.contextPath}/member/memberView/\${memberId}`;
}
</script>
<style>
.hashtag-page.hashtag-container {
	height:80px;
	width:58%;
	margin:auto;
	margin-top:100px;
	color:gray;
}
.hashtag-page.hashtag-container>span {
	font-size:2em;
	font-weight:600;
}
</style>
<div class="hashtag-page hashtag-container">
	<span>#${hashtag}</span>
</div>
<!-- 게시물 목록 -->
<section>
	<div class="location-group-board-container">
		<c:forEach items="${groupBoardList}" var="board" varStatus="vs">
			${vs.index%3 == 0? "<div style='margin-bottom:30px;' class='row'>" : ""}
		        <div class="col-sm-4" style="min-height:300px;">
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
</section>
    
<jsp:include page="/WEB-INF/views/group/modal/groupBoardDetail.jsp"/>
    
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>