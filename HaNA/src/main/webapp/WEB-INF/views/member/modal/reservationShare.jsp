<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reservationShare/reservationShare.css" />
<script>
let ShareroomNo;
let Sharetoday = Date.now()-(9 * 60 * 60 * 1000);

let sharmembers ='';
//이건 모달 닫히면 append한거 지우고 button value초기화
$(document).ready(function(){       
    $('#shareModal').on('hide.bs.modal', function () {
    	sharmembers ='';
    	$("table#selectListTable tbody").empty();
    	$("#sharbutton").css("display","none").val('');
    });
 
});
</script>

<div class="modal fade" id="shareModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">공유하기</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<!-- <input type="text" name="friendId" id="" /> -->
				
				<!-- CSS INPUT -->
				<div class="form__group field">
				  <input type="text" class="form__field" placeholder="user id" name="friendId" id='name' required />
				  <label for="name" class="form__label">공유할 친구를 조회하세요</label>
				</div>
				<!-- CSS INPUT END -->
				
				<table id="acceptedFriendListTable">
					<tbody>
					</tbody>
				</table>
				<hr />
				<table id="friendListTable">
					<tbody></tbody>
				</table>
				<table id="selectListTable">
					<thead>
						<tr>
							<th><span id="hiddenSpan" style="display:none">선택한 친구 목록입니다.</span></th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
				<button style="display: none" id="sharbutton" onclick="shareReservation(this.value)">공유하기</button>
				<input type="hidden" name="shareReservationNo" />
				<input type="hidden" name="shareVisitorCount" />
			</div>
			<!-- footer -->
		</div>
	</div>
</div>

<script>
function shareReservationModal(reservationNo, visitorCount){
	$("[name=shareVisitorCount]").val(visitorCount);
	$("[name=shareReservationNo]").val(reservationNo);
	$("[name=friendId]").val('');
	$("#friendListTable tbody").empty();
	selectAcceptedFriends(reservationNo);
	console.log("shareReservationModal maxUser = ",visitorCount);
	console.log("shareReservationModal maxUser-1 = ",visitorCount-1);
	$('#shareModal').modal({backdrop:'static', keyboard:false});
};

function selectAcceptedFriends(reservationNo){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectAcceptedFriends',
		data:{
			reservationNo
		},
		success(res){
			$("#acceptedFriendListTable tbody").empty();		
			$.each(res, (i, e) => {
				if(e.id != '${loginMember.id}'){
					let tr = `
						<tr>
							<td width="30%">
								<img src="${pageContext.request.contextPath}/resources/upload/member/profile/\${e.picture}" alt="" style="width:50px;height:50px;border-radius:100%"/>
							</td>
							<td width="40%">
								<span class="sharedFr">\${e.id}</span>
							</td>
							<td width="30%">
								공유완료
							</td>
						</tr>
					`;					
					$("#acceptedFriendListTable tbody").append(tr);				
				}
			});
		},
		error:console.log
	});	
};

function onOpenShare() {
	    const data = {
	    	"roomNo" : ShareroomNo,
	        "memberId" : `${loginMember.id}`,
	        "message" : "ENTER" 
	    };
	    let jsonData = JSON.stringify(data);
	    websocket.send(jsonData);
}
//targetUser
function shareReservation(reservationNo){
	let maxUser = $("[name=shareVisitorCount]").val();
	let countFr = selectAcceptedFriendsForCheck(reservationNo);
	
	let countNum = 0;
	$.each(countFr, (a, b) => {
		countNum += 1;
	});

	console.log("countNum = ", countNum);
	if(countNum >= maxUser){
		alert("예약 인원만큼 공유됨");
		return false;
	};
	/* 요청 필요 데이터 */
 	const testtest=(targetUser)=>{
		$.ajax({
			url:`${pageContext.request.contextPath}/chat/shareReservation.do`,
			data:{
				id : `${loginMember.id}`,
				reservationNo : reservationNo,
				targetUser : targetUser
			},
			method: "GET",
			success(resp){
				//채팅방 번호를 전역변수에 넣음
				ShareroomNo = resp;
				connect(2);
				//웹소켓 접속을 하고 websocket.send를 보내야하는데 비동기라 send가 먼저 작동돼서 1초뒤 send되게
 				 setTimeout(function() {
					    const data = {
					            "roomNo" : ShareroomNo,
					            "memberId" : `${loginMember.id}`,
					            "message"   : `share115@${loginMember.id}님이 예약을 공유했습니다.@\${reservationNo}`,
					            "picture" : `${loginMember.picture}`,
					            "messageRegDate" : Sharetoday
					        }; 				    
					    let jsonData = JSON.stringify(data);
					    websocket.send(jsonData);
					    websocket.close();
					    connect(1);
				 },1000);
				
			},
			error: console.log
		}); 

	};
//전역변수에 담긴 id들 반복문통해서 보내주기
//바로 보내면 웹소켓 오류떠서 여기2초 웹소켓보내기 함수에서 1초 총 3초에 한번씩 보냄
	let sharmembersSplit = sharmembers.split(",");
	let delay = 0;
	$.each(sharmembersSplit, (i, b) => {
		delay += 2000;
	    setTimeout(async () => {
			//전역변수에 담긴게 abcde,yeseong, 이런식이라 split한값이 있을때만 보내기
			if(sharmembersSplit[i] !== ''){
				console.log("reservationNo =",reservationNo);
				testtest(sharmembersSplit[i],reservationNo);
				console.log("gdgdgdgd");
				console.log("ggggg",sharmembersSplit[i]);				
			}
			else{
				
			}

		    }, delay);
	});

    $('#shareModal').modal('hide');
    alert("공유 완료\n공유 요청 메시지가 전송되었습니다.");
};

//더치페이 웹소켓 전송
const Dutchtest22=(targetUser,reservationNo)=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/shareReservation.do`,
		data:{
			id : `${loginMember.id}`,
			reservationNo : reservationNo,
			targetUser : targetUser
		},
		method: "GET",
		success(resp){
			//채팅방 번호를 전역변수에 넣음
			ShareroomNo = resp;
			connect(2);
			//웹소켓 접속을 하고 websocket.send를 보내야하는데 비동기라 send가 먼저 작동돼서 1초뒤 send되게
				 setTimeout(function() {
				    const data = {
				            "roomNo" : ShareroomNo,
				            "memberId" : `${loginMember.id}`,
				            "message"   : `share510@${loginMember.id}님이 더치페이를 요청했습니다.@\${reservationNo}`,
				            "picture" : `${loginMember.picture}`,
				            "messageRegDate" : Sharetoday
				        }; 				    
				    let jsonData = JSON.stringify(data);
				    websocket.send(jsonData);
				    websocket.close();
				    connect(1);
			 },1000);
			
		},
		error: console.log
	}); 

};
//여러명 보내기 위해 기존 바로 공유하기에서 선택으로 modal에 append하구 append할때마다 전역변수에 값 추가
//선택하면 공유모달 밑에 append
const modalAppendshareMember = (reservationNo,targetUser) => {
	console.log("reservationNo = ",reservationNo);
	//전역변수에 값 +=
	sharmembers += targetUser+",";
	let append = `<tr>
		<td>\${targetUser}</td>
		</tr>`;
	
	//선택한 친구 append하기
	$("table#selectListTable tbody").append(append);
	
	// hiddenspan 보여주기
	$("#hiddenSpan").css("display", "");
	// 선택한 공유하기 버튼 보여주기
	$("#sharbutton").css("display","").val(reservationNo);
	
};

function selectAcceptedFriendsForCheck(reservationNo){
	let returnVal;
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectAcceptedFriends',
		data:{
			reservationNo
		},
		async: false,
		success(res){
			returnVal = res;
		},
		error:console.log
	});
	return returnVal;
}
///* <input type="button" value="공유하기" onclick="shareReservation('\${resNo}', '\${e.id}');"/> */
$("[name=friendId]").keyup((e) => {
 	$.ajax({
		url: '${pageContext.request.contextPath}/member/followingListById',
		data:{
			inputText: $(e.target).val()
		},
		success(res){
			let resNo = $("[name=shareReservationNo]").val();
			$("#friendListTable tbody").empty();
			$.each(res, (i, e) => {
				let tr = `
					<tr>
						<td width="30%">
							<img src="${pageContext.request.contextPath}/resources/upload/member/profile/\${e.pic}" alt="" style="width:50px;height:50px;border-radius:100%"/>
						</td>
						<td width="40%">\${e.id}</td>
						<td width="30%">
							<a href="#" class="bn62" onclick="modalAppendshareMember('\${resNo}','\${e.id}');">
							  선택
							</a>
						</td>
					</tr>
				`;
				
				let reservationNo = $("[name=shareReservationNo]").val();
				
				let frList = selectAcceptedFriendsForCheck(reservationNo);
				let bool = true;
				$.each(frList, (a, b) => {
					if(e.id == b.id){
						bool = false;
					}
				});
				if(bool){
					$("#friendListTable tbody").append(tr);
				};
			});
			if($(e.target).val() == ''){
				$("#friendListTable tbody").empty();
			}
		},
		error: console.log
	});
})

</script>