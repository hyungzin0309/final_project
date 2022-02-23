<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/admin/common/adminHeader.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/searchStatistics.css" />

<div class="statics-main" style="padding:0 10%; height:100%; margin:auto;">
	<div class="statistic-container">
		<div class="select-graph-box-container">
			<select class="statistic-select-box" name="category" id="category">
				<option value="all">카테고리 전체</option>
				<option value="member">계정</option>
				<option value="group">소그룹</option>
				<option value="shop">비즈니스</option>
				<option value="location">장소</option>
			</select>
			<select class="statistic-select-box" name="day" id="day">
				<option value="0">기간 전체</option>
				<option value="30">한 달</option>
				<option value="7">일주일</option>
				<option value="1">하루</option>
			</select>
		</div>
		<div class="graph-container">
			<table style="width:100%;">
				<tbody>
	
				</tbody>
			</table>
		</div>
	</div>
</div>
<script>
	$(document).ready(getSearchStatistic);
	
	$("#category, #day").change((e)=>{
		getSearchStatistic();
	})
	
	function getSearchStatistic(){
		
		let category = $("#category").val();
		let day = $("#day").val();
		
		$.ajax({
			url:"${pageContext.request.contextPath}/admin/getStatics",
			data:{
				category, day
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
		if(data.length !== 0){
			let max = data[0].count;
			$.each(data,function(i,e){
				let width = (e.count/max)*80;
				let count = "";
				if(e.count != 0){
					count = e.count; // e.count가 0이 아닐 때만 숫자 표기
				}
				let tr = `<tr>
					<td class='graph-keyword'>\${e.keyword}&nbsp;</td>
					<td class='graph-bar-container'><div class='graph-bar' style="width:\${width}%;"></div>&nbsp;\${count}</td>
				</tr>`
				$(".graph-container table tbody").append(tr);
			});			
		}
		
		
	}
</script>

<jsp:include page="/WEB-INF/views/admin/common/adminFooter.jsp"/>
