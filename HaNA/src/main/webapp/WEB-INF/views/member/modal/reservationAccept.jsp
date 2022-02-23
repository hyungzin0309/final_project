<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reservationShare/reservationAccept.css" />

<div class="modal fade" id="resAcceptModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">예약 상세보기</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<table id="resDetailTable">
					<thead>
						<tr>
							<th>예약일</th>
							<th>예약시간</th>
							<th>매장</th>
							<th>인원</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
				</table>
			</div>
			<!-- footer -->
			<div class="modal-footer">

			</div>
		</div>
	</div>
</div>

<script>
/* 예약 수락 시 모달 띄우기 */
function reservationSet(resNo){
	console.log(resNo);
	setReservationDetail(resNo, '${loginMember.id}');
	$('#resAcceptModal').modal({backdrop:'static', keyboard:false});
}

function setReservationDetail(resNo, id){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectOneReservation',
		data: {
			reservationNo: resNo,
			id
		},
		success(res){
 			$("#resDetailTable tbody").empty();
			
			let date = new Date(res.reservation.reservationDate);
			let tr = `
				<tr>
					<td width="20%">\${date.getFullYear()}-\${date.getMonth()+1}-\${date.getDate()}</td>
					<td width="25%">\${res.reservation.timeStart} ~ \${res.reservation.timeEnd}</td>
					<td width="15%">
						<a href="${pageContext.request.contextPath}/member/shopView/\${res.reservation.shopId}">
							\${res.reservation.shopId}
						</a>
					</td>
					<td width="10%">\${res.reservation.visitorCount}</td>
					<td width="15%">\${res.reservation.reservationStatus}</td>
				</tr>
			`;
			
			$("#resDetailTable tbody").append(tr);
			
			let btns = `
				<button class="btn acceptReq" onclick="reservationAccept('\${res.reservation.reservationNo}', '${loginMember.id}', 'Y')">수락</button>
				<button class="btn refuceReq" onclick="reservationAccept('\${res.reservation.reservationNo}', '${loginMember.id}', 'N')">거절</button>	
			`;
			
			$(".modal-footer").text('');
			
			if(res.checkRes == null){
				$(".modal-footer").append(btns);
			} else if(res.checkRes.attendUser == '${loginMember.id}' && res.checkRes.reqAccept == 'Y'){
				$(".modal-footer").append("수락한 예약 입니다.");
			} else if(res.checkRes.attendUser == '${loginMember.id}' && res.checkRes.reqAccept == 'N'){
				$(".modal-footer").append("거절한 예약 입니다.");
			};
		},
		error:console.log
	});
};

function reservationAccept(resNo, id, reqAccept){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/insertReservationShare?${_csrf.parameterName}=${_csrf.token}',
		method: 'POST',
		data:{
			reservationNo : resNo,
			attendUser : id,
			reqAccept
		},
		success(res){
			if(reqAccept == 'Y'){
				if(res == 1){				
					if(confirm("수락되었습니다.\n등록한 예약을 확인하시겠어요?")){
						location.href = '${pageContext.request.contextPath}/member/memberSetting/myReservationList';
					}
					$("#resAcceptModal").modal('hide');
				}				
			} else {
				if(res == 1){
					alert("거절되었습니다.");
					$("#resAcceptModal").modal('hide');
				}
			};
		},
		error:console.log
	})
}
</script>