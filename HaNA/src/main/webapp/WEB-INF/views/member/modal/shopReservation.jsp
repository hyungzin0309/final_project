<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/shopMember/shopReservationModal.css" />

	<!-- Modal1-->
	<div class="modal fade shop-res-modal" id="modal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">예약하기</h3>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">
							닫기
						</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					${shopInfo.shopIntroduce }
				</div>
				<!-- footer -->
				<div class="modal-footer">
					<a class="btn nextBtn" data-num="1" href="#">다음</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal2 : 예약일시 선택 -->
	<div class="modal fade shop-res-modal" id="modal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">예약일 선택</h3>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">닫기</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					<input type="hidden" name="" id="resYear" />
					<input type="hidden" name="" id="resMonth" />
					<input type="hidden" name="" id="selectDate" />
					<table id="calendarTable">
						<thead>
							<tr>
								<th>
									<input type="button" class="calendar-btn" value="&lt;" id="getNextMonth" onclick="getPrevMonth();"/>			
								</th>
								<th colspan=5 id="monthHeader"></th>
								<th>
									<input type="button" class="calendar-btn" value=">" id="getPrevMonth" onclick="getNextMonth();"/>			
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
					
				</div>
				<!-- footer -->
				<div class="modal-footer">
					<a class="btn prevBtn" data-num="2" href="#">이전</a>
					<a class="btn nextBtn" data-num="2" href="#">다음</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal3 : 예약테이블 선택 -->
	<div class="modal fade shop-res-modal" id="modal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">테이블 선택</h3>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">닫기</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					<table id="table-select">
						<thead></thead>
						<tbody></tbody>
					</table>
				</div>
				<!-- footer -->
				<div class="modal-footer">
					<a class="btn prevBtn" data-num="3" href="#">이전</a>
					<a class="btn nextBtn" data-num="3" href="#">다음</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal4 : 예약시간 선택 -->
	<div class="modal fade shop-res-modal" id="modal4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">예약시간 설정</h3>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">닫기</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					<table id="time-select">
						<thead></thead>
						<tbody></tbody>
					</table>
				</div>
				<!-- footer -->
				<div class="modal-footer">
					<a class="btn prevBtn" data-num="4" href="#">이전</a>
					<a class="btn nextBtn" data-num="4" href="#">다음</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal5 : 방문자 수, 예약 요청 입력 -->
	<div class="modal fade shop-res-modal" id="modal5" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<!-- header -->
				<div class="modal-header">
					<h3 class="modal-title">방문자 수, 요청사항 입력</h3>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">닫기</button>
				</div>
				<!-- 내용 -->
				<div class="modal-body">
					<table id="res-info">
						<tr>
							<th>방문 인원 수</th>
							<td>
								<input type="number" name="visitors" id="" min="1" max="10" />(명)
							</td>
						</tr>
						<tr>
							<th>
								요청사항 입력
							</th>
							<td>
								<textarea name="req_order" id="req_order_textarea" cols="30" rows="5" placeholder="예약 시 필요한 내용을 적어주세요."></textarea>
							</td>
						</tr>	
					</table>
				</div>
				<!-- footer -->
				<div class="modal-footer">
					<a class="btn prevBtn" data-num="5" href="#">이전</a>
					<a class="btn submitBtn" data-num="5" href="#">완료</a>
				</div>
			</div>
		</div>
	</div>
	
	

<!-- 관련 스크립트 -->
<script>	
	/* 예약버튼 클릭 */
	$('#reservationBtn').click(function(e){
		e.preventDefault();
		$('#modal1').modal({backdrop:'static', keyboard:false});
		
	});									
	/* 다음 버튼 */
	$(".nextBtn").click((e) => {			
		let curModal = `#modal\${$(e.target).data('num')}`;										
		let nextModal = `#modal\${$(e.target).data('num')+1}`;
		if(curModal == '#modal1'){
			modalChange(curModal, nextModal);
		}
		
		if(curModal == '#modal2'){
			let selectDate = $(curModal).find("#selectDate").val();
			let selectMonth = $("#resMonth").val();
			let selectYear = $("#resYear").val();
			
			let nowDate = new Date();
			
			let bool = selectDate <= nowDate.getDate()-1 && selectMonth <= nowDate.getMonth() && selectYear <= nowDate.getFullYear();  
			if(selectDate == ''){
				alert("날짜를 선택해주세요");
			} else if(bool) {
				alert("오늘 이전은 선택할 수 없습니다.");
			} else{
				modalChange(curModal, nextModal);	
			}
			
		} else if(curModal == '#modal3'){
			if($('[name=tb-select]:checked').val() == null){
				alert('테이블을 선택해주세요');
			} else{
				modalChange(curModal, nextModal);
			}
		} else if(curModal == '#modal4'){
			if($('[name=time-select]:checked').val() == null){
				alert('예약시간을 선택해주세요');
			} else{
				modalChange(curModal, nextModal);
			}
		}
	
		function modalChange(cur, next){
			$(cur).css('display', 'none');
			$(cur).modal('hide');
			$(next).modal({backdrop:'static', keyboard:false});
		}
	});
	
	/* 이전 버튼 */
	$(".prevBtn").click((e) => {
		let curModal = `#modal\${$(e.target).data('num')}`;
		let prevModal = `#modal\${$(e.target).data('num')-1}`;
		e.preventDefault();
		$(prevModal).css('display', 'block');
		$(prevModal).modal('show');
		$(curModal).modal('hide');
	})
	
	/* x버튼 클릭 시에만 모달 닫히게 */
	$(".close").click((e) => {
		window.location.reload();
	});
	
	/* 예약 등록하기 클릭 */
	$(".submitBtn").click((e) => {
		let tableId = $("[name=tb-select]:checked").data('table-id');
		let allowVisitor = `#allowVisitor\${tableId}`;
		let allowValue = $(`\${allowVisitor}`).val();			
		
		let intAllowValue = allowValue * 1;
		let intAllowVisitors = $("[name=visitors]").val() * 1;
		
		if(confirm("예약 등록하시겠습니까?")){
			if(intAllowValue < intAllowVisitors){
				alert(`최대 예약 가능 인원은 \${intAllowValue}명 입니다.`);
				$("[name=visitors]").focus();
			} else{
				submitRequest();
			}
		}
	});
	
	/* 모달 이동 시 제어 onload  */
	$(() => {
		/* show modal on event */
		$(".modal").on('show.bs.modal', function(e){				
			let modalId = $(e.target).prop('id');
			if(modalId == 'modal2'){
				calendarModal($("#resYear").val(), $("#resMonth").val());
			}
			if(modalId == 'modal3'){
				tableModal();
			}
			if(modalId == 'modal4'){
				timeModal();						
			}
		});
		
		/* hide modal on event */
		$(".modal").on('hidden.bs.modal', function(e){
			/* console.log($(e.target).find('h3').text()); */
		})
		
		/* input 날짜 오늘날짜로 set */
		let today = new Date();			
		let thisYear = today.getFullYear();
		let thisMonth = today.getMonth() + 1;
		$("#resYear").val(thisYear);
		$("#resMonth").val(thisMonth);
	});
	
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
			reqMonth = 12;
			reqYear -= 1;
		} else {
			reqMonth -= 1;
		}
		
		$("#resMonth").val(reqMonth);
		$("#resYear").val(reqYear);
		
		calendarModal(reqYear, reqMonth);
	}
	
	/* 캘린더 일자 클릭 시 입력값 input */
	function setDate(e){
		$("#selectDate").val(e);
		$(".dateBtn").css('background-color', '#ffffff');
		$(`#dateBtn\${e}`).css('background-color', 'green');
	}
	
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
	
	
	/* 테이블 선택 func */
	function tableModal(){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/loadShopTable',
			data: {
				id: '${shopInfo.id}'
			},
			success(res){					
				let tbody = $("#table-select tbody");
				let thead = $("#table-select thead");
				let th = `
					<tr>
						<th width="5%">선택</th>
						<th width="15%">테이블명</th>
						<th width="15%">최대인원</th>
						<th width="15%">운영시간</th>
						<th width="25%">특이사항</th>
						<th width="15%">가격</th>
					</tr>
				`;
				tbody.empty();
				thead.empty();
				if(res == ''){
					tbody.append("예약 가능한 테이블이 존재하지 않습니다.");
				} else{
					thead.append(th);
					$.each(res, (i, e) => {
						if(e.enable == 'Y'){
							let tr = `
								<tr>
									<td>
										<input type="radio" name="tb-select" data-table-id="\${e.tableId}"/>
									</td>
									<td>
										\${e.tableName}
									</td>
									<td>
										\${e.allowVisitor}
										<input type="hidden" id="allowVisitor\${e.tableId}" value="\${e.allowVisitor}"/>
									</td>
									<td>
										\${e.allowStart} ~ \${e.allowEnd}
									</td>
									<td>
										\${e.memo}
									</td>
									<td>
										\${e.price}원
									</td>
								</tr>
							`;
							tbody.append(tr);								
						}
					});	
				}
			},
			error:console.log
		});
	};
	
	/* 시간선택 Modal  */
	function timeModal(){
		let tableId = $("[name=tb-select]:checked").data('table-id');
		let reqDate = $("#selectDate").val();
		let reqMonth = $("#resMonth").val();
		let reqYear = $("#resYear").val();
		
		let dateVal = `\${reqYear}-\${reqMonth}-\${reqDate}`;
		
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/selectOneTable/getReservationTime',
			data:{
				tableId: tableId,
				date: dateVal
			},
			success(res){
				$("#time-select tbody").empty();
				$("#time-select thead").empty();
				
				let nowDate = new Date();
				let nowHours;
				let nowMinutes;
				if(nowDate.getHours() < 10){
					nowHours = `0\${nowDate.getHours()}`; 
				} else{
					nowHours = nowDate.getHours();
				}
				if(nowDate.getMinutes() < 10){
					nowMinutes = `0\${nowDate.getMinutes()}`;
				} else{
					nowMinutes = nowDate.getMinutes();
				}
				
				let nowDateSet = `\${nowHours}:\${nowMinutes}`;
				if(res == ''){
					$("#time-select tbody").append("예약 가능한 시간대가 존재하지 않습니다.");
				} else{
					const th = `
						<tr>
							<th width="10%">선택</th>
							<th width="20%">시작시간</th>
							<th width="20%">종료시간</th>
							<th width="20%">상태</th>
						</tr>
					`;
					$("#time-select thead").append(th);
					
					$.each(res, (i, e) => {
						let status = e.status;
						let disabled = 'disabled';
						if(e.status == null){
							status = '';
							disabled = '';
						}
						let tr = `
							<tr>
								<td>
									<input type="radio" name="time-select" \${disabled}/>
								</td>
								<td>\${e.startTime}</td>
								<td>\${e.endTime}</td>
								<td>\${status}</td>
							</tr>
						`;
						let bool = (nowDate.getMonth()+1 >= reqMonth) && (nowDate.getDate() >= reqDate) && (nowDateSet >= e.startTime);
						console.log(!bool);
						if(!bool){
							$("#time-select tbody").append(tr);
						}
					});				
				}		
			},
			error:console.log
		});
	};
	
	function submitRequest(){
		let reqDate = $("#selectDate").val();
		let reqMonth = $("#resMonth").val();
		let reqYear = $("#resYear").val();
		let dateVal = `\${reqYear}-\${reqMonth}-\${reqDate}`;
		let submitDate = new Date(dateVal);
		
		let userId_ = '${loginMember.id}';
		let reservationDate_ = submitDate;
		let tableId_ = $("[name=tb-select]:checked").data('table-id');
		let startTime_ = $("[name=time-select]:checked").parent().next().text();
		let endTime_ = $("[name=time-select]:checked").parent().next().next().text();
		let visitors_ = $("[name=visitors]").val();
		let reqOrder_ = $("[name=req_order]").val();
		let allowVisitor = $(`#allowVisitor\${tableId_}`).val();
		
		let data = {
				reservationUser: userId_,
				reservationTableId: tableId_,
				reservationDate: reservationDate_,
				shopId: '${shopInfo.id}',
				timeStart: startTime_,
				timeEnd: endTime_,
				visitorCount: visitors_,
				reqOrder: reqOrder_
		};
		
		let jsonData = JSON.stringify(data);
		
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/reservation/insert?${_csrf.parameterName}=${_csrf.token}',
			method: 'POST',
			data: jsonData,
			contentType: "application/json; charset=utf-8",
			success(res){
				alert(res);
			},
			complete(){
				if(confirm("등록한 예약을 확인하시겠어요?")){
					location.href = '${pageContext.request.contextPath}/member/memberSetting/myReservationList';
				} else {
					window.location.reload();
				};
			},
			error: console.log
		})
	}
	
</script>
<style>
#calendarTable {
    margin: auto;
    width: 250px;
}
</style>