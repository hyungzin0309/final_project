<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberView.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="마이페이지" name="title"/>
</jsp:include>

<!-- 우측 공간확보 -->
<section class="body-section" style="width:200px;height:100%;float:right;display:block;">
</section>


<section class="body-section">

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script src="https://kit.fontawesome.com/0748f32490.js"	crossorigin="anonymous">
</script>
<sec:authentication property="principal" var="loginMember"/>

<c:if test="${not empty msg}">
	<script>
	alert("${msg}");
	</script>
</c:if>

<div class="profile-container mt-2">
    <div class="row" id="myInfo">
    	<!-- 프로필이미지 영역 -->
        <div class="col-sm-5 d-flex justify-content-center align-items-center flex-column" id="profileImg">
        	<div class="profileImg d-flex">
        		<!-- 이미지를 넣으세요 -->
        		<img src="${pageContext.request.contextPath}/resources/upload/member/profile/${member.picture}" alt=""/>
        	</div>
        	<div class="profileBtn">
        		<c:if test="${loginMember.id.equals(member.id) }">
        		<div class="extraSet">
        		<!-- (+)버튼을 -->
        		<form:form name="profileUpdateFrm" action="${pageContext.request.contextPath }/member/profileUpdate?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data">
	        		<label class="input-file-button" for="input-file">
	        			<img src="${pageContext.request.contextPath }/resources/images/icons/plusIcon.png" alt="" />
	        		</label>
	        		<input type="file" name="upFile" id="input-file" style="display:none;"/>
        		</form:form>
        		</div>
        		</c:if>
        	</div>
        </div>

        <!-- 프로필 세부정보 영역 -->
        <div class="col-sm-7" id="profileStatus">
        <br /><br /><br />
        	<span class="followTitle" style="font-size : 14px">팔로잉 :</span>
        	<button  type="button" class="btn btn-outline-dark" id="btn-following-list">${followerCount}명</button>
        	 &nbsp;&nbsp;&nbsp;
        	<span class="followTitle" style="font-size : 14px">팔로워 : </span>
        	 <button  type="button" class="btn btn-outline-dark" id="btn-follower-list">${followingCount}명</button>
        	 <br /> 
        	 <!-- 신고버튼 -->
        	<c:if test="${!loginMember.id.equals(member.id) }">
 			 <div id="report-box"><input type="button" id="reportBtn" class="btn btn-danger" value="신고"></div>
        	</c:if>
        	<!-- 설정버튼 : 본인계정일땐 설정, 아닐땐 친구추가 버튼 -->
        	<c:if test="${loginMember.id.equals(member.id) }">
        	<button type="button" class="btn btn-outline-dark icon" id="settingBtn" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">
        		<img src="${pageContext.request.contextPath }/resources/images/icons/setting.png" alt="" />
        	</button>
        	</c:if>
        	<c:if test="${member.publicProfile == 1 && !loginMember.id.equals(member.id) && isFriend == 0 }">
        	<button type="button" class="btn btn-outline-dark icon" id="addFriendBtn" onclick="addFollowing();">
        		<img src="${pageContext.request.contextPath }/resources/images/icons/man.png" alt="" />
        	</button>
        	<!-- 친구추가frm -->
  	        <form:form name="addFollowingFrm" action="${pageContext.request.contextPath}/member/addFollowing" method = "POST">
        		<input type="hidden" name ="friendId" value="${member.id}" />
        		<input type="hidden" name ="myId" value="${loginMember.id}" />
        	</form:form>
        	</c:if>
        	
            <br /><br /> 
            
            <div class="profileTableArea">
				<table id="profileTable">
					<tbody>
						<tr>
							<td class="key">
								<span class="tableKey">아이디</span>
							</td>
							<td>
								<span class="tableValue">${member.id}</span>
							</td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td><span class="tableKey">지역</span></td>
							<td class="tableValue">${shopInfo.address}</td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td rowspan=2><span class="tableKey">소개</span></td>
							<td class="tableValue" rowspan=2>
								 ${shopInfo.shopIntroduce} 
							</td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td><span class="tableKey">평점(리뷰 수)</span></td>
							<td>
								<span class="tableValue grade">4.9</span>
							</td>
						</tr>
						<tr><td></td></tr><tr><td></td></tr> 
						<!-- 본인인 경우 예약확인버튼 노출 -->
						<c:if test="${loginMember.id.equals(member.id) }">
						<tr>
							<td>
								<input type="button" value="예약확인" id="reservationListBtn" class="btn btn-outline-primary"/>
								
								<!-- reservation check Modal -->
								<jsp:include page="/WEB-INF/views/member/modal/shopReservationList.jsp"></jsp:include>
							</td>
						</tr>
						</c:if>
						
						<!-- 본인이 아닌 경우 예약하기 버튼 노출 -->
						<c:if test="${!loginMember.id.equals(member.id) }">
						<tr>
							<td>
								<input type="button" value="예약" id="reservationBtn" class="btn btn-outline-primary"/>
								
								<!-- reservation Modal -->
								<jsp:include page="/WEB-INF/views/member/modal/shopReservation.jsp"></jsp:include>
							</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			<!-- 글쓰기버튼 -->
			<c:if test="${loginMember.id.equals(member.id) }">
        	<button id="boardModalBtn" class="writeBtn" style="float:right; margin-top:-40px"><i style="font-size: 30px;" class="fas fa-pencil-alt" aria-hidden="true"></i></button>
        	<jsp:include page="/WEB-INF/views/member/boardModal/boardModal.jsp"></jsp:include>
        	</c:if>
			</div>
		</div>
    </div>
</div> 
<br/><br/> 
<div class="container mt-2">       
    <div class="boardRow">   
        <!-- 탭 영역 -->
        <div class="col-sm-12 nav nav-pills nav-fill" id="tab">   	
		  <div class="col-sm-6 nav-item d-flex justify-content-center align-items-center">
		    <a class="nav-link active" href="#" id="normalTabBtn" style="color:black; font-weight: bold">게시물</a>
		  </div>
		  <div class="col-sm-6 nav-item d-flex justify-content-center align-items-center" >
		    <a class="nav-link" href="#" id="reviewTabBtn" style="color:black; font-weight: bold"">후기</a>
		  </div>
        </div>
    </div>
	<br/> 
    <div class="row" id="normalArea">
	    <jsp:include page="/WEB-INF/views/member/shopViewBoardArea/normalBoard.jsp"></jsp:include>
    </div>
    <div class="row" id="reviewArea" style="display:none;">
    	<jsp:include page="/WEB-INF/views/member/shopViewBoardArea/reviewBoard.jsp"></jsp:include>
    </div>
    <jsp:include page="/WEB-INF/views/member/boardModal/boardDetail.jsp"/>
</div>

<script>
	$("#reviewTabBtn").click((e) => {
		$("#normalArea").hide();
		$("#reviewArea").show();
		$(e.target).addClass("active");
		$("#normalTabBtn").removeClass("active");
	});
	$("#normalTabBtn").click((e) => {
		$("#normalArea").show();
		$("#reviewArea").hide();
		$(e.target).addClass("active");
		$("#reviewTabBtn").removeClass("active");
	});

	/* profile 사진 업데이트 */
	$(".input-file-button").click((e) => {
		if(!confirm("파일을 등록하시겠습니까?")){
			return false;
		};
	});
	$("#input-file").change((e) => {
		console.log("파일등록");
		$(document.profileUpdateFrm).submit();
	});
	
	//친구추가하기
	function addFollowing(){
		if(confirm("친구추가를 하시겠습니까?")){
			$(document.addFollowingFrm).submit();
		}
	};
	
	//게시물 목록
	$('.board-main-image').click((e)=>{
		let boardNo = $(e.target).siblings("#boardNo").val();
		console.log("boardNo1",boardNo);
		getMemberPageDetail(boardNo);
		
		$('#pageDetail').modal("show");
	});
	
	/* 업체 평점 구하기 */
	function getShopGrade(shopId){
		$.ajax({
			url: '${pageContext.request.contextPath}/shop/getShopGrade',
			data:{
				shopId
			},
			success(res){
				let str = `\${res.average}점(\${res.reviewCount}개)`;
				$(".grade").text(str);
			},
			error: console.log
		});
	};
	
	/* onload 시 평점/리뷰 수 반영 */
	$(() => {
		let shopId = '${shopInfo.id}';
		getShopGrade(shopId);
	});

	//팔로잉, 팔로워리스트 모달
	$("#btn-following-list").on( "click", function() {
	    $("#test_modal").modal();
		});
	$("#btn-follower-list").on( "click", function() {
		$("#test_modal1").modal();
	});
	//팔로잉 리스트 가져오기
	$("#btn-following-list").click((e) => {
		$.ajax({
			url : "${pageContext.request.contextPath}/member/followingList",
			data : {"friendId":"${member.id}"},
			success(resp){
				console.log("결과 :", resp);
				
				$("#modalTbody").empty();
				
			     if(resp.length===0){
	                 tr = `<tr>
	                     <th colspan="5">팔로잉이 없습니다.</th>
	                 </tr>`;
	                 $("#modalTbody").append(tr);
	             }
			     
				const {memberId} = resp;
				$.each(resp, (i, e) => {
					console.log(e.followers[0].memberId);
					console.log(e.picture);
					let tr= `
					<tr>
						<td id="test1">
							<img style="width:50px; height:50px; border-radius:50%" src="${pageContext.request.contextPath}/resources/upload/member/profile/\${e.picture}" alt=""/>
							<a id = "a" href="${pageContext.request.contextPath}/member/memberView/\${e.followers[0].memberId}">\${e.followers[0].memberId}</a>
						</td>
					</tr>
				`;
				console.log(tr);
				$("#modalTbody").append(tr);
			})
		},
		error: console.log
		})
	});
	//팔로워 리스트 가져오기 
	$("#btn-follower-list").click((e) => {
		$.ajax({
			url : "${pageContext.request.contextPath}/member/followerList",
			data :  {"friendId":"${member.id}"},
			success(resp){
				console.log(resp);
				
				$("#modalTbody1").empty();
				
				if(resp.length===0){
	                tr = `<tr>
	                    <th colspan="5">팔로워가 없습니다.</th>
	                </tr>`;
	                $("#modalTbody1").append(tr);
	            }
				
				const {followingId} = resp;
				$.each(resp, (i, e) => {
					console.log(e.followers[0].followingId);
					let tr= `
						<tr>
						<td id="test1">
							<img style="width:50px; height:50px; border-radius:50%" src="${pageContext.request.contextPath}/resources/upload/member/profile/\${e.picture}" alt=""/>
							<a id = "a" href="${pageContext.request.contextPath}/member/memberView/\${e.followers[0].followingId}">\${e.followers[0].followingId}</a>
						</td>
					</tr>
				`;
				$("#modalTbody1").append(tr);
				
			})
		},
		error: console.log
		})
	});
</script>
<!-- 팔로잉리스트 모달창 -->
       <div class="modal fade" id="test_modal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel"></h4>
			</div>
			<div class="modal-body">
				<table class="table" style="text-align: center;" name="modalTable">
					<thead class="table-light">
						<tr>
							<th>팔로잉</th>
						</tr>
					</thead>
					<tbody id="modalTbody">
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
			<!-- <button type="button" class="btn btn-primary">Save changes</button> -->	
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<!-- 팔로워리스트 모달창 -->
       <div class="modal fade" id="test_modal1" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel"></h4>
			</div>
			<div class="modal-body">
				<table class="table" style="text-align: center;" name="modalTable">
					<thead class="table-light">
						<tr>
							<th>팔로워</th>
						</tr>
					</thead>
					<tbody id="modalTbody1">
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
			<!-- <button type="button" class="btn btn-primary">Save changes</button> -->	
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
 

<a href="/" class="badge badge-dark">Dark</a>
</section>
<style>
.profile-container mt-2{
 	border: none;
 	 border-bottom: solid; 
    border-bottom-width: unset;  
    width: 850px;
}
#myInfo {
	margin-top: 45px;
	margin-bottom :-30px;
    border: none; 
    border-bottom: solid;
    border-color: gray;
    border-bottom-width: 1px;  
    height : 380px;
    margin-left:100px;   
}
.tableKey {
    width: 5%;
    font-size: 15px;
    padding-bottom: 1px;
    font-weight: 700;
    margin-left: 5px;
}
.tableValue {
    width: 100%;
    font-size: 14px;
    padding-bottom: 6px;
}
.boardRow {
    width: 1000px;
    margin : auto;
}
.board-main-image{
cursor: pointer;
 }
.writeBtn{
	border-radius : 50px;
	background-color : white;
	border : none;
} 
.key{
	width:160px;
}
#btn-following-list{
	width: 60px;
}
#btn-follower-list{
	width: 60px;
}
#report-box{
	float:right;
	margin-top : 40px;
} 
#reportBtn {
    color: white;
    border-color: black;
    background-color:#ff000078;
}
#addFriendBtn{
margin-left: 500px;
}
#test1{
	border-top:none;
	border-bottom:none;
}
.nav-pills .nav-link.active, .nav-pills .show>.nav-link {
    color: #fff;
    background-color: #a9a9a97d;
}
#tab{
 width: 85%;
 margin:auto;
}
</style> 
 
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>