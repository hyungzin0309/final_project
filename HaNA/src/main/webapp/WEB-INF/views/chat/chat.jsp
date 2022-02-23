<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="메인화면" name="main"/>
</jsp:include>
<!-- 인증객체의 principal속성을 pageContext 속성으로 저장 heaer에 선언되면 삭제하기-->
<%-- <sec:authentication property="principal" var="loginMember" /> --%>
<!--<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
<!-- <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css"> -->
<!-- <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script> -->

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/chat.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
#allMember{margin-left: 10%};
</style>
<sec:authorize access="isAuthenticated()">
<c:if test="${not empty msg}">
	<script>
		alert("${msg}");
	</script>
</c:if>
</sec:authorize>
<br /><br /><br />
<script>
let id;
let picture;
<sec:authorize access="isAuthenticated()">
	id = '<sec:authentication property="principal.id"/>';
	picture = '<sec:authentication property="principal.picture"/>';
</sec:authorize>
$(()=>{
	roomList();
	let temp = location.href.split("?");
 	if(temp[1] !== undefined){	
 	setTimeout(function() {
		roomchat(temp[1]);
	}, 1000);
	}
});

const roomList = () => {
	console.log(id);
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/roomList.do`,
		data:{
			id : id,
		},
		method: "GET",
		success(resp){
			displayRoom("#chatList", resp);
		},
	});
	<!-- 3초마다 -->
/* 	setTimeout(function() {
		roomList();	
	}, 3000); */
};
<!-- <span class="online_icon"></span> -->
const displayRoom = (selector, data) => {
	const $target = $(selector);
	let chatroom = ``
		
		if(data.length){
			$(data).each((i, room) => {
				/* console.log(i, room); */
				const {roomNo, roomName, roomType, members, groupImg} = room;
				
				$.ajax({
					url:`${pageContext.request.contextPath}/chat/roomUnreadChat.do`,
					method:'GET',
					data:{
						roomNo : roomNo,
						memberId : memberId,
					},
					success(data){
						if(data != null){
							console.log("dmAlarmvar =",headerdmAlarm);
							console.log("roomNo=",roomNo);
							console.log("data=",data);
 							window[memberId+roomNo] = data;
 							if(data !== 0)
								$(`#roomAlarm`+roomNo).text(window[memberId+roomNo]);
 								
							
						}
							
					},
					error:console.log
				});
				
				
				
				
				
				chatroom += `<div class="card-body contacts_body">
					<ui class="contacts">
					<li class="active">
						<div class="d-flex bd-highlight" id="chatroom">
							<div class="img_cont">
								<img src="\${roomType != 1 ? '../resources/upload/member/profile/' : '../resources/upload/group/profile/'}\${groupImg == null ? "":groupImg}" class="rounded-circle user_img">
							</div>
							<div class="user_info">
								<span>\${roomType != 1 ? members : roomName}방</span>
								<button type="button" class="btn btn-info" onclick="roomchat(this.value)" value="\${roomNo}">입장</button>
								<span class="badge" id="roomAlarm\${roomNo}"></span>
							</div>
						</div>
					</li>
					</ui>
				</div>`;
				
			});
		}
		else{
			chatroom += `<div class="card-body contacts_body">
				<ui class="contacts">
				<li class="active">
					<div class="d-flex bd-highlight" id="chatroom">
						<div class="img_cont">
							<img src="../resources/images/icons/eb13.jpg" class="rounded-circle user_img">
						</div>
						<div class="user_info">
							<span>소모임에 가입시 활성화</span>
						</div>
					</div>
				</li>
				</ui>
			</div>
			<div class="card-body contacts_body">
			<ui class="contacts">
			<li class="active">
				<div class="d-flex bd-highlight" id="chatroom">
					<div class="img_cont">
						<img src="../resources/images/duck2.jpg" class="rounded-circle user_img">
					</div>
					<div class="user_info">
						<span>친구와 채팅시 활성화</span>
					</div>
				</div>
			</li>
			</ui>
		</div>`;
		}
		
		$target.html(chatroom);
};
</script>

	<div class="container-fluid h-100">
			<div class="row justify-content-center h-100">
				<div class="col-md-4 col-xl-4 chat"><div class="card mb-sm-3 mb-md-0 contacts_card">
					<div class="card-header">
						<div class="input-group">
							<input type="text" placeholder="아이디 or 이름을 입력" id="findMemberInput" class="form-control search">
							<button type="button" class="btn btn-warning" id="allMember">친구목록</button>
						</div>
					</div>
					<div id="chatList">
					
					</div>
				</div></div>
				<div class="col-md-8 col-xl-6 chat">
					<div class="card">
						<div class="card-header msg_head" id="msgHeader">
						</div> 
						
						<!-- 채팅내용 -->
						<div class="card-body msg_card_body" id="roomchat1">

						</div>
 						<div class="card-footer" id="sendMsgBtn"></div>
								
						
					</div>
				</div>
				
			</div>
		</div>
	<!-- 친구목록 modal -->
	<div class="modal fade" id="memberlistModal" tabindex="-1" role="dialog"
		aria-labelledby="memberlistModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="memberlistModalLabel">회원목록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div id="modaldiv"></div>
			</div>
		</div>
	</div>
	<!-- Modal 끝-->
	
	<!-- 파일업로드 modal -->
	<div class="modal fade" id="fileuploadmodal" tabindex="-1" role="dialog"
		aria-labelledby="fileuploadmodal" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id=""fileupload"">사진 올리기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>			
				</div>
				<div>
				  <form id="uploadForm" enctype="multipart/form-data">
				  	<input type="file" id="fileUpload" />
				  </form>
					<button type="button" class="btn btn-primary"onclick="fileSend()" id="sendFileBtn">사진 올리기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Modal 끝-->
	
<!-- 채팅보내기 form -->
<form 
	action="${pageContext.request.contextPath}/chat/sendchat.do"
	name="sendchatFrm"
	method="GET">
	<input type="hidden" name="memberId"/>
	<input type="hidden" name="loginId"/>
</form>
<!-- 채팅 나가기 form -->

<form 
	action="${pageContext.request.contextPath}/chat/exitRoom.do"
	name="exitRoomFrm"
	method="GET">
	<input type="hidden" name="roomNo"/>
</form>

<script>
/* <!-- roomNo 전역변수 -->
let roomNo; */

<!-- 채팅방 선택하면 -->
function roomchat(no){
	console.log("No = ", no);
	$("#roomchat1").html("");
	roomNo = no;
if(websocket !== undefined){
		console.log("기존 연결 제거")
		websocket.close();
	}
	
	<!-- 채팅 헤더 -->
 	$.ajax({
		url:`${pageContext.request.contextPath}/chat/roomheader.do`,
		data:{
			id : id,
			no : no,
		},
		method: "GET",
		success(resp){
			console.log(resp);
			let header =``;
				$(resp).each((i, chatroom) => {
					const {roomNo, roomName, roomType, members, groupImg} = chatroom;
					
					header += `<div class="card-header msg_head">
						<div class="d-flex bd-highlight">
						<div class="img_cont">
							<img src="\${roomType != 1 ? '../resources/upload/member/profile/' : '../resources/upload/group/profile/'}\${groupImg == null ? "":groupImg}" class="rounded-circle user_img">
							<span class="online_icon"></span>
						</div>
						<div class="user_info">
							<span>\${roomType == 1 ? roomName : "Chat with "+members}</span>
						</div>
						<span id="action_menu_btn" onclick="actionMenu();"><i class="fas fa-ellipsis-v"></i></span>
						<div class="action_menu">
							<ul>
								<li onclick="closeChatRoom('\${roomType}');"><i class="fas fa-user-circle"></i>채팅방 나가기</li>
								<li onclick="closeBtn();"><i class="fas fa-ban"></i>대화창 나가기</li>
							</ul>
					</div>
				</div>`;
					
				});
				$("#msgHeader").html(header);
		},
		error:console.log
	});
 	
 	<!-- 채팅 메세지 -->
	$.ajax({
		url : `${pageContext.request.contextPath}/chat/roomchat.do`,
		data : {
			no : no,
			id : memberId
		},
		method: "GET",
		success(resp){
			console.log(resp);
			for(var i = 0; i < resp.length; i++){
				msgCheck(resp[i]);
			}
		},
		error:console.log
	});
  	console.log("roomNo=",roomNo);
	console.log("no=",no);
	console.log("memberIdroomNo=",window[memberId+no]);
	headerdmAlarm = headerdmAlarm-window[memberId+roomNo];
	window[memberId+roomNo] = 0;
	$(`#roomAlarm`+no).empty();
	$("#dmAlarm").text(headerdmAlarm);
		
	sendBtn();
	//connect(1);
	connect();
	
};

<!-- enter키 -->
const enterkey = () => {
	if (window.event.keyCode == 13) {
		$("#btnSend").trigger("click");
	}
};

<!-- 파일보내기 -->
function fileSend(){
	var file = $("#fileUpload")[0];
	console.log("filelength = ",file.files.length);
	
	if(file.files.length === 0){
		alert("파일을 선택해주세요");
		return;
	}
	
	const formData = new FormData();
	formData.append("image", file.files[0]);
	
    const csrfHeader = "${_csrf.headerName}";
	const csrfToken = "${_csrf.token}";
	const headers = {};
	headers[csrfHeader] = csrfToken;

	<!-- headers: headers, -->
	$.ajax({
		url : `${pageContext.request.contextPath}/chat/sendFile.do`,
		method:"POST",
		enctype: 'multipart/form-data',
	    processData: false,
	    contentType: false,
	    headers: headers,
		data: formData,
		success(file){
			console.log(file);
			
		    const data = {
		            "roomNo" : roomNo,
		            "memberId" : id,
		            "message"   : null,
		            "picture" : picture,
		            "messageRegDate" : today,
		            "fileImg" : file
		        };
		    msgCheck(data);
		    let jsonData = JSON.stringify(data);
		    websocket.send(jsonData);
			
			$(fileuploadmodal)
			.modal('hide'); 
		},
		error:console.log
	});
	
};
<!-- 파일 다운로드 -->
const downloadFile = (filename) => {
	if(confirm("파일을 다운로드 하시겠습니까?")){
		location.href = `${pageContext.request.contextPath}/chat/Filedownload.do?filename=\${filename}`;

	}
};
<!-- 메세지 전송 -->
const btnSend = () => {
	
	console.log("버튼클릭 roomNo = ",roomNo);
	if(websocket === undefined) {
		alert("채팅방을 선택하세요");
		$("textarea#msg").val('');
		return;
	}
	let msg = $("textarea#msg").val();
	if(msg == ''){
		alert("메세지를 입력하세요");
		return;		
	}
	
    const data = {
            "roomNo" : roomNo,
            "memberId" : id,
            "message"   : msg,
            "picture" : picture,
            "messageRegDate" : today
        };
    msgCheck(data);
    let jsonData = JSON.stringify(data);
    websocket.send(jsonData);
	
	//채팅메세지창 비우기
	$("textarea#msg").val('');
}

// 웹소켓
/* let websocket;
//입장 버튼을 눌렀을 때 호출되는 함수
function connect() {
    // 웹소켓 주소
    var wsUri = "ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/chat";
    // 소켓 객체 생성
    websocket = new WebSocket(wsUri);
    //웹 소켓에 이벤트가 발생했을 때 호출될 함수 등록
    websocket.onopen = onOpen;
    websocket.onmessage = onMessage;
    
} */
//웹 소켓에 연결되었을 때 호출될 함수
/* function onOpen() {
	console.log("onOpen roomNo = ", roomNo);
     const data = {
            "roomNo" : roomNo,
            "memberId" : id,
         "message" : "ENTER"
    };
    let jsonData = JSON.stringify(data);
    websocket.send(jsonData);
    console.log("opOpen");
} */
<!-- 메세지 수신 -->
/* function onMessage(e){
	let eSplit = e.data.split(",");

	const data = {
		"memberId" : eSplit[0],
		"message" : eSplit[1],
		"picture" : eSplit[2],
		"messageRegDate" : today,
		"fileImg" : eSplit[5]
	};
	console.log(data);
	if(data.memberId != id){
		msgCheck(data);
	}
} */
		
function msgCheck(e){
	const check = (e.memberId != id) ? "left" : "right";
	//displaychat(check, e.memberId, e.message);
	displaychat(check, e);
}
 

const displaychat = (check, e) =>{
	<!-- timestamp로 온거 messageRegDate 변환 -->
	const KR_TIME_DIFF = 9 * 60 * 60 * 1000;
	var date = new Date(e.messageRegDate+(KR_TIME_DIFF));
	var year = date.getFullYear().toString().slice(-2); //년도 뒤에 두자리
	var month = ("0" + (date.getMonth() + 1)).slice(-2); //월 2자리 (01, 02 ... 12)
	var day = ("0" + date.getDate()).slice(-2); //일 2자리 (01, 02 ... 31)
	var hour = ("0" + date.getHours()).slice(-2); //시 2자리 (00, 01 ... 23)
	var minute = ("0" + date.getMinutes()).slice(-2); //분 2자리 (00, 01 ... 59)

	var todayDate = new Date(today);
	var todayyear = todayDate.getFullYear().toString().slice(-2); //년도 뒤에 두자리
	var todaymonth = ("0" + (todayDate.getMonth() + 1)).slice(-2); //월 2자리 (01, 02 ... 12)
	var todayday = ("0" + todayDate.getDate()).slice(-2); //일 2자리 (01, 02 ... 31)

	var ampm = (hour > 12 ? "pm" : "am");
	if(hour > 12)
		hour = hour - 12;
	var returnDate = (todayyear+todaymonth+todayday === year+month+day ? "Today " : month+"월"+day+"일 ") + ampm+" " + hour + ":" + minute;

	let chat = ``
	
	/* console.log("fileImg check =", e.fileImg); */
	
	<!-- 파일전송시 (undefined) -->
	if(e.fileImg !== undefined){
		console.log("아ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ");
		if(check === 'right'){
			chat += `<div class="d-flex justify-content-end mb-4">
<div class="msg_cotainer_send">
<img src="../resources/upload/chat/chat/\${e.fileImg}" class="fileImgMessage" onclick="downloadFile('\${e.fileImg}')" style="cursor:pointer;">
<span class="msg_time_send">\${returnDate}</span>
</div>
<div class="img_cont_msg">
<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
</div>
</div>`;
	}
	else{
		chat += `<div class="d-flex justify-content-start mb-4">
			<div class="img_cont_msg">
			<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
		</div>
		<div class="msg_cotainer">
		<img src="../resources/upload/chat/chat/\${e.fileImg}" class="fileImgMessage" onclick="downloadFile('\${e.fileImg}')" style="cursor:pointer;">
			<span class="msg_time">\${returnDate}</span>
		</div>
	</div>`;
	}
		$("#roomchat1").append(chat);
		$("div#roomchat1").scrollTop($("div#roomchat1").prop("scrollHeight"));
		return
	}
	<!-- 여기까지 파일전송 시 뿌려주는 코드 -->
	
	let messageSplit = e.message.split("@");
	if(e.message === 'ROOMENTER'){
		
		chat += `<div class="d-flex justify-content-center mb-2">
			<div class="msg_cotainer_send">
			\${e.memberId}가 입장하셨습니다.
			</div>
			</div>`
	}
	else if(e.message === 'ROOMOUT' || e.message ==='ROOMOUT333'){
		chat += `<div class="d-flex justify-content-center mb-2">
			<div class="msg_cotainer_send">
			\${e.memberId}가 퇴장하셨습니다.
			</div>
			</div>`
	}
	
	//messageSplit[0]가 share115이라면 공유메세지
	else if(messageSplit[0] === 'share115'){
		if(check === 'right'){
		chat += `<div class="d-flex justify-content-end mb-4">
		<div class="msg_cotainer_send">
		\${messageSplit[1]}
		<span class="msg_time_send">\${returnDate}</span>
		</div>
		<div class="img_cont_msg">
		<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
		</div>
		</div>`;
	}
	else{
		chat += `<div class="d-flex justify-content-start mb-4">
			<div class="img_cont_msg">
			<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
		</div>
		<div class="msg_cotainer">
		\${messageSplit[1]} <button class="reservationModalBtn" onclick="reservationSet('\${messageSplit[2]}')">상세보기</button>
			<span class="msg_time">\${returnDate}</span>
		</div>
	</div>`;
	}
	}
	//messageSplit[0]가 share510이라면 더치페이메세지
	else if(messageSplit[0] === 'share510'){
		
		if(check === 'right'){
			chat += `<div class="d-flex justify-content-end mb-4">
			<div class="msg_cotainer_send">
			\${messageSplit[1]}
			<span class="msg_time_send">\${returnDate}</span>
			</div>
			<div class="img_cont_msg">
			<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
			</div>
			</div>`;
		}
		else{
			chat += `<div class="d-flex justify-content-start mb-4">
				<div class="img_cont_msg">
				<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
			</div>
			<div class="msg_cotainer">
			\${messageSplit[1]} <button class="" onclick="abcdefsdfsdfsdf('\${messageSplit[2]}')">더치페이</button>
				<span class="msg_time">\${returnDate}</span>
			</div>
		</div>`;
		}
		
	}	
	else{
	<!-- 일반 채팅 뿌려주기 -->
		if(check === 'right'){
				chat += `<div class="d-flex justify-content-end mb-4">
<div class="msg_cotainer_send">
\${e.message}
<span class="msg_time_send">\${returnDate}</span>
</div>
<div class="img_cont_msg">
<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
</div>
</div>`;
		}
		else{
			chat += `<div class="d-flex justify-content-start mb-4">
				<div class="img_cont_msg">
				<img src="../resources/upload/member/profile/\${e.picture}" class="rounded-circle user_img_msg">
			</div>
			<div class="msg_cotainer">
			\${e.memberId}: \${e.message}
				<span class="msg_time">\${returnDate}</span>
			</div>
		</div>`;
		}
	}
		
		$("#roomchat1").append(chat);
		$("div#roomchat1").scrollTop($("div#roomchat1").prop("scrollHeight"));
};
<!-- 친구찾기 -->
$("#findMember").on("click", function(e){
 	let msg = $("#findMemberInput").val();
	
	console.log("친구찾기 msg = ", msg);
	$("#findMemberInput").val('');
	
	$(memberlistModal)
	.modal();
});
//친구목록
$("#allMember").on("click", function(e){
	console.log("회원목록");
	console.log("내 아이디 = " , id);
	
	
 	$.ajax({
		url:`${pageContext.request.contextPath}/chat/memberList.do`,
		method: "GET",
		data: {loginId : id},
		success(resp){
			console.log(resp);
			let modal =``;
				$(resp).each((i, member) => {
					const {id, name, picture} = member;
					console.log(id,name,picture);
					modal += `<div><span><img src='../resources/upload/member/profile/\${picture}' class='rounded-circle user_img'/> 아이디 : \${id} 이름: \${name}</span><button onclick="chatsend(this.value)" value="\${id}">채팅</button></div>`;
					
				});
				$("#modaldiv").html(modal);
		},
		error:console.log
	});
	
	$(memberlistModal)
	.modal();
});
<!-- 친구 찾기 or 친구목록에서 채팅버튼 -->
const chatsend = (e)=> {
	console.log("memberId = ", e);
	console.log("loginId = ", id);
	
	$("[name=sendchatFrm] input[name=memberId]").val(e);
	$("[name=sendchatFrm] input[name=loginId]").val(id);
	$(document.sendchatFrm).submit();
	
  	 $(memberlistModal)
	.modal('hide');  
	
};
<!-- 채팅방 클릭시 메세지보내기 나오게 -->
const sendBtn = () => {
 	let sendHTML = ``;
 	sendHTML = `<div class="input-group">
<div class="input-group-append">
<span class="input-group-text attach_btn" onclick="filemodal();"><i class="fas fa-paperclip"></i></span>
</div>							
<textarea onkeyup="enterkey();" id="msg" class="form-control type_msg" placeholder="Type your message..."></textarea>
<div class="input-group-append">
<button onclick="btnSend();" id="btnSend" class="input-group-text send_btn"><i class="fas fa-location-arrow"></i></button>
</div>
</div>`; 
	$("#sendMsgBtn").html(sendHTML);
};

const filemodal = ()=>{
	$(fileuploadmodal).modal();
};

// X 버튼
const closeBtn = () => {
	$("#msgHeader").html('');
	$("#roomchat1").html('');
	$("#sendMsgBtn").html('');
	roomNo = null;
	websocket.close();
	connect(1);
};

//친구검색 자동완성
$("#findMemberInput").autocomplete({
	source : function(request, response){
		$.ajax({
			url : `${pageContext.request.contextPath}/chat/searchFriend.do`,
			method:"GET",
			data: { value : request.term },
			success(data){
				response(
				 $.map(data, function(item) {  
                     return {
                    	 id: item.id,
                    	 name: item.name,
                    	 picture: item.picture
					 }
				 })
					
				);
			}
		})
	},
     select : function(event, ui) {   
    	 console.log(ui.item.id);
    },
    focus : function(evt, ui) {
        return false;
    },
	minLength: 1
}).autocomplete( "instance" )._renderItem = function( ul, item ) {  
    const {id , name, picture} = item;
	return $( "<li>" )    
    .append( `<div><img src='../resources/upload/member/profile/\${picture}' class='rounded-circle user_img'/>` + "id = " + id + "이름 = " + name + " " + `<button type="button" class="btn btn-primary" onclick='chatsend(this.value);' value='\${id}'>전송</button></div>` )    //여기에다가 원하는 모양의 HTML을 만들면 UI가 원하는 모양으로 변함.
    .appendTo( ul );
}; 

<!-- 메뉴 클릭 -->
const actionMenu = () => {
	$('.action_menu').toggle();
};

<!-- 채팅방 나가기 -->
const closeChatRoom = (roomType)=>{
	console.log("roomType = ",roomType);
	if(roomType == 0){
	if(confirm("상대방의 채팅방도 나가집니다. 나가시겠습니까?")){
		$("[name=exitRoomFrm] input[name=roomNo]").val(roomNo);
		$(document.exitRoomFrm).submit();
	}
	}
	else{
		alert("소모임 삭제 or 탈퇴시 나갈 수 있습니다.");
		return
	}
		
};
	



</script>

<!-- 예약 상세보기 모달 -->
<jsp:include page="/WEB-INF/views/member/modal/reservationAccept.jsp"></jsp:include>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>