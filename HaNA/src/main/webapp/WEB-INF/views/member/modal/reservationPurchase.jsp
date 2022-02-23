<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reservationPurchase/reservationPurchase.css" />
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<div class="modal fade" id="resPurchaseModal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
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
				<div style="text-align:center;width:100%;">
					<h4>* 금액 결제 완료 시 예약이 확정됩니다.</h4>
					<br />
					<span>결제 금액은 </span><span id="purchaseAmount"></span><span>원 입니다.</span>
				</div>
				<br />
				<div class="purchaseAll">
					<input type="button" class="req-Btn" value="전체금액 한번에 결제하기" id="req-pay-All" onclick="resAll();"/>
				</div>
				<div class="dutchpay">
					<input type="button" class="req-Btn" value="공유 인원에게 더치페이 요청하기" id="req-pay-Each" onclick="requestDutchpay();"/>
				</div>
				<input type="hidden" name="req-pay-rs-no" />
			</div>
			<!-- footer -->
			<div class="modal-footer">

			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="resPurchaseModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">더치페이</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<div class="dutchTitle">
					<h4>총 결제금액에서 1/N만큼만 결제됩니다.</h4>
					<span>결제금액은 </span><span id="dutchAmount"></span><span>원 입니다. </span>
				</div>								
				<input type="button" class="req-Btn" value="결제하기" onclick="resDutchpay();"/>
			</div>
			<!-- footer -->
			<div class="modal-footer">

			</div>
		</div>
	</div>
</div>


<script>
function purchaseModal(reservationNo, reservationUser, reqDutchpay){
	if('${loginMember.id}' == reservationUser && reqDutchpay == 'N'){
		$("[name=req-pay-rs-no]").val(reservationNo);
		getPrice(reservationNo, 'all');
		$('#resPurchaseModal1').modal({backdrop:'static', keyboard:false});
	} else if(reqDutchpay == 'Y'){
		$("[name=req-pay-rs-no]").val(reservationNo);
		getPrice(reservationNo, 'dutch');
		$('#resPurchaseModal2').modal({backdrop:'static', keyboard:false});
	};
};

/* 총 결제금액 가져오기 */
function getPrice(reservationNo, type){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/getPrice',
		data:{
			reservationNo
		},
		success(res){
			console.log(res);
			if(type == 'all'){
				$("#purchaseAmount").text(res.price);
			} else {
				let priceByVisitors = Math.floor(res.price / res.visitors);
				$("#dutchAmount").text(priceByVisitors);
			}
		},
		error: console.log
	});
}

/* 더치페이 요청보내기 */
function requestDutchpay(){
	let resNo = $("[name=req-pay-rs-no]").val();
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/updateReqDutchpay',
		method: 'POST',
		data:{
			reservationNo: resNo,
			status: 'Y'
		},
		success(res){
			console.log(res);
			
			//공유된 회원 불러오기
 				$.ajax({
				url: '${pageContext.request.contextPath}/shop/selectAcceptedFriends',
				data:{
					reservationNo: resNo
				},
				success(resp){
					console.log(resp);
					//공유된 회원 불러와서 나를 제외한 회원에게 더치페이 메세지 보내기
					//이것도 여기2초 더치페이 메세지 보내기 함수에서 1초 총 3초에 한번씩 보냄
					let delay = 0;
					$.each(resp, (a, b) => {
						delay += 2000;
					    setTimeout(async () => {
						if(b.id !==`${loginMember.id}`){
						Dutchtest22(b.id,resNo);
						}

						    }, delay);
					});
					alert("더치페이 전송 완료!");
					$("#resPurchaseModal1").modal("hide");
					//2명이면 6초 3명이면 9초 다~~보내고 +0.5초 후 reload시킴
					delay += 500;
 					setTimeout(function() {
						location.reload(); 
					},delay);
				},
				error:console.log
					
				}); 
			
			
/*  			if(res == 1){
				alert("요청이 전송되었습니다.");			
			};  */
		},
		error: console.log
	});
};

/* 더치페이 결제*/
function resDutchpay(){
	console.log($("[name=req-pay-rs-no]").val());
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectPriceAndVisitors',
		data:{
			reservationNo : $("[name=req-pay-rs-no]").val()
		},
		success(res){
			console.log(res);
			let myPrice;
 			let name;
			let id;
			let address;
			let reservationNo = $("[name=req-pay-rs-no]").val();
			let purchaseType = 'dutch';
			
			$.each(res, (i, e) => {
				if('${loginMember.id}' == e.ATTEND_USER){
					name = e.NAME;
					id = e.ID;
					address = e.ADDRESS_ALL;
					
					let attendCount = res.length;
					let eachPrice = Math.floor(e.ORIGINALPRICE / attendCount);
					
					/* 금액 계산, 마지막사람이 잔액몰빵하기 */
					if(e.RESTPRICE - eachPrice <= 10 && e.RESTPRICE > eachPrice){
						myPrice = e.RESTPRICE;
					} else {
						myPrice = eachPrice;
					}
				};
			});
			requestPay(myPrice, name, id, address, reservationNo, purchaseType);
		},
		error:console.log
	})
};

/* 단일 결제 */
function resAll(){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectPriceAndMember',
		data:{
			reservationNo : $("[name=req-pay-rs-no]").val(),
			id : '${loginMember.id}'
		},
		success(res){
			console.log(res);
			let myPrice = res.ORIGINALPRICE;
 			let name = res.NAME;
			let id = res.ID;
			let address = res.ADDRESS_ALL;
			let reservationNo = $("[name=req-pay-rs-no]").val();
			let purchaseType = 'all';
			
			requestPay(myPrice, name, id, address, reservationNo, purchaseType);
		},
		error:console.log
	})
};

//카카오페이 연동
var IMP = window.IMP; 
IMP.init("imp00307901");

function requestPay(price, name, id, address, reservationNo, purchaseType) {
	const date = new Date();
	let day = String(date.getDate());
	let hours = String(date.getHours());
	let minute = String(date.getMinutes());
	let second = String(date.getSeconds());
	
	const totalPrice = price;
	
    // IMP.request_pay(param, callback) 결제창 호출
    IMP.request_pay({ // param
        pg: "kakaopay",
        pay_method: "kakaopay",
        merchant_uid: reservationNo + day+hours+minute+second,
        name: "예약금 결제",
        amount: totalPrice,
        buyer_email: id,
        buyer_name: name,
        buyer_tel: "abcd",
        buyer_addr: address,
        buyer_postcode: "010101"
    }, function (rsp) { // callback
        if (rsp.success) {
        	const impUid = rsp.imp_uid;
        	const merchantUid = rsp.merchant_uid;
        	let amount = totalPrice;
        	$.ajax({
        		url: "${pageContext.request.contextPath}/purchase/payments",
        		method: "POST",
        		dataType: "json",
        		data: {
        			impUid,
            		merchantUid,
            		amountToBePaid: amount
        		},
        		success(data){
        			alert(data.msg);
        			addPurchaseHistory(id, impUid, merchantUid, amount);
        			/* 결제후 처리 */
        			if(purchaseType == 'dutch'){
        				purchaseAsDutchpay(reservationNo, id, amount);
        			} else if(purchaseType == 'all'){
        				purchaseAll(reservationNo, amount);
        			}
        		},
        		error : console.log
        	});
        } else {
            alert("결제 실패")
            // 결제 실패 시 로직, 
        }
    });
  }
  
function addPurchaseHistory(id, impUid, merchantUid, amount){
	let dataObj = {
			"id" : id,
			"uid" : impUid,
			"merchantUid" : merchantUid,
			"amount" : amount
	};	
	let dataStr = JSON.stringify(dataObj);

	
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/insertPurchaseHistory?${_csrf.parameterName}=${_csrf.token}',
		method: 'POST',
		data: dataStr,
		contentType: "application/json; charset=utf-8",
		success(res){
			console.log(res);
			if(res == 1){
				console.log("결제 내역 등록됨");
			}
		},
		error:console.log
	});
};

function purchaseAsDutchpay(reservationNo, id, amount){
	let dataObj = {
			"reservationNo" : reservationNo,
			"id" : id,
			"amount" : amount
	};
	let dataStr = JSON.stringify(dataObj);
	
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/purchaseAsDutchpay?${_csrf.parameterName}=${_csrf.token}',
		method: 'POST',
		data: dataStr,
		contentType: "application/json; charset=utf-8",
		success(res){
			console.log(res);
		},
		error:console.log,
		complete: function(){
			location.reload();
		}
	})
};

function purchaseAll(reservationNo, amount){
	let dataObj = {
			"reservationNo" : reservationNo,
			"amount" : amount
	};
	let dataStr = JSON.stringify(dataObj);
	
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/purchaseAll?${_csrf.parameterName}=${_csrf.token}',
		method: 'POST',
		data: dataStr,
		contentType: "application/json; charset=utf-8",
		success(res){
			console.log(res);
		},
		error:console.log,
		complete: function(){
			location.reload();
		}
	})
}
</script>