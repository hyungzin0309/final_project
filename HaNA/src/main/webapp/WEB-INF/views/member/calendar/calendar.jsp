<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<style>
	/* 예약일 선택 table */
	#calendarTable th{
 		text-align: center;
	}
	#calendarTable td{
		text-align: center;
	}
	.dateNormal{
		color:black;
	}
	.dateSat{
		color:blue;
	}
	.dateSun{
		color:red;
	}
	.disabled{
		color:yellow;
	}
	.dateBtn{
		border: none;
		background-color: #ffffff;
		outline: 0;
	}
</style>

	<input type="hidden" name="" id="resYear" />
	<input type="hidden" name="" id="resMonth" />
	<input type="hidden" name="" id="selectDate" />
	<table id="calendarTable">
		<thead>
			<tr>
				<th colspan=7 id="monthHeader">							
				</th>
			</tr>
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
	<input type="button" value="이전" id="getNextMonth" onclick="getPrevMonth();"/>
	<input type="button" value="다음" id="getPrevMonth" onclick="getNextMonth();"/>

<script>
	$(() => {
		/* input 날짜 오늘날짜로 set */
		let today = new Date();			
		let thisYear = today.getFullYear();
		let thisMonth = today.getMonth() + 1;
		$("#resYear").val(thisYear);
		$("#resMonth").val(thisMonth);
		
		calendarModal(thisYear, thisMonth);
	})
	
	/* calender 다음 버튼 */
	function getNextMonth() {
		let curMonth = $("#resMonth").val();
		let curYear = $("#resYear").val();
		
		let reqMonth = curMonth*1;
		let reqYear = curYear*1;
		if(curMonth == 12){
			reqMonth = 1;
			reqYear += 1;
		} else {
			reqMonth += 1;
		}
		
		$("#resMonth").val(reqMonth);
		$("#resYear").val(reqYear);
		
		calendarModal(reqYear, reqMonth);
	}
	
	/* calender 이전 버튼 */
	function getPrevMonth() {
		let curMonth = $("#resMonth").val();
		let curYear = $("#resYear").val();
		
		let reqMonth = curMonth*1;
		let reqYear = curYear*1;
		if(curMonth == 1){
			reqMonth = 12;clr
			reqYear -= 1;
		} else {
			reqMonth -= 1;
		}
		
		$("#resMonth").val(reqMonth);
		$("#resYear").val(reqYear);
		
		calendarModal(reqYear, reqMonth);
	}
	
	/* 캘린더 일자 클릭 시 입력값 input */
	/* 각자 페이지 script에 함수 가져다가 맞춰서 쓰세요! */
	/* function setDate(e){
		console.log($("#resYear").val(), $("#resMonth").val(), e);
		$("#selectDate").val(e);
		$(".dateBtn").css('background-color', '#ffffff');
		$(`#dateBtn\${e}`).css('background-color', 'green');
	} */
	
	/* 달력 func */
	function calendarModal(year, month){
		$.ajax({
			url : '${pageContext.request.contextPath}/shop/createCalendar',
			data : {
				year,
				month
			},
			success(res){
				let today = res.today;
				let lastDay = res.lastDay;
				let startDow = res.startDow;
				
				let now = new Date();
				
				$("#monthHeader").text(`\${year}년 \${month}월`);
				$("#calendarTable tbody").empty();
				
				for(let i = 1; i <= lastDay; i++){
					if(i == 1){
						$("#calendarTable tbody").append("<tr>");
						let emptyTd = "<td></td>";
						for(let j = 1; j < startDow; j++){
							$("#calendarTable tbody").append(emptyTd);	
						};
					};
					
					let tdNormal = `
						<td>
							<button class="dateBtn dateNormal" id="dateBtn\${i}" onclick="setDate(\${i})">\${i}</button>
						</td>
					`;
					let tdSat = `
						<td>
							<button class="dateBtn dateSat" id="dateBtn\${i}"  onclick="setDate(\${i})">\${i}</button>
						</td>
					`;
					let tdSun = `
						<td>
							<button class="dateBtn dateSun" id="dateBtn\${i}" onclick="setDate(\${i})">\${i}</button>
						</td>
					`;
					
					if(startDow%7 == 1){
						$("#calendarTable tbody").append(tdSun);
					} else if(startDow%7 == 0){
						$("#calendarTable tbody").append(tdSat);
					} else {
						$("#calendarTable tbody").append(tdNormal);
					}
					
					if(startDow%7 == 0){
						$("#calendarTable tbody").append("</tr><tr>");
					};
					
					startDow += 1;
					
					if(i == lastDay){
						$("#calendarTable tbody").append("</tr>");
					};
					
					if(i < today && month <= now.getMonth()+1 && year <= now.getFullYear()){
						$("#calendarTable button:last").css('color', '#cfcaca');
						$("#calendarTable button:last").css('text-decoration', 'none');
						$("#calendarTable button:last").attr('onclick', '');
					} else if(month < now.getMonth()+1 && year <= now.getFullYear()){
						$("#calendarTable button:last").css('color', '#cfcaca');
						$("#calendarTable button:last").css('text-decoration', 'none');
						$("#calendarTable button:last").attr('onclick', '');
					}
				}
			},
			error: console.log
		});
	};
</script>		