<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<sec:authentication property="principal" var="loginMember"/>

<!-- 게시물 상세보기 Modal-->
	<div class="modal fade" id="groupPageDetail" tabindex="-1">
		<div class="modal-dialog modal-xl modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
				<table>
					<tr>
						<td rowspan="2" id="member-profile"><img src="" style="height:50px;width:50px; border-radius:50%"/></td>
						<th id="member-id"></th>
					</tr>
					<tr>
						<td><span id="reg-date"></span><a href="javascript:void(0);" onclick="$(document.locationFrm).submit();" id="tag-place" style="color:black; text-decoration:none;"></a>
						<form action="${pageContext.request.contextPath}/group/searchLocation" name="locationFrm">
							<input type="hidden" value="" name="locationX"/>
							<input type="hidden" value="" name="locationY"/>
							<input type="hidden" value="" name="placeName"/>
							<input type="hidden" value="" name="placeAddress"/>
						</form>
						</td>
					</tr>
				</table>
				<!-- <div style="position:relative;margin-right:-665px; margin-bottom:5%;">
				</div> -->
				<div style="color:gray; margin-right:1%;">
					<div style="display:inline;">
						<img src="https://img.icons8.com/plasticine/100/000000/like--v2.png" class="heart unlike" onclick="like();" style="width:50px;"/>
						<img src="https://img.icons8.com/plasticine/100/000000/like--v1.png" class="heart like" onclick="unlike();" style="width:50px;"/>
					</div>					
					<span class="like_count"></span>
				</div>
				</div>
				<div class="modal-body">
					<div class="container">
					    <div class="row">
					        <div class="col-sm-7" id="group-board-img-container" style="background-color:black; display: flex; align-items: center; position:relative;">
					        
 					        </div>
					        <div class="col-sm-5" style="">
					        	<div class="container">
								    <div class="row">
								        <div class="col-sm-12" id="group-board-tag-member-list" style="border-bottom:solid #80808040 1px; height:100px; overflow:auto; padding:0px 20px 20px 20px;">
								        	<p style="color:gray;">with</p>
								        	<table id="tagMemberListTable">
								        	
								        	</table>
								        </div>
								        <div class="col-sm-12" id="group-board-content" style="border-bottom:solid #80808040 1px; height:300px; overflow:auto; padding:20px;"></div>
								        <div class="col-sm-12" id="group-board-comment-list" style="border-bottom:solid #80808040 1px; height:500px; overflow-x:hidden; overflow-y:auto; padding:20px;">
										<table style="width:100%;">
										
										</table>
										</div>
								        <div class="col-sm-12" id="group-board-comment-submit"style="height:150px; padding:20px;">
								        	<form:form action="" name="groupBoardCommentSubmitFrm">
								        		<input type="hidden" name="writer" value="<sec:authentication property='principal.username'/>">
								        		<input type="hidden" name="boardNo" id="boardNo" value=""/>
								        		<input type="hidden" name="commentLevel" value="1"/>
								        		<input type="hidden" name="commentRef" value="0"/>
									        	<textarea name="content" id="" cols="30" rows="10" placeholder="댓글입력..." ></textarea>
									        	<div><input type="submit" value="게시"/></div>								        	
								        	</form:form>
								        </div>
								    </div>
								</div>
					        </div>
					    </div>
					</div>
				</div>
				<div class="modal-footer">
					<div style="margin:10px 0px;">
						<form:form name="groupBoardDeleteFrm" action="${pageContext.request.contextPath}/group/deleteGroupBoard" method="POST">
 							<input type="hidden" name="groupId" value="${group.groupId}"/>
							<input type="hidden" name="no" value="" />
						</form:form>
						<button type="submit" class="btn-deleteBoard" onclick="deleteGroupBoardFunc();">게시물 삭제</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<script>
let maxIndex;
let currentIndex;
let newContent;
// 게시물 목록 이미지 클릭
$('.board-main-image').click((e)=>{
	let boardNo = $(e.target).siblings("#group-board-no").val();
	getPageDetail(boardNo);
	
});


// 게시물 상세보기 페이지 데이터 불러오기 함수
function getPageDetail(boardNo){
	console.log("aaa",boardNo);
	$.ajax({
				url:`<%=request.getContextPath()%>/group/groupBoardDetail/\${boardNo}`,
				success(data){
			 
			 		const {groupBoard, tagMembers, isLiked} = data;
			 		console.log(groupBoard); // 게시글 기본 정보
			 		console.log(tagMembers); // 태그된 멤버들
			 		console.log(isLiked); //좋아요 눌렀는지 여부
		 			gb = groupBoard; // 다른 함수에서도 게시물 데이터에 쉽게 접근하기 위해, 전역변수에 대입
		 			
		 			// modal의 header부분
		 			const date = moment(groupBoard.regDate).format("YYYY년 MM월 DD일"); // 작성일자
					let src = `<%=request.getContextPath()%>/resources/upload/member/profile/\${groupBoard.writerProfile}`;
			 		$("#member-profile").children("img").attr("src",src); // 글쓴이 프로필 이미지
			 		//글쓴이 아이디
		 	 		$("#member-id").html(`&nbsp;&nbsp<a href="${pageContext.request.contextPath}/group/groupPage/\${groupBoard.groupId}" style="color:black; text-decoration:none; font-size:1.2em;">[\${groupBoard.groupId}]</a><a href="javascript:void(0);" onclick="goMemberView('\${groupBoard.writer}');" style="color:black; text-decoration:none;">&nbsp;&nbsp;\${groupBoard.writer}</a>`);
			 		$("#reg-date").html(`&nbsp;&nbsp;\${date}`) // 작성일
			 		
			 		// 태그장소
			 		$("#tag-place").html(`,&nbsp;&nbsp;\${groupBoard.placeName}`)
			 		$("[name=locationX]").val(groupBoard.locationX);
			 		$("[name=locationY]").val(groupBoard.locationY);
			 		$("[name=placeName]").val(groupBoard.placeName);
			 		$("[name=placeAddress]").val(groupBoard.placeAddress);
			 		
			 		
			 		// 좋아요 버튼
			 		if(isLiked){
			 			$(".unlike").css("display","none"); 
			 			$(".like").css("display","inline"); // 좋아요가 이미 눌린 상태라면, like클래스의 이미지가 보이도록 함 (분홍색 꽉찬 하트)
			 		}else{
			 			$(".like").css("display","none");			 			
			 			$(".unlike").css("display","inline"); // 좋아요가 눌려있지 않은 상태라면, unlike클래스의 이미지가 보이도록 함(빈 하트) 			
			 		}
		 	 		
			 		//좋아요 개수
			 		getLikeCount();
			 		
			 		// modal footer부분 - 게시물 삭제 버튼
		 	 		if("<sec:authentication property='principal.username'/>" != groupBoard.writer
		 	 				&& "<sec:authentication property='principal.username'/>" != "${group.leaderId}"){ // 작성자이거나 소모임 리더인 경우만 글 삭제 가능
			 			$(".btn-deleteBoard").css("display","none");
			 		}else{
			 			$(".btn-deleteBoard").css("display","block");
			 			$(document.groupBoardDeleteFrm)
			 				.children("[name=no]").val(boardNo);
			 		}
					
		 	 		
			 		// 이미지
			 		$("#group-board-img-container").empty();
			 		// 이미지 넘기기 좌/우 버튼
			 		const button = `<div class="img-move-button-container">
				        <img class="board-img-move left-button" src="<%=request.getContextPath()%>/resources/images/icons/left1.png" alt="" />
				        <img class="board-img-move right-button" src="<%=request.getContextPath()%>/resources/images/icons/right1.png" alt="" />
				        </div>`
			 		$("#group-board-img-container").append(button);
				        
			 		$.each(groupBoard.image, (i,e)=>{
			 			// 각 이미지마다 다른 번호의 id부여
		 				let img = `<img id='img\${i}' src='<%=request.getContextPath()%>/resources/upload/group/board/\${e}' alt="" class="group-board-img"/>`
		 				$("#group-board-img-container").append(img); // 이미지 추가
			  			$(`#img\${i}`).css("display","none");
		 				maxIndex = i;
		 			})
		 			
		 			$(".group-board-img").css("width","100%");
		 			$(".group-board-img").css("position","absolute");
		  			$(".group-board-img").css("left","0");
		  			$("#img0").css("display","inline");
					
		  			currentIndex = 0; // 화면에 보이는 이미지의 인덱스의 기본값 (처음 화면에 보이는 이미지는 인덱스0의 이미지)
		  			
		  			//이미지 옆으로 넘기기
		  			$(".right-button").click((e)=>{
						if(currentIndex<maxIndex){ // 가장 마지막 사진이 아닌 경우에만 오른쪽 버튼 실행
			  				$(`#img\${currentIndex+1}`).css("display","inline"); // 다음 이미지 보이게 
			  				$(`#img\${currentIndex}`).css("display","none"); // 현재 이미지는 보이지 않게
			  				currentIndex += 1; // 현재이미지의 index값을 최신화
						}
		  			})
		  			$(".left-button").click((e)=>{
						if(currentIndex>0){ // 가장 처음 사진이 아닌 경우에만 왼쪽 버튼 실행
			  				$(`#img\${currentIndex-1}`).css("display","inline"); // 이전 이미지 보이게
			  				$(`#img\${currentIndex}`).css("display","none"); // 현재 이미지는 보이지 않게
			  				currentIndex -= 1;	// 현재 이미지의 index값을 최신화
						}
		  			})
		  			
		 			//modal의 body부분
		 			//태그 멤버 목록
		  			$("#tagMemberListTable").empty();
		 			$.each(tagMembers, (i,e)=>{
		 				let tr = `<tr>
		 					<td><a href="javascript:void(0);" onclick="goMemberView('\${e.id}');" ><img style="width:50px; height:50px; border-radius:50%" src="<%=request.getContextPath()%>/resources/upload/member/profile/\${e.picture}" alt="" /></a></td>
		 					<th><a href="javascript:void(0);" onclick="goMemberView('\${e.id}');" style="color:black; text-decoration:none;">&nbsp;&nbsp;&nbsp;&nbsp;\${e.id}</a></th>
		 				</tr>`;	
		  				$("#tagMemberListTable").append(tr);
		 			})
					
		 			//content
		 			getContent(); // 컨텐츠 불러오는 함수 실행
		 			
		 			//댓글 리스트
		 			getCommentList(groupBoard.no); // 댓글 불러오는 함수 실행
		 			
		 			//댓글 입력창
		 			$("#group-board-comment-submit #boardNo").val(groupBoard.no);
		 				
		 			//모달에 데이터가 들어가는 작업이 완료되면 모달을 보이게 함
		 			$('#groupPageDetail').modal("show");
		 			
		 		},
		 		error(xhr, statusText, err){
					switch(xhr.status){
					default: console.log(xhr, statusText, err);
					}
					console.log
				}
			})
}
//좋아요 개수 불러오기
function getLikeCount(){
	$.ajax({
		url:`${pageContext.request.contextPath}/group/getLikeCount/\${gb.no}`,
		success(data){
			$(".like_count").html(data.likeCount);
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			console.log
		}
	})
}
//좋아요 취소
function unlike(){
	$.ajax({
		url:`${pageContext.request.contextPath}/group/unlike/\${gb.no}`,
		method:"DELETE",
		success(data){
			console.log(data);
			$(".like").css("display","none");			 			
 			$(".unlike").css("display","inline");
 			getLikeCount();
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			console.log
		}
	})
}
// 좋아요
function like(){
	$.ajax({
		url:`${pageContext.request.contextPath}/group/like`,
		method:"POST",
		data:{
			"no":gb.no
		},
		success(data){
			console.log(data);
			$(".like").css("display","inline");			 			
 			$(".unlike").css("display","none");
 			getLikeCount();
		    
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			console.log
		}
	})
}
// 게시물 불러오기 함수
function getContent(){
	let boardContent = `\${gb.content}</br>`
	// 글 작성자 혹은 소모임 리더에게만 수정버튼 보이게
	if(gb.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${group.leaderId}"){
		boardContent += `<button class='btn-boardModify' onclick="boardContentModifyFunc();">수정</button></br>`
	}
	$("#group-board-content").html(boardContent);
}
//게시물 수정 폼 나오기
function boardContentModifyFunc(){
	$("#group-board-content").empty();
	let form = `
		<div style="height:90%;">
			<input type="hidden" name="no" value="\${gb.no}"/>
			<textarea style="height:100%;" name="content">\${gb.content}</textarea> // 수정폼 내 textarea에 기존의 content내용이 그대로 들어가있도록 함
		</div>
		<button class="btn-submitContent" onclick="submitModifiedContent(this);">등록</button>
	`;
	$("#group-board-content").append(form);
	
	// textarea의 변경값 실시간 감지
	$("textarea[name=content]").on("propertychange change keyup paste input", function() {
	   // 현재 변경된 데이터를 전역변수 newContent에 대입
	   newContent = $(this).val();
	});
	
}
//게시물 수정 제출 함수
function submitModifiedContent(e){
	const no = $(e).siblings("div").children("[name=no]").val();
	console.log(newContent);
	$.ajax({
		url:`${pageContext.request.contextPath}/group/groupBoardModifying`,
		method:"POST",
		data:{
			"no":no, // 게시물번호
			"content":newContent
		},
		success(data){
			console.log(data);
			getPageDetail(gb.no);
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			
		}
	}) 
}
// modifyContentFrm을 제출하려고 할 때, 제출을막고 modifiedBoardSubmitFunc가 먼저 실행될 수 있도록 함
$(document.modifyContentFrm).submit((e)=>{
	e.preventDefault();
});
function modifiedBoardSubmitFunc(){
	if(confirm("수정하시겠습니까?")){
		$(document.modifyContentFrm).submit();
	}
}
//게시물 삭제 함수
function deleteGroupBoardFunc(){
	if(confirm("게시물을 삭제하시겠습니까?")){
		$(document.groupBoardDeleteFrm).submit();
	}
};
//댓글 리스트 불러오기
function getCommentList(boardNo){
  	$.ajax({
  		url:`${pageContext.request.contextPath}/group/getCommentList/\${boardNo}`,
  		success(data){
  			$("#group-board-comment-list>table").empty();
  			$.each(data,(i,e)=>{
  				
 				const date = moment(e.regDate).format("YYYY년 MM월 DD일");
 				
	  			let tr = `
	  				<tr class="level\${e.commentLevel}">
	  				<td style="width:50px;">
	  					<img style="width:40px; height:40px; border-radius:50%;" src="${pageContext.request.contextPath}/resources/upload/member/profile/\${e.writerProfile}" alt="" />
	  				</td>
					<td >
						<sub class="comment-writer"><a href="javascript:void(0);" onclick="goMemberView('\${e.writer}');" style="color:black; text-decoration:none; font-weight:bold;">\${e.writer}</a></sub>
						<sub class="comment-date">\${date}</sub>
						<br />
						<!-- 댓글내용 -->
						&nbsp;&nbsp;&nbsp;\${e.content}
					</td>`;
				if(e.commentLevel == 1){
					// 댓글레벨 1 && 내가 작성자이거나 소모임 리더일 때 (답글버튼, 삭제버튼 모두보임)
					if(e.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${group.leaderId}"){ //댓글 레벨 1 && 내가 작성자일 때 (삭제, 답글 버튼 모두)
						tr+=`<td>
								<span href='' class='btn-boardCommentDelete' onclick='deleteCommentFunc(\${e.no},\${e.boardNo})'>삭제</span>
							</td>
							<td>
								<button class="btn-reply" onclick="showReplyForm(this);" value="\${e.no}">답글</button>
								<input type="hidden" id="reply-board-no" value="\${boardNo}"/>
							</td>`;	
					}
					else{ // 댓글레벨 1 && 내가 작성자가 아닐 때 (답글 버튼만 보이게)
						tr+=`<td></td>
						<td>
							<button class="btn-reply" onclick="showReplyForm(this);" value="\${e.no}">답글</button>
							<input type="hidden" id="reply-board-no" value="\${boardNo}"/>
						</td>`;	
					}
				}	
				else{ // 댓글레벨 2 && 내가 작성자 혹은 그룹 리더일 때 (삭제버튼만 보이게)
					if(e.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${group.leaderId}"){
						tr+=`<td></td><td style='padding-left:5px;'><span class='btn-boardCommentDelete' onclick='deleteCommentFunc(\${e.no},\${e.boardNo})'>삭제</span></td>`;	
					}
					else{ // 댓글레벨 2 && 내가 작성자가 아닐 때 (아무버튼도 없음)
						tr+="<td></td><td></td>";	
					}
				}
	  			tr += "</tr>"
	  			$("#group-board-comment-list>table").append(tr);
  			})
  		},
  		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			
		}
  	})
};
// 댓글 삭제 함수
function deleteCommentFunc(no,boardNo){
	console.log(no);
	if(confirm("정말 삭제하시겠습니까?")){
		$.ajax({
			url:`${pageContext.request.contextPath}/group/groupBoardCommentDelete/\${no}`,
			method:"DELETE",
			success(data){
				console.log(data);
				getCommentList(boardNo); // 댓글을 삭제하면 새로고침된 댓글 리스트가 보여질 수 있도록 함
			},
			error(xhr, statusText, err){
				switch(xhr.status){
				default: console.log(xhr, statusText, err);
				}
				console.log
			}
		})
	}
}
//답글 버튼 눌렀을 때 답글창 나오기
function showReplyForm(e){
	// 답글 달고자 하는 댓글의 번호
	const commentRef = $(e).val(); // 댓글번호 가져오기
	console.log($(e).siblings("#reply-board-no"));
	const boardNo = $(e).siblings("#reply-board-no").val();
	console.log(commentRef);
	console.log(boardNo);
	
	const tr = `<tr>
				<td></td>
				<td colspan="3" style="text-align:left padding-left:50px;">
					<form>
				    <input type="hidden" name="boardNo" value="\${boardNo}" />
				    <input type="hidden" name="writer" value="<sec:authentication property='principal.username'/>" />
				    <input type="hidden" name="commentLevel" value="2" />
				    <input type="hidden" name="commentRef" value="\${commentRef}" />    
					<textarea style="height:45px;" placeholder="답글입력..." name="content" cols="60" rows="2"></textarea>
				    <button type="submit" class="btn-comment-enroll2 btn-reply">등록</button>
				</form>
				</td>
			</tr>`;
	
	// e.target인 버튼태그의 부모tr을 찾고, 다음 형제요소로 추가
	const $baseTr = $(e).parent().parent(); // 답글 다려는 댓글의 tr
	const $tr = $(tr); //HTML담긴 제이쿼리 변수
	// 클릭이벤트핸들러 제거
	// 답글 다는 동안 답글버튼 또 눌렀을 때 새로운 html생성되는 것 방지
	$(e).removeAttr("onclick");
	$tr.insertAfter($baseTr)
		.find("form")
		.submit((e) => { // submit시 실행될 콜백함수를 지정해줄 수도 있음
			e.preventDefault();	
			submitCommentFunc(e);
	});
}
//댓글 입력
$(document.groupBoardCommentSubmitFrm).submit((e)=>{
	e.preventDefault();
	submitCommentFunc(e);
})
//댓글 제출 함수
function submitCommentFunc(e){
	let boardNo = $("[name=boardNo]",e.target).val(); 
	let commentwriter = $("[name=writer]",e.target).val();
	let o = {
		boardNo:boardNo,
		writer:$("[name=writer]",e.target).val(),
		commentLevel:$("[name=commentLevel]",e.target).val(),			
		commentRef:$("[name=commentRef]",e.target).val(),			
		content:$("[name=content]",e.target).val(),	
	}
	console.log(o);
	const jsonStr = JSON.stringify(o);
	console.log(jsonStr);
	$.ajax({
		url:"<%=request.getContextPath()%>/group/enrollGroupBoardComment",
		method:"POST",
		dataType:"json",
		data:jsonStr,
		contentType:"application/json; charset=utf-8",
		success(data){
			console.log(data);
			$("[name=content]",e.target).val("");	
			
			getCommentList(boardNo);
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			console.log
		}
	})
};


</script>