<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.kh.hana.group.model.vo.Group, java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="소모임 회원 통계" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />

<div class="statistic-page-label">
	<h3>[${groupId}] &nbsp;멤버 활동 통계</h3>
</div>
<div class="statistic-container">
	<div class="select-graph-box-container">
		<select class="statistic-select-box" name="category" id="category">
			<option value="visit">방문 수</option>
			<option value="comment">댓글 수</option>
			<option value="like">좋아요 수</option>
		</select>
		<select class="statistic-select-box" name="day" id="day">
			<option value="0">기간 전체</option>
			<option value="30">한 달</option>
			<option value="7">일주일</option>
		</select>
	</div>
	<div class="graph-container">
		<table style="width:100%;">
			<tbody>

			</tbody>
		</table>
	</div>
</div>

<script>

	$(document).ready(getVisitStatistic);

	$("#category, #day").change((e)=>{
		if($("#category").val() == 'visit'){
			getVisitStatistic();
		}
		else if($("#category").val() == 'comment') {
			getCommentStatistic();
		}
		else if($("#category").val() == 'like') {
			getLikeStatistic();
		}
	})
	
	function getVisitStatistic(){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/getVisitGraph/${groupId}",
			data:{
				day:$("#day").val()
			},
			success(data){
				console.log(data);
				makeGraph(data);
			},
			error:console.log
		})
	}
	
	function getCommentStatistic(){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/getCommentGraph/${groupId}",
			data:{
				day:$("#day").val()
			},
			success(data){
				console.log(data);
				makeGraph(data);
			},
			error:console.log
		})
	}
	
	function getLikeStatistic(){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/getLikeGraph/${groupId}",
			data:{
				day:$("#day").val()
			},
			success(data){
				console.log(data);
				makeGraph(data);
			},
			error:console.log
		})
	}
	
	function makeGraph(data){
		$(".graph-container table tbody").empty();
		let max = data[0].count;

		$.each(data,function(i,e){
			let width = (e.count/max)*80;
			let count = "";
			if(e.count != 0){
				count = e.count; // e.count가 0이 아닐 때만 숫자 표시
			}
			let tr = `<tr>
				<td class='graph-memberId'>\${e.memberId}&nbsp;</td>
				<td class='graph-bar-container'><div class='graph-bar' style="width:\${width}%;"></div>&nbsp;\${count}</td>
			</tr>`
			$(".graph-container table tbody").append(tr);
		});
		
		
	}
</script>

    
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>