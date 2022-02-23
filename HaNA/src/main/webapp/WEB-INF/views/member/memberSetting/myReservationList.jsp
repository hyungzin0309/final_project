<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="설정화면" name="memberSetting/"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/reservationList/reservationList.css" />
<section>
<sec:authentication property="principal" var="loginMember"/>

<c:if test="${not empty msg}">
	<script>
		$(() => {
			alert("${msg}");
		})
	</script>	
</c:if>



<br><br><br> 
<div class="container resContainer">
    <div class="row" id="resRow">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-4" id="leftSideList">
        	<ul class="list-group">
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/memberSetting'">프로필 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/updatePassword'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/accountPrivate'">계정 공개</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/memberSetting/myReservationList'">내 예약내역</li>
			</ul>
        </div>
        
		<div id="res-container" class="mx-auto text-center">
        	<div class="myResHeader">
				<h1>나의 예약내역</h1>
			</div>
			
		    <div class="row">   
		        <!-- 탭 영역 -->
		        <div class="col-sm-12 nav nav-pills nav-fill" id="tab">   	
				  <div class="col-sm-6 nav-item d-flex justify-content-center align-items-center">
				    <a class="nav-link active" href="#" id="presentList">예약 내역</a>
				  </div>
				  <div class="col-sm-6 nav-item d-flex justify-content-center align-items-center">
				    <a class="nav-link" href="#" id="pastList">지난 내역</a>
				  </div>
		        </div>
		    </div>
			<div class="row">
				<!-- table 영역 -->
					<div class="myResListArea">
						<table id="myReservationTable">
							<thead>
		
							</thead>
							<tbody></tbody>
						</table>
		
						<div class="pageBar"></div>
					</div>
			</div>
			
        </div>
    </div>
</div>

<script>
	$(() => {
		myPresentReservation(1);
	});
	/* calendar 노출 event */
	$("#myResCalendarBtn").click((e) => {
		$(".myResCalendar").toggle();
	});
	
	/* 일자별 list 불러오기 func */
	function setDate(e){
		$("#selectDate").val(e);
		$(".dateBtn").css('background-color', '#ffffff');
		$(`#dateBtn\${e}`).css('background-color', 'green');
	}
	
	/* 예약내역/지난내역 tab별 노출 list func */
	$("#presentList").click((e) => {
		myPresentReservation(1);
		$(e.target).addClass("active");
		$("#pastList").removeClass("active");
	});
	$("#pastList").click((e) => {
		myPastReservation(1);
		$(e.target).addClass("active");
		$("#presentList").removeClass("active");
	});
	
	/* 현재 이후 일자별 예약 내역 ajax */
	/* state : 1 - 현재+미래, 0 - 과거 */
	function myPresentReservation(cPage){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/myReservation',
 			data:{
 				state: '1',
				func: 'myPresentReservation',
				cPage
			},
			success(res){
				let date = new Date();
				let month = date.getMonth()+1;
				let date_ = date.getDate();
				let hours;
				let minutes;
				if(date.getHours() < 10){
					hours = `0\${date.getHours()}`;
				} else {
					hours = date.getHours();
				};
				if(date.getMinutes() < 10){
					minutes = `0\${date.getMinutes()}`;
				} else {
					minutes = date.getMinutes();
				}
				
				let dateSet = `\${hours}:\${minutes}`;
				
				$("#myReservationTable tbody").empty();
				$("#myReservationTable thead").empty();
				$(".pageBar").text('');
				let thead = `
					<tr>
						<th width="10%">예약일</th>
						<th width="15%">업체</th>
						<th width="10%">테이블</th>
						<th width="13%">시간</th>
						<th width="5%">인원</th>
						<th width="20%">요청사항</th>
						<th width="10%">상태</th>
						<th width="5%">공유하기</th>
						<th width="5%">결제하기</th>
						<th width="5%">취소하기</th>
					</tr>
				`;
				$("#myReservationTable thead").append(thead);
				$.each(res.myList, (i, e) => {
					let resDate = new Date(e.reservationDate);
					let tr = `
						<tr>
							<td>\${resDate.getFullYear()}-\${resDate.getMonth()+1}-\${resDate.getDate()}</td>
							<td>
								<a href="${pageContext.request.contextPath}/member/shopView/\${e.shopId}">\${e.shopName}(\${e.shopId})</a>
							</td>
							<td>
								\${e.tableName}
							</td>
							<td>\${e.timeStart} ~ \${e.timeEnd}</td>
							<td>
								<a href="#" onclick="showShareUserModal('\${e.reservationNo}')">\${e.visitorCount}명</a>
							</td>
							<td>
								\${e.reqOrder}
							</td>
							<td>\${e.reservationStatus}</td>
							<td>
								<input type="button" value="공유" class="shareResBtn res-list-btnArea" data-rs-no="\${e.reservationNo}" onclick="shareReservationModal('\${e.reservationNo}', '\${e.visitorCount}');"/>
							</td>
							<td>
								<input type="button" value="결제" class="purchaseResBtn res-list-btnArea" data-rs-no"\${e.reservationNo}" onclick="purchaseModal('\${e.reservationNo}', '\${e.reservationUser}', '\${e.reqDutchpay}')"/>
							</td>
							<td>
								<input type="button" value="취소" class="cancleResBtn res-list-btnArea" data-rs-no="\${e.reservationNo}" onclick="cancleReservation('\${e.reservationNo}');"/>
							</td>
						</tr>
					`;
					$("#myReservationTable tbody").append(tr);
					let userBool = e.reservationUser != '${loginMember.id}';
					let statusBool = e.reservationStatus == '예약취소';
					let timeBool = dateSet >= e.timeStart && month == resDate.getMonth()+1 && date_ == resDate.getDate();
					if(userBool || timeBool || statusBool){
						$("#myReservationTable tbody").find(".shareResBtn:last").prop('disabled', 'true');
						$("#myReservationTable tbody").find(".cancleResBtn:last").prop('disabled', 'true');
					};
					if(userBool || timeBool && statusBool){
						$("#myReservationTable tbody").find(".cancleResBtn:last").prop('disabled', 'true');
					};
					if(statusBool){
						$("#myReservationTable tbody").find(".cancleResBtn:last").prop('disabled', 'true');
					}
					let dutchBool = e.reqDutchpay == 'Y';
					let myResBool = e.reservationUser == e.attendUser;
					
					let lastBool = !dutchBool && !myResBool;
					if(lastBool || timeBool || statusBool){
						$("#myReservationTable tbody").find(".purchaseResBtn:last").prop('disabled', 'true');
					}
					
					/* 더치페이 본인몫 결제완료 시(S), 결제 비활성화, 공유버튼 비활성화 */
					if(e.reqDutchpay == 'S'){
						$("#myReservationTable tbody").find(".purchaseResBtn:last").prop('disabled', 'true');
						$("#myReservationTable tbody").find(".shareResBtn:last").prop('disabled', 'true');
					}
					
					/* 더치페이 요청 후 공유버튼 비활성화 */
					if(e.reqDutchpay == 'Y'){
						$("#myReservationTable tbody").find(".shareResBtn:last").prop('disabled', 'true');
					}
					
					/* 예약완료인 경우 공유, 결제 비활성화 */
					if(e.reservationStatus == '예약완료'){
						$("#myReservationTable tbody").find(".shareResBtn:last").prop('disabled', 'true');
						$("#myReservationTable tbody").find(".purchaseResBtn:last").prop('disabled', 'true');
					}
				});
				
				$(".pageBar").append(res.pageBar);
			},
			error: console.log
		});

	};
	
	/* 과거내역 */
	function myPastReservation(cPage){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/myReservation',
 			data:{
 				state: '0',
				func: 'myPastReservation',
				cPage
			},
			success(res){
				$("#myReservationTable tbody").empty();
				$("#myReservationTable thead").empty();
				$(".pageBar").text('');
				let thead = `
					<tr>
						<th>예약일</th>
						<th>업체</th>
						<th>테이블</th>
						<th>시간</th>
						<th>인원</th>
						<th>후기 작성</th>
					</tr>
				`;
				$("#myReservationTable thead").append(thead);
				$.each(res.myList, (i, e) => {
					let resDate = new Date(e.reservationDate);
					let tr = `
						<tr>
							<td>\${resDate.getFullYear()}-\${resDate.getMonth()+1}-\${resDate.getDate()}</td>
							<td>
								<a href="${pageContext.request.contextPath}/member/shopView/\${e.shopId}">\${e.shopName}(\${e.shopId})</a>
							</td>
							<td>
								\${e.tableName}
							</td>
							<td>\${e.timeStart} ~ \${e.timeEnd}</td>
							<td>
								<a href="#" onclick="showShareUserModal('\${e.reservationNo}')">\${e.visitorCount}명</a>
							</td>
							<td>
								<input type="button" value="작성" class="reviewBtn res-list-btnArea" data-rs-no="\${e.reservationNo}" onclick="enrollReview('\${e.reservationNo}')"/>
							</td>
						</tr>
					`;
					$("#myReservationTable tbody").append(tr);
					if(e.reviewStatus == 'Y'){
						$("#myReservationTable tbody").find(".reviewBtn:last").prop('disabled', 'true');
					};
					/* 후기 작성완료 시 상태 변경 */
					if(e.reviewStatus == 'S'){
						$("#myReservationTable tbody").find(".reviewBtn:last").prop('disabled', 'true');
						$("#myReservationTable tbody").find(".reviewBtn:last").val('완료');
					};
					/* 예약 완료가 아닌 경우 상태 변경 */
					if(e.reservationStatus == '예약취소' || e.reservationStatus == '예약대기'){
						$("#myReservationTable tbody").find(".reviewBtn:last").prop('disabled', 'true');
						$("#myReservationTable tbody").find(".reviewBtn:last").val('불가');
					}
				});
				$(".pageBar").append(res.pageBar);
			},
			error: console.log
		});
	};
	
	/* 예약 취소 : 본인에게만 취소 활성화 */
	function cancleReservation(reservationNo){
		console.log(reservationNo);
		if(!confirm('해당 예약을 취소하시겠습니까?')){
			return false;
		}
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/cancleReservation?${_csrf.parameterName}=${_csrf.token}',
			method: 'PUT',
			data: reservationNo,
			success(res){
				if(res == 1){
					alert("취소되었습니다.");
				} else {
					alert("취소 실패했습니다.");
				}
				location.reload();
			},
			error: console.log
		});
	};
</script>
<jsp:include page="/WEB-INF/views/member/modal/reservationShare.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/member/modal/reservationPurchase.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/member/boardModal/reviewModal.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/member/modal/shareUserModal.jsp"></jsp:include>

</section>
<style>
.list-group-item {
    position: relative;
    display: block;
    padding: 0.5rem 1rem;
    color: #212529;
    text-decoration: none;
    background-color: #fff;
    border: 1px solid rgba(0,0,0,.125);
    cursor: pointer;
    text-align: center;
}
.col-sm-4{
	width : 350px;
	margin-right: 100px;
	}
.col-sm-8 {
    flex: 0 0 auto;
    width: 550px;
    font-size:14px;
}
.list-group-item.active {
    z-index: 2;
    color: #fff;
    background-color: gray;
    border-color: gray;
}
</style>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>