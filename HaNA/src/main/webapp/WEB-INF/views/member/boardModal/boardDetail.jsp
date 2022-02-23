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
	<div class="modal fade" id="pageDetail" tabindex="-1">
		<div class="modal-dialog modal-xl modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
				<table>
					<tr>
						<td rowspan="2" id="member-profile"><img src="" style="height:50px;width:50px; border-radius:50%"/></td>
						<th id="member-id"></th>
					</tr>
					<tr>
						<td><span id="reg-date"></span><a href="#" id="tag-place" style="color:black; text-decoration:none;"></a></td>
					</tr>
				</table>
				<div style="position:relative;margin-right:-665px; margin-bottom:5%;">
				<img src="https://img.icons8.com/plasticine/100/000000/like--v2.png" class="heart unlike" onclick="like();" style="position:absolute; width:50px;"/>
				<img src="https://img.icons8.com/plasticine/100/000000/like--v1.png" class="heart like" onclick="unlike();" style="position:absolute; width:50px;"/>
				</div>
				<div style="color:gray; margin-right:1%;">
					<span class="like_count"></span>
				</div>
				</div>
				<div class="modal-body">
					<div class="container">
					    <div class="row">
					        <div class="col-sm-7" id="board-img-container" style="background-color:black; display: flex; align-items: center; position:relative;">
 					        </div>
					        <div class="col-sm-5" style="">
					        	<div class="container">
								    <div class="row">
								        <div class="col-sm-12" id="board-tag-member-list" style="border-bottom:solid #80808040 1px; height:60px; overflow:auto; padding:0px 20px 20px 20px;">
								        	<p style="color:gray;"></p>
								        	<table id="tagMemberListTable">
								        	
								        	</table>
								        </div>
								        <div class="col-sm-12" id="board-content" style="border-bottom:solid #80808040 1px; height:300px; overflow:auto; padding:20px;"></div>
								        <div class="col-sm-12" id="board-comment-list" style="border-bottom:solid #80808040 1px; height:500px; overflow-x:hidden; overflow-y:auto; padding:20px;">
										<table style="width:100%;">
										
										</table>
										</div>
								        <div class="col-sm-12" id="board-comment-submit"style="height:150px; padding:20px;">
								        	<form:form action="" name="boardCommentSubmitFrm">
								        		<input type="hidden" name="writer" value="<sec:authentication property='principal.username'/>">
								        		<input type="hidden" name="boardNo" id="boardNo" value=""/> 
								        		<input type="hidden" name="commentLevel" value="1"/>
								        		<input type="hidden" name="commentRef" value="0"/>
									        	<textarea name="content" id="textareaComment" cols="30" rows="10" placeholder="댓글입력..." ></textarea>									        	   
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
						<form:form name="boardDeleteFrm" action="${pageContext.request.contextPath}/member/deleteBoard?${_csrf.parameterName}=${_csrf.token}" method="POST">
 							<input type="hidden" name="id" value="${member.id}"/>
						<c:forEach items="${boardList}" var="board" varStatus="vs">
							<input type="hidden" name="no" value="${board.no}" />
						</c:forEach>
						</form:form>
						<button type="submit" class="btn-deleteBoard" onclick="deleteBoardFunc();">게시물 삭제</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<script>
let maxIndex;
let currentIndex;
//게시물 상세보기
function getMemberPageDetail(boardNo){
	console.log("boardNo2",boardNo);
	 $.ajax({
			url : "${pageContext.request.contextPath}/member/memberBoardDetail/"+boardNo,
			success(resp){
				console.log("확인", resp);
				const data = resp.boardDetail;
				const Like = resp.isLiked;
				//const {baordDetail:data} = resp;
				boardDetail = data;
				isLiked = Like;
				console.log("boardDetail확인", boardDetail);
				console.log("isLiked확인", isLiked);
			 
	 			const date = moment(boardDetail.regDate).format("YYYY년 MM월 DD일");
				let src = `<%=request.getContextPath()%>/resources/upload/member/profile/\${boardDetail.writerProfile}`;
		 		$("#member-profile").children("img").attr("src",src); // 글쓴이 프로필 이미지
	 	 		$("#member-id").html(`<a href="javascript:void(0);" onclick="goMemberView('\${boardDetail.writer}');" style="color:black; text-decoration:none;">&nbsp;&nbsp;\${boardDetail.writer}</a>`); // 글쓴이 아이디
		 		$("#reg-date").html(`&nbsp;&nbsp;\${date}`) // 날짜 
		 		
		 		// 좋아요 버튼
		 		if(isLiked){
		 			$(".unlike").css("display","none");
		 			$(".like").css("display","inline");
		 		}else{
		 			$(".like").css("display","none");			 			
		 			$(".unlike").css("display","inline");			 			
		 		}
	 	 		
		 		//좋아요 개수
		 		//getLikeCount();
		 		
		 		// modal footer부분 - 게시물 삭제 버튼
	 	 		if("<sec:authentication property='principal.username'/>" != boardDetail.writer && "<sec:authentication property='principal.username'/>" != "${member.id}"){
		 			$(".btn-deleteBoard").css("display","none");
		 		}else{
		 			$(".btn-deleteBoard").css("display","block");
		 			$(document.boardDeleteFrm)
		 				.children("[name=no]").val(boardNo);
		 		}
				
		 		
	 	 	// 이미지
		 		$("#board-img-container").empty();
		 		const button = `<div class="img-move-button-container">
			        <img class="board-img-move left-button" src="<%=request.getContextPath()%>/resources/images/icons/left1.png" alt="" />
			        <img class="board-img-move right-button" src="<%=request.getContextPath()%>/resources/images/icons/right1.png" alt="" />
			        </div>`
		 		$("#board-img-container").append(button);
			        
		 		$.each(boardDetail.picture, (i,e)=>{
	 				
	 				let img = `<img id='img\${i}' src='<%=request.getContextPath()%>/resources/upload/member/board/\${e}' alt="" class="board-img"/>`
	 				$("#board-img-container").append(img); // 이미지 추가
		  			$(`#img\${i}`).css("display","none");
	 				maxIndex = i;
	 			})
	 			
	 			$(".board-img").css("width","100%");
	 			$(".board-img").css("position","absolute");
	  			$(".board-img").css("left","0");
	  			$("#img0").css("display","inline");
				
	  			currentIndex = 0;
	  			
	  			//이미지 옆으로 넘기기
	  			$(".right-button").click((e)=>{
					if(currentIndex<maxIndex){
		  				$(`#img\${currentIndex+1}`).css("display","inline");
		  				$(`#img\${currentIndex}`).css("display","none");
		  				currentIndex += 1;							
					}
	  			})
	  			$(".left-button").click((e)=>{
					if(currentIndex>0){
		  				$(`#img\${currentIndex-1}`).css("display","inline");
		  				$(`#img\${currentIndex}`).css("display","none");
		  				currentIndex -= 1;							
					}
	  			})
		 		
	 			//내용
	 			let content = `\${boardDetail.content}</br>`
	  			$("#board-content").html(content);
	 			
	 			//content
	 			getContent();
	 			
	 			//댓글 리스트
	 			getCommentList(boardDetail.no);
	 			
	 			
	 			//댓글 입력창
	 			$("#board-comment-submit #boardNo").val(boardDetail.no);
	 			
			},
			error(xhr, statusText, err){
				switch(xhr.status){
				default: console.log(xhr, statusText, err);
				}
				console.log
			}
		})
}
function modifiedBoardSubmitFunc(){
	if(confirm("수정하시겠습니까?")){
		$(document.modifyContentFrm).submit();
	}
}
//게시물 삭제 함수
function deleteBoardFunc(){
	if(confirm("게시물을 삭제하시겠습니까?")){
		$(document.boardDeleteFrm).submit();
	}
};
//게시물 불러오기 함수
function getContent(){
	let boardContent = `\${boardDetail.content}</br>`
	if(boardDetail.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${member.id}"){
		boardContent += `<button class='btn-boardModify' onclick="boardContentModifyFunc();">수정</button></br>`
	}
	$("#board-content").html(boardContent);
}
//게시물 수정 폼 나오기
function boardContentModifyFunc(){
	$("#board-content").empty();
	let form = `
		<div style="height:90%;">
			<input type="hidden" name="no" value="\${boardDetail.no}"/>
			<textarea style="height:100%;" name="content">\${boardDetail.content}</textarea>
		</div>
		<button class="btn-submitContent" onclick="submitModifiedContent(this);">등록</button>
	`;
	$("#board-content").append(form);
	
	// textarea의 변경값 실시간 감지
	$("textarea[name=content]").on("propertychange change keyup paste input", function() {
	   // 현재 변경된 데이터 셋팅
	   newContent = $(this).val();
	});
	
}
//게시물 수정 제출 함수
function submitModifiedContent(e){
	const no = $(e).siblings("div").children("[name=no]").val();
	console.log("newContent",newContent);
	$.ajax({
		url:`${pageContext.request.contextPath}/member/boardModifying?${_csrf.parameterName}=${_csrf.token}`,
		method:"POST",
		data:{
			"no":no,
			"content":newContent
		},
		success(data){
			console.log(data);
			getMemberPageDetail(boardDetail.no);
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			
		}
	}) 
}
$(document.modifyContentFrm).submit((e)=>{
	e.preventDefault();
});
function modifiedBoardSubmitFunc(){
	if(confirm("수정하시겠습니까?")){
		$(document.modifyContentFrm).submit();
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
	$(e).removeAttr("onclick");
	$tr.insertAfter($baseTr)
		.find("form")
		.submit((e) => { // submit시 실행될 콜백함수를 지정해줄 수도 있음
			e.preventDefault();	
			submitCommentFunc(e);
	});
}
//댓글 입력
$(document.boardCommentSubmitFrm).submit((e)=>{
	e.preventDefault();
	submitCommentFunc(e);
	console.log("eee!!!",e)
})
//댓글 리스트 불러오기
function getCommentList(boardNo){
	console.log("보드넘버 확인!!!!!!!!!!!!!!!!!!!!!!",boardNo)
  	$.ajax({
  		url:`${pageContext.request.contextPath}/member/getCommentList/\${boardNo}`,
  		success(data){
  			$("#board-comment-list>table").empty();
  			$.each(data,(i,e)=>{
  				console.log("e.writerProfile",e.writerProfile);
 				const date = moment(e.regDate).format("YYYY년 MM월 DD일");
 				
	  			let tr = `
	  				<tr class="level\${e.commentLevel}">
	  				<td style="width:50px;">
	  				<img style="height:40px; border-radius:50%;" alt=""src= "${pageContext.request.contextPath}/resources/upload/member/profile/\${e.writerProfile}" />
	  				</td>
					<td >
						<sub class="comment-writer"><a href="javascript:void(0);" onclick="goMemberView('\${e.writer}');" style="color:black; text-decoration:none; font-weight:bold;">\${e.writer}</a></sub>
						<sub class="comment-date">\${date}</sub>
						<br />
						<!-- 댓글내용 -->
						&nbsp;&nbsp;&nbsp;\${e.content}
					</td>`;
				if(e.commentLevel == 1){
					if(e.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${member.id}"){ //댓글 레벨 1 && 내가 작성자일 때 (삭제, 답글 버튼 모두)
						tr+=`<td>
								<span href='' class='btn-boardCommentDelete' onclick='deleteCommentFunc(\${e.no},\${e.boardNo})'>삭제</span>
							</td>
							<td>
								<button class="btn-reply" onclick="showReplyForm(this);" value="\${e.no}">답글</button>
								<input type="hidden" id="reply-board-no" value="\${boardNo}"/>
							</td>`;	
					}
					else{ // 댓글레벨 1 && 내가 작성자가 아닐 때 (답글 버튼만)
						tr+=`<td></td>
						<td>
							<button class="btn-reply" onclick="showReplyForm(this);" value="\${e.no}">답글</button>
							<input type="hidden" id="reply-board-no" value="\${boardNo}"/>
						</td>`;	
					}
				}	
				else{ // 댓글레벨 2 && 내가 작성자 혹은 그룹 리더일 때 (삭제버튼만)
					if(e.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${member.id}"){
						tr+=`<td></td><td style='padding-left:5px;'><span class='btn-boardCommentDelete' onclick='deleteCommentFunc(\${e.no},\${e.boardNo})'>삭제</span></td>`;	
					}
					else{ // 댓글레벨 2 && 내가 작성자가 아닐 때 (아무버튼도 없음)
						tr+="<td></td><td></td>";	
					}
				}
	  			tr += "</tr>"
	  			$("#board-comment-list>table").append(tr);
  			})
  		},
  		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			
		}
  	})
};
//댓글 제출 함수
function submitCommentFunc(e){
	console.log("eeee???", e.target);
	console.log("boardDetail", boardDetail);
 	let boardNo = boardDetail.no;
 	console.log("boardNo = ",boardDetail.no);
 	let commentwriter = $("[name=writer]",e.target).val();
	let o = {
		boardNo:boardNo,
		commentLevel:$("[name=commentLevel]",e.target).val(),			
		writer:$("[name=writer]",e.target).val(),
		content:$("[name=content]",e.target).val(),	
		commentRef:$("[name=commentRef]",e.target).val(),			
	}
	console.log(o);
	const jsonStr = JSON.stringify(o);
	console.log("가져온 값",jsonStr);
	$.ajax({
		url:"${pageContext.request.contextPath}/member/enrollBoardComment?${_csrf.parameterName}=${_csrf.token}",
		method:"POST",
		dataType:"json",
		data:jsonStr,
		contentType:"application/json; charset=utf-8",
		success(data){
			console.log("넘어온 값!!",data);
			$("[name=content]",e.target).val("");
			
			<!-- 게시글 작성자한테 -->
			if($("[name=commentLevel]",e.target).val() === '1'){			
		    const data1 = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${boardDetail.writer}@${loginMember.id}님이 댓글을 등록했습니다.@\${boardNo}@일반@\${boardDetail.writer}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data1);
		    websocket.send(jsonData);	
			}
			<!-- 댓글 작성자한테 -->
			else{
			    const data1 = {
			            "roomNo" : 226,
			            "memberId" : `${loginMember.id}`,
			            "message"   : `\${commentwriter}@${loginMember.id}님이 대댓글을 등록했습니다.@\${boardNo}@일반@\${boardDetail.writer}`,
			            "picture" : `${loginMember.picture}`,
			            "messageRegDate" : today
			        }; 
			    let jsonData = JSON.stringify(data1);
			    websocket.send(jsonData);	
			}
			
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
//댓글 삭제 함수
function deleteCommentFunc(no,boardNo){
	console.log("댓글삭제 no!!!",no);
	if(confirm("정말 삭제하시겠습니까?")){
		$.ajax({
			url:`${pageContext.request.contextPath}/member/boardCommentDelete/\${no}?${_csrf.parameterName}=${_csrf.token}`,
			method:"DELETE",
			success(data){
				console.log(data);
				getCommentList(boardNo);
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
//좋아요 개수
function getLikeCount(){
	$.ajax({
		url:`${pageContext.request.contextPath}/member/getLikeCount/\${boardDetail.no}`,
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
		url:`${pageContext.request.contextPath}/member/unlike/\${boardDetail.no}?${_csrf.parameterName}=${_csrf.token}`,
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
//좋아요
function like(){
	$.ajax({
		url:`${pageContext.request.contextPath}/member/like?${_csrf.parameterName}=${_csrf.token}`,
		method:"POST",
		data:{
			"no":boardDetail.no
		},
		success(data){
			console.log("좋아요 data", data);
			$(".like").css("display","inline");			 			
 			$(".unlike").css("display","none");
 			getLikeCount();
 			
		    const data1 = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${boardDetail.writer}@${loginMember.id}님이 좋아요를 눌렀습니다.@\${boardDetail.no}@일반@\${boardDetail.writer}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data1);
		    websocket.send(jsonData);	
		},
		error(xhr, statusText, err){
			switch(xhr.status){
			default: console.log(xhr, statusText, err);
			}
			console.log
		}
	})
}

</script>
<style>
/* 게시물 상세보기 옆으로 넘기기 */
.board-img-move {
	width:50px;
	height:50px;
}
.img-move-button-container {
	position:absolute;z-index:3; width:100%; left:0px;
}
.right-button {
	float:right;
}
.right-button:hover, .left-button:hover {
	cursor:pointer;
}
</style>