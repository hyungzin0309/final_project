<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="제제사유" name="title"/>
</jsp:include>
<sec:authentication property="principal" var="loginMember"/>
<div style="text-align:center; margin-top:300px; font-size:3em; font-weight:650; color:blue;">신고 유저 제제 페이지</div>
<div class="restrictionDate"></div>
<input type="button" value="항의하기" onclick="appealMyDistriction('${loginMember.id}')"/>


<script>
	$(() => {
		reportedPageData();
	}) 
	
	function reportedPageData(){
		$.ajax({
			url: '${pageContext.request.contextPath}/member/selectRestrictionData',
			data:{
				id: '${loginMember.id}'
			},
			success(res){
				console.log(res);
				$(".restrictionDate").text(`제제 기한은 \${new Date(res.RESTRICTED_DATE)}까지 입니다.`);
			},
			error: console.log
		});
	};
	
	function appealMyDistriction(id){
		console.log(id);
		$.ajax({
			url: '${pageContext.request.contextPath}/member/appealMyDistriction',
			method: 'POST',
			data: {
				id
			},
			success(res){
				console.log(res);
			},
			error:console.log,
			complete(){
				alert("제출되었습니다.\n관리자 확인후 처리됩니다.");
			}
		});
	}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>