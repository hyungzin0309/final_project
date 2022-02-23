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


// 게시물 상세보기 페이지 불러오기 함수
function getPageDetail(boardNo){
	console.log("aaa",boardNo);
	$.ajax({
				url:`<%=request.getContextPath()%>/group/groupBoardDetail/\${boardNo}`,
				success(data){
			 
			 		const {groupBoard, tagMembers, isLiked} = data;
			 		console.log(groupBoard);
			 		console.log(tagMembers);
			 		console.log(isLiked);
		 			gb = groupBoard;
		 			
		 			// modal의 header부분
		 			const date = moment(groupBoard.regDate).format("YYYY년 MM월 DD일");
					let src = `<%=request.getContextPath()%>/resources/upload/member/profile/\${groupBoard.writerProfile}`;
			 		$("#member-profile").children("img").attr("src",src); // 글쓴이 프로필 이미지
		 	 		$("#member-id").html(`&nbsp;&nbsp<a href="${pageContext.request.contextPath}/group/groupPage/\${groupBoard.groupId}" style="color:black; text-decoration:none; font-size:1.2em;">[\${groupBoard.groupId}]</a><a href="javascript:void(0);" onclick="goMemberView('\${groupBoard.writer}');" style="color:black; text-decoration:none;">&nbsp;&nbsp;\${groupBoard.writer}</a>`); // 글쓴이 아이디
			 		$("#reg-date").html(`&nbsp;&nbsp;\${date}`) // 날짜, 태그 장소
			 		
			 		// 날짜 및 태그장소
			 		$("#tag-place").html(`,&nbsp;&nbsp;\${groupBoard.placeName}`)
			 		$("[name=locationX]").val(groupBoard.locationX);
			 		$("[name=locationY]").val(groupBoard.locationY);
			 		$("[name=placeName]").val(groupBoard.placeName);
			 		$("[name=placeAddress]").val(groupBoard.placeAddress);
			 		
			 		
			 		// 좋아요 버튼
			 		if(isLiked){
			 			$(".unlike").css("display","none");
			 			$(".like").css("display","inline");
			 		}else{
			 			$(".like").css("display","none");			 			
			 			$(".unlike").css("display","inline");			 			
			 		}
		 	 		
			 		//좋아요 개수
			 		getLikeCount();
			 		
			 		// modal footer부분 - 게시물 삭제 버튼
		 	 		if("<sec:authentication property='principal.username'/>" != groupBoard.writer && "<sec:authentication property='principal.username'/>" != "${group.leaderId}"){
			 			$(".btn-deleteBoard").css("display","none");
			 		}else{
			 			$(".btn-deleteBoard").css("display","block");
			 			$(document.groupBoardDeleteFrm)
			 				.children("[name=no]").val(boardNo);
			 		}
					
		 	 		
			 		// 이미지
			 		$("#group-board-img-container").empty();
			 		const button = `<div class="img-move-button-container">
				        <img class="board-img-move left-button" src="<%=request.getContextPath()%>/resources/images/icons/left1.png" alt="" />
				        <img class="board-img-move right-button" src="<%=request.getContextPath()%>/resources/images/icons/right1.png" alt="" />
				        </div>`
			 		$("#group-board-img-container").append(button);
				        
			 		$.each(groupBoard.image, (i,e)=>{
		 				
		 				let img = `<img id='img\${i}' src='<%=request.getContextPath()%>/resources/upload/group/board/\${e}' alt="" class="group-board-img"/>`
		 				$("#group-board-img-container").append(img); // 이미지 추가
			  			$(`#img\${i}`).css("display","none");
		 				maxIndex = i;
		 			})
		 			
		 			$(".group-board-img").css("width","100%");
		 			$(".group-board-img").css("position","absolute");
		  			$(".group-board-img").css("left","0");
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
		 			getContent();
		 			
		 			//댓글 리스트
		 			getCommentList(groupBoard.no);
		 			
		 			//댓글 입력창
		 			$("#group-board-comment-submit #boardNo").val(groupBoard.no);
		 				
		 			//모달 노출
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
//좋아요 개수
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

		    const data1 = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${gb.writer}@${loginMember.id}님이 좋아요를 눌렀습니다.@\${gb.no}@그룹@\${gb.groupId}`,
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
// 게시물 불러오기 함수
function getContent(){
	let boardContent = `\${gb.content}</br>`
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
			<textarea style="height:100%;" name="content">\${gb.content}</textarea>
		</div>
		<button class="btn-submitContent" onclick="submitModifiedContent(this);">등록</button>
	`;
	$("#group-board-content").append(form);
	
	// textarea의 변경값 실시간 감지
	$("textarea[name=content]").on("propertychange change keyup paste input", function() {
	   // 현재 변경된 데이터 셋팅
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
			"no":no,
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
					if(e.writer == "<sec:authentication property='principal.username'/>" || "<sec:authentication property='principal.username'/>" == "${group.leaderId}"){ //댓글 레벨 1 && 내가 작성자일 때 (삭제, 답글 버튼 모두)
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
	// 클릭이벤트핸들러 제거!
	// 답글 다는 동안 답글버튼 또 눌렀을 때 새로운 html생성되는 것 방지
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
				
			<!-- 게시글 작성자한테 -->
			if($("[name=commentLevel]",e.target).val() === '1'){			
		    const data1 = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${gb.writer}@${loginMember.id}님이 댓글을 등록했습니다.@\${boardNo}@그룹@\${gb.groupId}`,
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
			            "message"   : `\${commentwriter}@${loginMember.id}님이 대댓글을 등록했습니다.@\${boardNo}@그룹@\${gb.groupId}`,
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


</script>