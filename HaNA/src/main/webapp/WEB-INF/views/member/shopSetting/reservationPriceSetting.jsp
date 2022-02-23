<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<style>
.rsTableContainer { 
    background: linear-gradient(45deg, #49a09d, #5f2c82);
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width:100%;
}

table {
    width: 50%;
    border-collapse: collapse;
    /* overflow: hidden; */
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    table-layout:fixed;
    word-break:break-all;
}

th,
td {
    padding: 10px;
    background-color: rgba(255, 255, 255, 0.2);
    color: black;
}

th {
    text-align: left;
}

thead th {
    background-color: #55608f;
}

tbody td {
    position: relative;
}
/* tbody tr:hover {
    background-color: #dddfe7;
}
tbody td:hover:before {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    top: -9999px;
    bottom: -9999px;
    z-index: -1;
}
tbody td:hover {
	background-color:#c7cfef;
} */
</style>

<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="예약 설정" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberSetting.css" />
<section>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberSetting.css" />

<br/><br/><br/><br/>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-3">
        	<ul class="list-group">
        	  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationPriceSetting'">요금 관리</li>
			<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/shop/reservationStatistics'">예약 통계</li>	
			</ul>
        </div>
        <!-- 설정 영역 -->
        <div class="col-sm-9">	        
	        <div class="tablePriceContainer">
	        	<h3>예약 금액 설정</h3>
				<table id="tablePrice">
					<colgroup>
						<col width="40%">
						<col width="40%">
						<col width="20%">
					</colgroup>
				
					<thead>
						<tr>
							<th>테이블 이름</th>
							<th>타임별 금액</th>
							<th>저장</th>
						</tr>
					</thead>
					<tbody></tbody>
					<tfoot>
					</tfoot>
				</table>
			</div>
        </div>
    </div>
</div>

<script>
	$(() => {
		console.log('${loginMember.id}')
		selectTablePrice();
	});
	
	function selectTablePrice(){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/selectTablePrice',
			data: {
				memberId: '${loginMember.id}',
			},
			success(res){
				console.log(res);
				$("#tablePrice tbody").empty();
				$.each(res, (i, e) => {
					let tr = `
						<tr>
							<td>
								\${e.tableName}
							</td>
							<td>
								<input type="text" name="price" value="\${e.price}" id="\${e.tableId}" style="width:100px;"/>
								원
							</td>
							<td>
								<input type="button" value="저장" onclick="updateTablePrice('\${e.tableId}');"/>
							</td>
						</tr>
					`;
					$("#tablePrice tbody").append(tr);
				});
				
			},
			error: console.log
		});
	};
	
	function updateTablePrice(tableId){
		let price = $(`#\${tableId}`).val();
		console.log(price);
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/updateTablePrice?${_csrf.parameterName}=${_csrf.token}',
			method: 'POST',
			data:{
				tableId: tableId,
				price: price
			},
			success(res){
				console.log(res)
			},
			complete(){
				alert("수정되었습니다.");
			},
			error: console.log
		})
	};
</script>