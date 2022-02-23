<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/shopMember/shopReservationList.css" />

	<div class="modal fade" id="listModal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">예약 확인</h3>
						<button class="close" id="res-list-closeBtn" type="button" data-dismiss="modal" aria-label="Close">
							닫기
						</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					<!-- 총 예약건수 -->
					<div id="reservation-count-all">
						<span class="res-count-title">총 예약 건 수 : </span>
						<span id="resCount"></span>
						<br />
						<span class="res-count-title">선택일 예약 건 수 : </span>
						<span id="dailyResCount"></span>
					</div>
					<!-- 일자별 예약리스트 -->
					<div id="reservation-list" style="max-height:300px;overflow:scroll">
						<input type="hidden" name="" id="res-year" />
						<input type="hidden" name="" id="res-month"/>
						<input type="hidden" name="" id="res-date" />
						<table id="reservationTable">
							<thead>
								<tr>
									<th>
										<input type="button" value="&lt;" class="res-dateBtn" id="res-prevDate"/>
									</th>
									<th colspan="6" id="res-today"></th>
									<th>
										<input type="button" value="&gt;" class="res-dateBtn" id="res-nextDate"/>
									</th>
								</tr>
								<tr>
									<th width="15%">예약일</th>
									<th width="10%">예약자</th>
									<th width="12%">예약테이블</th>
									<th width="5%">예약시작</th>
									<th width="5%">예약종료</th>
									<th width="5%">인원</th>
									<th width="25%">예약요청</th>
									<th width="15%">예약상태</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
					
				</div>
				<!-- footer -->
				<div class="modal-footer">
				</div>
			</div>
		</div>
	</div>
	

<script>
	
	$(() => {
		shopReservationCount();
		setDate();
	});
	
	/* 예약확인 클릭 시 modal 노출 */
	$("#reservationListBtn").click((e) => {
		setDate();
		$("#reservationTable tbody").empty();
		let rYear = $("#res-year").val();
		let rMonth = $("#res-month").val();
		let rDate = $("#res-date").val();
		shopReservationListByDate(`\${rYear}-\${rMonth}-\${rDate}`);
		$("#listModal1").modal({backdrop:'static', keyboard:false});
	});
	
	/* 다음일 버튼 클릭 이벤트 */
	$("#res-nextDate").click((e) => {
		let nYear = $("#res-year").val()*1;
		let nMonth = $("#res-month").val()*1;
		let nDate = $("#res-date").val()*1;
		
		let calDate = new Date(nYear, nMonth, 0);
		
		let targetDate;
		if(nMonth == 12 && nDate == 31){
			targetDate = `\${nYear+1}-1-1`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${nYear+1}년 1월 1일`);
			$("#res-year").val(nYear+1);
			$("#res-month").val(1);
			$("#res-date").val(1);
		} else if(nDate + 1 > calDate.getDate()){
			targetDate = `\${nYear}-\${nMonth+1}-1`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${nYear}년 \${nMonth+1}월 1일`);
			$("#res-month").val(nMonth+1);
			$("#res-date").val(1);
		} else{
			targetDate = `\${nYear}-\${nMonth}-\${nDate+1}`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${nYear}년 \${nMonth}월 \${nDate+1}일`);
			$("#res-date").val(nDate+1);			
		}
	});
	
	/* 이전일 버튼 클릭 이벤트 */
	$("#res-prevDate").click((e) => {
		let pYear = $("#res-year").val()*1;
		let pMonth = $("#res-month").val()*1;
		let pDate = $("#res-date").val()*1;
		
		let calDate = new Date(pYear, pMonth-1, 0);
		
		let targetDate;
		
		if(pMonth == 1 && pDate == 1){
			targetDate = `\${pYear-1}-12-31`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${pYear-1}년 12월 31일`);
			$("#res-year").val(pYear-1);
			$("#res-month").val(12);
			$("#res-date").val(31);
		} else if(pDate - 1 < 1){
			targetDate = `\${pYear}-\${pMonth-1}-\${calDate.getDate()}`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${pYear}년 \${pMonth-1}월 \${calDate.getDate()}일`);
			$("#res-month").val(pMonth-1);
			$("#res-date").val(calDate.getDate());
		} else{
			targetDate = `\${pYear}-\${pMonth}-\${pDate-1}`;
			shopReservationListByDate(targetDate);
			$("#res-today").text(`\${pYear}년 \${pMonth}월 \${pDate-1}일`);
			$("#res-date").val(pDate-1);			
		}
	});
	
	
	function setDate(){
		const today = new Date();
		let year = today.getFullYear();
		let month = today.getMonth()+1;
		let date = today.getDate();
		
		$("#res-year").val(year);
		$("#res-month").val(month);
		$("#res-date").val(date);
		
		$("#res-today").text(`\${year}년 \${month}월 \${date}일`);
	}
	
	function shopReservationCount(){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/shopReservationCount',
			data:{
				shopId: '${loginMember.id}'
			},
			success(res){
				$("#resCount").text(res);
				$("#resCount").css("background-color", "powderblue");
			},
			error: console.log
		})
	};
	
	function shopReservationListByDate(date){

		$.ajax({
			url: '${pageContext.request.contextPath}/shop/selectShopReservationListByDate',
			data:{
				id: '${loginMember.id}',
				date
			},
			success(res){
				$("#reservationTable tbody").empty();
				
				let countNum = 0;
				
				$.each(res, (i, e) => {
					if(e.reservationStatus == '예약완료'){
						let convertDate = new Date(e.reservationDate);
						let tr = `
							<tr>
								<td>
									\${convertDate.getFullYear()}년 \${convertDate.getMonth()+1}월 \${convertDate.getDate()}일
								</td>
								<td>
									\${e.reservationUser}
								</td>
								<td>
									\${e.reservationTableId}
								</td>
								<td>
									\${e.timeStart}
								</td>
								<td>
									\${e.timeEnd}
								</td>
								<td>
									\${e.visitorCount}
								</td>
								<td>
									\${e.reqOrder}
								</td>
								<td>
									\${e.reservationStatus}
								</td>
							</tr>
						`;
						$("#reservationTable tbody").append(tr);
						countNum += 1;
					}
				});
				
				if($("#reservationTable tbody").text() == ''){
					console.log("empty");
					let tr = `
						<tr>
							<th colspan="8">등록된 내역이 없습니다.</th>
						</tr>
					`;
					$("#reservationTable tbody").append(tr);
				}
				
				$("#dailyResCount").text('');
				$("#dailyResCount").text(countNum);
			},
			error: console.log
		});
	};
</script>



