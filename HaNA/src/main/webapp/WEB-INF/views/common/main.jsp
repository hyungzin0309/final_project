<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="메인화면" name="title"/>
</jsp:include>

    <!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/main.css" />
<sec:authentication property="principal" var="loginMember" />
<style id="mainCss"></style>
<script>
//댓글리스트 가져오기
//css넣어주기
const forEachCss = (index)=>{
	let css=``;
	css=`/* 보여줄 구간의 높이와 넓이 설정 */ 
		#slideShow\${index}{ 
		width: 614px; 
	height: 402px; 
	position: relative; 
	margin: auto; 
	overflow: hidden; 

	/*리스트 형식으로 이미지를 일렬로 정렬할 것이기 때문에, 500px 밖으로 튀어 나간 이미지들은 hidden으로 숨겨줘야됨*/ } 
	.slides\${index}{ 
		position: absolute; 
		left: 0; 
		top: 0;
		 width: 614px; 
		 /* 슬라이드할 사진과 마진 총 넓이 */ 
		 transition: left 0.5s ease-out; 
		 /*ease-out: 처음에는 느렸다가 점점 빨라짐*/ 
		 } 
	/* 첫 번째 슬라이드 가운데에 정렬하기위해 첫번째 슬라이드만 margin-left조정 */ 
	/* .slides li:first-child{ margin-left: 100px; }  */
	/* 슬라이드들 옆으로 정렬 */ 
	.slides\${index} li:not(:last-child){ float: left; margin-right: 100px; } 
	.slides\${index} li{ float: left; } 
	.controller\${index} span{ position:absolute; background-color: transparent; color: black; text-align: center; border-radius: 50%; padding: 10px 20px; top: 50%; font-size: 1.3em; cursor: pointer; }


	.controller\${index} span{ 
		position:absolute; 
		background-color: 
		transparent; 
		color: black; 
		text-align: center; 
		border-radius: 50%; 
		padding: 10px 20px; 
		top: 50%; 
		font-size: 1.3em; 
		cursor: pointer; 
	background-color: rgba(128, 128, 128, 0.41);
		} 
		

	/* 이전, 다음 화살표에 마우스 커서가 올라가 있을때 */ 
	.controller\${index} span:hover{ 
		background-color: rgba(128, 128, 128, 0.41); } 
		.prev{ left: 10px; 
		} 
	/* 이전 화살표에 마우스 커서가 올라가 있을때 이전 화살표가 살짝 왼쪽으로 이동하는 효과*/ 
	.prev\${index}:hover{ 
		transform: translateX(-10px); 
		} 
	.next\${index}{ 
		right: 10px; 
		} 
	/* 다음 화살표에 마우스 커서가 올라가 있을때 이전 화살표가 살짝 오른쪽으로 이동하는 효과*/ 
	.next\${index}:hover{ 
		transform: translateX(10px); 
		}`;
	$("#mainCss").append(css);
};
const forEachLikeCss = (index)=>{
	let css=``;
	css=`.btn_like\${index} {
		  position: relative;
		  display: inline-block;
		  width: 44px;
		  height: 44px;
		  border: 1px solid #e8e8e8;
		  border-radius: 44px;
		  font-family: notokr-bold,sans-serif;
		  font-size: 14px;
		  line-height: 16px;
		  background-color: #fff;
		  color: #DD5D54;
		  box-shadow: 0 2px 2px 0 rgba(0,0,0,0.03);
		  transition: border .2s ease-out,box-shadow .1s ease-out,background-color .4s ease-out;
		  cursor: pointer;
		}

		.btn_like\${index}:hover {
		  border: 1px solid rgba(228,89,89,0.3);
		  background-color: rgba(228,89,89,0.02);
		  box-shadow: 0 2px 4px 0 rgba(228,89,89,0.2);
		}

		.btn_unlike\${index} .img_emoti\${index} {
		    background-position: -30px -120px;
		}

		.img_emoti\${index} {
		    display: inline-block;
		    overflow: hidden;
		    font-size: 0;
		    line-height: 0;
		    background: url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/img_emoti.png?v=20180410) no-repeat;
		    text-indent: -9999px;
		    vertical-align: top;
		    width: 20px;
		    height: 17px;
		    margin-top: 1px;
		    background-position: 0px -120px;
		    text-indent: 0;
		}

		.btn_like\${index} .ani_heart_m\${index} {
		    margin: -63px 0 0 -63px;
		}

		.ani_heart_m\${index} {
		    display: block;
		    position: absolute;
		    top: 50%;
		    left: 50%;
		    width: 125px;
		    height: 125px;
		    margin: -63px 0 0 -63px;
		    pointer-events: none;
		}

		.ani_heart_m.hi\${index} {
		    background-image: url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/retina/zzim_on_m.png);
		    -webkit-background-size: 9000px 125px;
		    background-size: 9000px 125px;
		    animation: on_m 1.06s steps(72);
		}

		.ani_heart_m.bye\${index} {
		    background-image: url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/retina/zzim_off_m.png);
		    -webkit-background-size: 8250px 125px;
		    background-size: 8250px 125px;
		    animation: off_m 1.06s steps(66);
		}

		@keyframes on_m {
		  from { background-position: 0 }
		  to { background-position: -9000px }
		}

		@keyframes off_m {
		  from { background-position: 0 }
		  to { background-position: -8250px }
		}`;
	$("#mainCss").append(css);
};
const slideWidth = 800; //한개의 슬라이드 넓이 
const slideMargin = 0; //슬라이드간의 margin 값 
</script>
    <!--  -->
    <c:if test="${empty groupboard and empty board}">
    <div class="container mt-5">
	<h1 style="margin-left: 50px">추천 친구</h1>
        <div class="d-flex align-items-center cards">
    <c:forEach items="${popularList}" var="member" varStatus="vs">

            <div class="card">
                <div class="mb-3"> <span class="text-grey fs-5">${vs.count}등</span> <span class="light-grey fs-6"></span> </div>
                <div class="h5"> <a href="#">팔로워 : ${member.count}명</a> </div>
                <div class="mt-auto">
                    <div class="d-flex align-items-center">
                        <div class="profile"> <img src="${pageContext.request.contextPath }/resources/upload/member/profile/${member.picture}"> </div>
                        <a href="${pageContext.request.contextPath }/member/memberView/${member.memberId}">
                        <div class="ms-2">
                            <div class="light-grey fs-6">${member.memberId}</div>
                            <div class="text-grey fs-5">${member.name}</div>
                        </div>
                        </a>
                    </div>
                </div>
            </div>
     </c:forEach>
        </div>
    </div>

     </c:if>
    
    <!-- 다시만든 main -->
    <main>
    <div class="feeds">
	    <c:if test="${not empty groupboard}">
        <c:forEach items="${groupboard}" var="groupboard" varStatus="vss">
    <article>
    <table id="maintable">
    <tr>
    <td >
    <div  style="width: 200px;display: inline-block;cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/member/memberView/${groupboard.writer}'">
              <img class="img-profile pic" src="${pageContext.request.contextPath }/resources/upload/member/profile/${groupboard.writerProfile}">
              <span class="userID main-id point-span">${groupboard.writer}</span>
    </div>
    <a href="javascript:void(0);" onclick="boardDetailVeiw('${groupboard.no}','1','${groupboard.writer}','${groupboard.groupId}')"">
    		<img style="width:32px;height:32px;margin-left: 250px;" src="${pageContext.request.contextPath }/resources/upload/group/profile/${groupboard.groupImage}">
    		<span>${groupboard.groupName}</span>
    </a>

    </td>
    </tr>
    <tr>
    <td>     	
           <div class="main-image" id="slideShow${vss.index }">
          	<ul class="slides${vss.index }">
				<c:forEach items="${groupboard.image}" var="images" varStatus="vs">
	          	<li><img width="610px" height="400px" src="${pageContext.request.contextPath }/resources/upload/group/board/${images}"></li>
	          	</c:forEach>
          	</ul>
            <p class="controller${vss.index }">
	            <span class="prev${vss.index }">&lang;</span> 
	            <span class="next${vss.index }">&rang;</span>
            </p>
          </div>
    </td>
    </tr>
    <tr>
    <td>
    
<button type="button" class="btn_like${vss.index }">
  <span class="img_emoti${vss.index }">좋아요</span>
  <span class="ani_heart_m${vss.index }"></span>
</button>
              <img class="icon-react" src="${pageContext.request.contextPath }/resources/images/icons/chat.svg" alt="말풍선">
              <a onclick="DMsend('${groupboard.writer}');" style="cursor: pointer"><img class="icon-react" src="${pageContext.request.contextPath }/resources/images/icons/send.svg" alt="DM"></a>  
    </td>
    </tr>
    <tr>
    <td id="likeCount${vss.index }">
              <span></span>
    </td>
    </tr>
    <tr>
    <td width="550px" style="word-break:break-all">
              <span class="main-header-comment">
              <img class="img-profile pic" src="${pageContext.request.contextPath }/resources/upload/member/profile/${groupboard.writerProfile}">${groupboard.writer} ${groupboard.content}
              </span>
    </td>
    </tr>
    <tr>
    <td>
              <span class="at-tag">
				<c:forEach items="${groupboard.tagMembers}" var="tagmembers" varStatus="vs">
              	@${tagmembers}
              	</c:forEach>
              </span>
    </td>
    </tr>
    <tr>
    <td class="commentTd${vss.index }">
				<div class="comment-section">
			         <ul class="comments${vss.index }">
		              </ul>
		            </div>
                          
    </td>
    </tr> 
    <tr>
    <td>
    		<div class="hl"></div>
          <div class="comment">
            <input id="input-comment${vss.index }" class="input-comment" type="text" placeholder="댓글 달기..." >
            <button type="button" class="submit-comment" onclick="commetWrite${vss.index}();">게시</button>
          </div>
    </td>
    </tr>  
    </table>
    </article>
        <script>
        <!-- mainCss에 append해주기 -->
       forEachCss(${vss.index });
       forEachLikeCss(${vss.index });
       let i${vss.index };
       let likeBoolean${vss.index };
const slides${vss.index } = document.querySelector('.slides${vss.index }'); //전체 슬라이드 컨테이너 
const slideImg${vss.index } = document.querySelectorAll('.slides${vss.index } li'); //모든 슬라이드들
let currentIdx${vss.index } = 0; //현재 슬라이드 index 
const slideindex${vss.index } = slideImg${vss.index }.length; // 슬라이드 개수 


//전체 슬라이드 컨테이너 넓이 설정  (slideWidth + slideMargin) * slideindex + 'px';
/* console.log("sdfsdf",${vss.index });
console.log("slides${vss.index } = ",slides${vss.index });
console.log("slideImg${vss.index } = ",slideImg${vss.index });
console.log("slideindex${vss.index } = ",slideindex${vss.index }); */
slides${vss.index }.style.width = (slideWidth + slideMargin) * slideindex${vss.index } + 'px';


function moveSlide${vss.index }(num${vss.index }) { 
	slides${vss.index }.style.left = -num${vss.index } * 715 + 'px'; 
	currentIdx${vss.index } = num${vss.index }; 
	} 


$(`.prev${vss.index }`).on('click', function () { 
	/*첫 번째 슬라이드로 표시 됐을때는 이전 버튼 눌러도 아무런 반응 없게 하기 위해 currentIdx !==0일때만 moveSlide 함수 불러옴 */ 
	if (currentIdx${vss.index } !== 0) moveSlide${vss.index }(currentIdx${vss.index } - 1); 

	}); 
$(`.next${vss.index }`).on('click', function () { 
		/* 마지막 슬라이드로 표시 됐을때는 다음 버튼 눌러도 아무런 반응 없게 하기 위해 currentIdx !==slideindex - 1 일때만 moveSlide 함수 불러옴 */ 
		if (currentIdx${vss.index } !== slideindex${vss.index } - 1) { 
			moveSlide${vss.index }(currentIdx${vss.index } + 1); 

			} 
		});

//forEach문에서 댓글 불러오기
	$.ajax({
		url : `${pageContext.request.contextPath}/chat/boardcommentList.do`,
		data : {
			boardNo : ${groupboard.no}
		},
		method: "GET",
		success(resp){
			
			/* console.log("${vss.index } =",resp); */
			let commentList =``;
				$(resp).each((i, comment) => {
					const {boardNo, commentLevel, commentRef, content, no, regDate, writer} = comment;
					const date = moment(regDate).format("YYYY년 MM월 DD일");
					commentList += `<li>
		                  <span class="\${commentLevel === 1 ?  '' : 'commentLevel2'}"><span class="point-span userID">\${writer}</span>\${content}\${commentLevel === 1 ?  '<button class="btn btn-primary btn-sm" id="commentLev2btn" type="button" onclick="commentLev2('+no+','+boardNo+',\'' + writer + '\',\'${groupboard.groupId}\');">답글</button>' : ''}</span>
		                </li>
		                <li id='\${commentLevel === 1 ?  'Level2Comment'+no+'' : 'Level2Comment'+commentRef+''}'>
			              <div class="time-log">
			                <span class="\${commentLevel === 1 ?  '' : 'commentLevel2'}">\${date}</span>
			              </div>
		                </li>  `;
					
				});
							
				$(".commentTd${vss.index} .comments${vss.index }").html(commentList);

		},
        error:console.log
	});
	
//forEach에서 일반 댓글쓰기
const commetWrite${vss.index}=()=>{
	/* console.log("vvsindex = ", ${vss.index}); */
	let msg = $("input#input-comment${vss.index}").val();
	if(msg == ''){
		alert("메세지를 입력하세요");
		return;		
	}
		
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/insertgroupBoardcomment.do`,
		method:"GET",
		data:{
			writer : memberId,
			boardNo : ${groupboard.no},
			content : msg,
			commentLevel : 1,
			commentRef : 0,
		},
		success(resp){
			console.log("msg = ",msg);
			const date = moment(today).format("YYYY년 MM월 DD일");
			const {boardNo, commentLevel, commentRef, content, no, regDate, writer} = resp;
			let commentList =`<li>
		        <span><span class="point-span userID">${loginMember.id}</span>\${msg}\${commentLevel === 1 ?  '<button class="btn btn-primary btn-sm" type="button" onclick="commentLev2('+no+','+boardNo+',\'' + writer + '\',\'${groupboard.groupId}\');">답글</button>' : ''}</span>
		        </li>
		        <li id='\${commentLevel === 1 ?  'Level2Comment'+no+'' : 'Level2Comment'+commentRef+''}'>
		          <div class="time-log">
		            <span>\${date}</span>
		          </div>
		        </li>  `;
			$(".commentTd${vss.index} .comments${vss.index }").append(commentList);
			$("input#input-comment${vss.index}").val('');
			
		    const data = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `${groupboard.writer}@${loginMember.id}님이 댓글을 등록했습니다.@${groupboard.no}@그룹@${groupboard.groupId}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data);
		    websocket.send(jsonData);
				
			
		},
        error:console.log
	});
};

//forEach에서 좋아요 불러오기
$.ajax({
	url : `${pageContext.request.contextPath}/chat/groupboardLikeCount.do`,
	data : {
		boardNo : ${groupboard.no}
	},
	method: "GET",
	success(resp){
		/* console.log(resp); */
		i${vss.index } = resp;
		/* console.log("${vss.index }=",i${vss.index }); */
		$("#likeCount${vss.index } span").html((i${vss.index } >0 ? i${vss.index }+`명이 좋아합니다` : ''));
	},
    error:console.log
});

//forEach에서 내가 좋아요 누른 여부 확인
$.ajax({
	url : `${pageContext.request.contextPath}/chat/grouplikeCheck.do`,
	data : {
		boardNo : ${groupboard.no},
		memberId : memberId,
	},
	method: "GET",
	success(resp){
		/* console.log("${vss.index }=",resp); */
		likeBoolean${vss.index } = resp;
		if(resp){
		    $('button.btn_like${vss.index }').addClass('btn_unlike${vss.index }');
		    $('.ani_heart_m${vss.index }').addClass('hi');
		    $('.ani_heart_m${vss.index }').removeClass('bye');	
 		}else{
		    $('button.btn_like${vss.index }').removeClass('btn_unlike${vss.index }');
		    $('.ani_heart_m${vss.index }').removeClass('hi');
		    $('.ani_heart_m${vss.index }').addClass('bye');	 				 			
 		};

	},
    error:console.log
});

//좋아요 누를때
$('button.btn_like${vss.index }').click(function(){
	  if($(this).hasClass('btn_unlike${vss.index }')){
	    $(this).removeClass('btn_unlike${vss.index }');
	    $('.ani_heart_m${vss.index }').removeClass('hi');
	    $('.ani_heart_m${vss.index }').addClass('bye');
	    /* console.log("11111111111111delete"); */
	    deleteLike${vss.index }();
	  }
	  else{
	    $(this).addClass('btn_unlike${vss.index }');
	    $('.ani_heart_m${vss.index }').addClass('hi');
	    $('.ani_heart_m${vss.index }').removeClass('bye');
	    /* console.log("222222222222222222insert"); */
	    insertLike${vss.index }();
	  }
	});

const insertLike${vss.index }=()=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/insertLike.do`,
		method:"GET",
		data:{
			memberId : memberId,
			no : ${groupboard.no},
		},
		success(resp){
			/* console.log(resp); */
			if(resp != null){
				likeBoolean${vss.index } = true;
				i${vss.index } = i${vss.index }+1;
				/* console.log("${vss.index }=",i${vss.index }); */
				$("#likeCount${vss.index } span").html((i${vss.index } >0 ? i${vss.index }+`명이 좋아합니다` : ''));
				<!-- 좋아요 메세지 -->
			    const data = {
			            "roomNo" : 226,
			            "memberId" : `${loginMember.id}`,
			            "message"   : `${groupboard.writer}@${loginMember.id}님이 좋아요를 눌렀습니다.@${groupboard.no}@그룹@${groupboard.groupId}`,
			            "picture" : `${loginMember.picture}`,
			            "messageRegDate" : today
			        }; 
			    let jsonData = JSON.stringify(data);
			    websocket.send(jsonData);
			}
			else
				console.log("441번째 줄");
		},
        error:console.log
	});
};
const deleteLike${vss.index }=()=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/deleteLike.do`,
		method:"GET",
		data:{
			memberId : memberId,
			no : ${groupboard.no},
		},
		success(resp){
			/* console.log(resp); */
			if(resp != null){
				likeBoolean${vss.index } = false;
				i${vss.index } = i${vss.index }-1;
				/* console.log("${vss.index }=",i${vss.index }); */
				$("#likeCount${vss.index } span").html((i${vss.index } >0 ? i${vss.index }+`명이 좋아합니다` : ''));
			}
			else
				console.log("436번째 줄");
		},
        error:console.log
	});
};
</script>

        </c:forEach>
        </c:if>
        
        
        <!-- 맴버게시판@@@@@@@@@@@@@@@@@@ -->
	    <c:if test="${not empty board}">
        <c:forEach items="${board}" var="board" varStatus="vss">
    <article>
    <table>
    <tr>
    <td>
    <div  style="width: 200px;display: inline-block;cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/member/memberView/${board.writer}'">
              <img class="img-profile pic" src="${pageContext.request.contextPath }/resources/upload/member/profile/${board.writerProfile}">
              <span class="userID main-id point-span">${board.writer}</span>
    </div>
    <a style="margin-left: 330px;" href="javascript:void(0);" onclick="boardDetailVeiw('${board.no}','0','${board.writer}','')">
    		<span>상세보기</span>
    </a>
    </td>
    </tr>
    <tr>
    <td>     	
           <div class="main-image" id="slideShow0${vss.index }">
          	<ul class="slides0${vss.index }">
				<c:forEach items="${board.picture}" var="images" varStatus="vs">
	          	<li><img width="610px" height="400px" src="${pageContext.request.contextPath }/resources/upload/member/board/${images}"></li>
	          	</c:forEach>
          	</ul>
            <p class="controller0${vss.index }">
	            <span class="prev0${vss.index }">&lang;</span> 
	            <span class="next0${vss.index }">&rang;</span>
            </p>
          </div>
    </td>
    </tr>
    <tr>
    <td>
<button type="button" class="btn_like0${vss.index }">
  <span class="img_emoti0${vss.index }">좋아요</span>
  <span class="ani_heart_m0${vss.index }"></span>
</button>
              <img class="icon-react" src="${pageContext.request.contextPath }/resources/images/icons/chat.svg" alt="말풍선">
              <a onclick="DMsend('${board.writer}');" style="cursor: pointer"><img class="icon-react" src="${pageContext.request.contextPath }/resources/images/icons/send.svg" alt="DM"></a>  
    </td>
    </tr>
    <tr>
    <td id="likeCount0${vss.index }">
              <span></span>
    </td>
    </tr>
    <tr>
    <td width="550px" style="word-break:break-all">
              <span class="main-header-comment">
              <img class="img-profile pic" src="${pageContext.request.contextPath }/resources/upload/member/profile/${board.writerProfile}">${board.writer} ${board.content}
              </span>
    </td>
    </tr>
<%--     <tr>
    <td>
              <span class="at-tag">
				<c:forEach items="${groupboard.tagMembers}" var="tagmembers" varStatus="vs">
              	@${tagmembers}
              	</c:forEach>
              </span>
    </td>
    </tr> --%>
    <tr>
    <td class="commentTd0${vss.index }">
				<div class="comment-section">
			         <ul class="comments0${vss.index }">
		              </ul>
		            </div>
                          
    </td>
    </tr> 
    <tr>
    <td>
    		<div class="hl"></div>
          <div class="comment">
            <input id="input-comment0${vss.index }" class="input-comment" type="text" placeholder="댓글 달기..." >
            <button type="button" class="submit-comment" onclick="commetWrite0${vss.index}();">게시</button>
          </div>
    </td>
    </tr>  
    </table>
    </article>

        <script>
        <!-- mainCss에 append해주기 -->
       forEachCss('0'+${vss.index });
       forEachLikeCss('0'+${vss.index });
       let i0${vss.index };
       let likeBoolean0${vss.index };
const slides0${vss.index } = document.querySelector('.slides0${vss.index }'); //전체 슬라이드 컨테이너 
const slideImg0${vss.index } = document.querySelectorAll('.slides0${vss.index } li'); //모든 슬라이드들
let currentIdx0${vss.index } = 0; //현재 슬라이드 index 
const slideindex0${vss.index } = slideImg0${vss.index }.length; // 슬라이드 개수 


//전체 슬라이드 컨테이너 넓이 설정  (slideWidth + slideMargin) * slideindex + 'px';
/* console.log("sdfsdf",'0'+${vss.index });
console.log("slides0${vss.index } = ",slides0${vss.index });
console.log("slideImg0${vss.index } = ",slideImg0${vss.index });
console.log("slideindex0${vss.index } = ",slideindex0${vss.index }); */
slides0${vss.index }.style.width = (slideWidth + slideMargin) * slideindex0${vss.index } + 'px';


function moveSlide0${vss.index }(num0${vss.index }) { 
	slides0${vss.index }.style.left = -num0${vss.index } * 715 + 'px'; 
	currentIdx0${vss.index } = num0${vss.index }; 
	} 


$(`.prev0${vss.index }`).on('click', function () { 
	/*첫 번째 슬라이드로 표시 됐을때는 이전 버튼 눌러도 아무런 반응 없게 하기 위해 currentIdx !==0일때만 moveSlide 함수 불러옴 */ 
	if (currentIdx0${vss.index } !== 0) moveSlide0${vss.index }(currentIdx0${vss.index } - 1); 

	}); 
$(`.next0${vss.index }`).on('click', function () { 
		/* 마지막 슬라이드로 표시 됐을때는 다음 버튼 눌러도 아무런 반응 없게 하기 위해 currentIdx !==slideindex - 1 일때만 moveSlide 함수 불러옴 */ 
		if (currentIdx0${vss.index } !== slideindex0${vss.index } - 1) { 
			moveSlide0${vss.index }(currentIdx0${vss.index } + 1); 

			} 
		});

//forEach문에서 댓글 불러오기
 	$.ajax({
		url : `${pageContext.request.contextPath}/chat/memberboardcommentList.do`,
		data : {
			boardNo : ${board.no}
		},
		method: "GET",
		success(resp){
			
			/* console.log("0${vss.index } =",resp); */
			let commentList =``;
				$(resp).each((i, comment) => {
					const {boardNo, commentLevel, commentRef, content, no, regDate, writer} = comment;
					const date = moment(regDate).format("YYYY년 MM월 DD일");
					commentList += `<li>
		                  <span class="\${commentLevel === 1 ?  '' : 'commentLevel2'}"><span class="point-span userID">\${writer}</span>\${content}\${commentLevel === 1 ?  '<button class="btn btn-default" id="commentLev2btn" type="button" onclick="commentLev20('+no+','+boardNo+',\'' + writer + '\',\'${board.writer}\');">답글</button>' : ''}</span>
		                </li>	                
		                <li id='\${commentLevel === 1 ?  'Level2Comment0'+no+'' : 'Level2Comment0'+commentRef+''}'>
			              <div class="time-log">
			                <span class="\${commentLevel === 1 ?  '' : 'commentLevel2'}">\${date}</span>
			              </div>
		                </li>  `;
					
				});
				$(".commentTd0${vss.index} .comments0${vss.index }").html(commentList);

		},
        error:console.log
	});
	
//forEach에서 일반 댓글쓰기
const commetWrite0${vss.index}=()=>{
	/* console.log("0vvsindex = ", '0'+${vss.index}); */
	let msg = $("input#input-comment0${vss.index}").val();
	if(msg == ''){
		alert("메세지를 입력하세요");
		return;		
	}
		
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/insertmemberBoardcomment.do`,
		method:"GET",
		data:{
			writer : memberId,
			boardNo : ${board.no},
			content : msg,
			commentLevel : 1,
			commentRef : 0,
		},
		success(resp){
			console.log("msg = ",msg);
			const date = moment(today).format("YYYY년 MM월 DD일");
			const {boardNo, commentLevel, commentRef, content, no, regDate, writer} = resp;
			let commentList =`<li>
		        <span><span class="point-span userID">${loginMember.id}</span>\${msg}\${commentLevel === 1 ?  '<button class="btn btn-primary btn-sm" type="button" onclick="commentLev20('+no+','+boardNo+',\'' + writer + '\',\'${board.writer}\');">답글</button>' : ''}</span>
		        </li>
		        <li id='\${commentLevel === 1 ?  'Level2Comment0'+no+'' : 'Level2Comment0'+commentRef+''}'>
		          <div class="time-log">
		            <span>\${date}</span>
		          </div>
		        </li>  `;
			$(".commentTd0${vss.index} .comments0${vss.index }").append(commentList);
			$("input#input-comment0${vss.index}").val('');
			
			
		    const data = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `${board.writer}@${loginMember.id}님이 댓글을 등록했습니다.@${board.no}@일반@${board.writer}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data);
		    websocket.send(jsonData);
	
		},
        error:console.log
	});

};

//멤버 게시글

//forEach에서 좋아요 불러오기
$.ajax({
	url : `${pageContext.request.contextPath}/chat/memberboardLikeCount.do`,
	data : {
		boardNo : ${board.no}
	},
	method: "GET",
	success(resp){
 		console.log(resp);
		/* console.log("0${vss.index }=",i0${vss.index }); */
		i0${vss.index } = resp;
		$("#likeCount0${vss.index } span").html((i0${vss.index } >0 ? i0${vss.index }+`명이 좋아합니다` : ''));
	},
    error:console.log
});

//forEach에서 내가 좋아요 누른 여부 확인
$.ajax({
	url : `${pageContext.request.contextPath}/chat/MemberlikeCheck.do`,
	data : {
		boardNo : ${board.no},
		memberId : memberId,
	},
	method: "GET",
	success(resp){

		likeBoolean0${vss.index } = resp;
		if(resp){
		    $('button.btn_like0${vss.index }').addClass('btn_unlike0${vss.index }');
		    $('.ani_heart_m0${vss.index }').addClass('hi');
		    $('.ani_heart_m0${vss.index }').removeClass('bye');	
		}else{
		    $('button.btn_like0${vss.index }').removeClass('btn_unlike0${vss.index }');
		    $('.ani_heart_m0${vss.index }').removeClass('hi');
		    $('.ani_heart_m0${vss.index }').addClass('bye');	 				 			
		};

	},
    error:console.log
});

//좋아요 누를때
$('button.btn_like0${vss.index }').click(function(){
	  if($(this).hasClass('btn_unlike0${vss.index }')){
	    $(this).removeClass('btn_unlike0${vss.index }');
	    $('.ani_heart_m0${vss.index }').removeClass('hi');
	    $('.ani_heart_m0${vss.index }').addClass('bye');
	    deleteLike0${vss.index }();
	  }
	  else{
	    $(this).addClass('btn_unlike0${vss.index }');
	    $('.ani_heart_m0${vss.index }').addClass('hi');
	    $('.ani_heart_m0${vss.index }').removeClass('bye');
	    insertLike0${vss.index }();
	  }
	});


//멤버 그룹
const insertLike0${vss.index }=()=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/MemberBoardinsertLike.do`,
		method:"GET",
		data:{
			memberId : memberId,
			no : ${board.no},
		},
		success(resp){
			if(resp != null){
				likeBoolean0${vss.index } = true;
				i0${vss.index } = i0${vss.index }+1;
				$("#likeCount0${vss.index } span").html((i0${vss.index } >0 ? i0${vss.index }+`명이 좋아합니다` : ''));
				<!-- 좋아요 메세지 -->
			    const data = {
			            "roomNo" : 226,
			            "memberId" : `${loginMember.id}`,
			            "message"   : `${board.writer}@${loginMember.id}님이 좋아요를 눌렀습니다.@${board.no}@일반@${board.writer}`,
			            "picture" : `${loginMember.picture}`,
			            "messageRegDate" : today
			        }; 
			    let jsonData = JSON.stringify(data);
			    websocket.send(jsonData);
			}
			else
				console.log("736번째 줄");
		},
        error:console.log
	});
};
const deleteLike0${vss.index }=()=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/MemberBoarddeleteLike.do`,
		method:"GET",
		data:{
			memberId : memberId,
			no : ${board.no},
		},
		success(resp){
			/* console.log(resp); */
			if(resp != null){
				likeBoolean0${vss.index } = false;
				i0${vss.index } = i0${vss.index }-1;
				/* console.log("0${vss.index }=",i0${vss.index }); */
				$("#likeCount0${vss.index } span").html((i0${vss.index } >0 ? i0${vss.index }+`명이 좋아합니다` : ''));				
			}
			else
				console.log("758번째 줄");
		},
        error:console.log
	});
};

</script>
        </c:forEach>
        </c:if>


        
    </div>
    <!-- 여기까지 feed div -->
    
          <!-- main-right -->
      <div class="main-right">
        <div class="myProfile">
          <img class="pic" src="${pageContext.request.contextPath }/resources/upload/member/profile/${loginMember.picture}">
          <div style="cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/member/memberView/${loginMember.id}'">
            <span class="userID point-span">${loginMember.id}</span>
            <span class="sub-span">${loginMember.name}</span>  
          </div>
        </div>

<c:if test="${not empty groupboard or not empty board}">   
        <!-- recommendation section -->
        <div class="section-recommend">
          <div class="menu-title">
            <span class="sub-title">회원님을 위한 추천</span>
            <!-- <span class="find-more">모두 보기</span> -->
          </div>
<ul class="recommend-list">
          <c:if test="${not empty memberList}">
          <c:forEach items="${memberList}" var="member" varStatus="vs">
            <li id="li${vs.index}${member.id}">
              <div class="recommend-friend-profile">
                <img class="img-profile" src="${pageContext.request.contextPath }/resources/upload/member/profile/${member.picture}">
                <div class="profile-text">
                  <span class="userID point-span">${member.id}</span>
                  <span class="sub-span">${member.name != null ? '나를 팔로잉한 친구' : (member.addressFull == null ? '같은 소모임에 있는 친구': '가장 인기 있는 친구')}</span>
                </div>
              </div>
              <span class="btn-follow" onclick="insertFollow('${member.id}','${vs.index}');" style="cursor: pointer">팔로우</span>
            </li>
          </c:forEach>
          </c:if>
</ul>
        </div>
 </c:if>

      </div>
    </main>
	

<script>
const insertFollow =(id,index)=>{
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/following.do`,
		method:"GET",
		data:{
			id : id,
			loginId : memberId,
		},
		success(resp){
			if(resp !== 0)
				$("#li"+index+id).remove();
			else
				console.log("팔로우 실패");
		},
        error:console.log
	});
};
const DMsend=(writer)=>{
	console.log(writer);
	console.log(memberId);
	if(confirm("디엠을 보내시겠습니까?")){
		$.ajax({
			url:`${pageContext.request.contextPath}/chat/mainPageDmSend.do`,
			method:"GET",
			data:{
				memberId : writer,
				loginId : memberId,
			},
			success(resp){
				console.log(resp);
				if(resp !== 0){
					location.href = `${pageContext.request.contextPath}/chat/chat.do?\${resp}`;
					<!-- 나중에 바로 채팅방 접속까지 고려 -->
				}
				else
					alert("메세지 전송 실패");
			},
	        error:console.log
		});
	}
}
//답글버튼 클릭
const commentLev20=(index,boardNo,commentwriter,boardwriter)=>{
	console.log(index);
	console.log(boardNo);
	console.log(commentwriter);
	console.log(boardwriter);
	$(".commentLevel2Message").empty();

	let message =`    		<div class="commentLevel2Message"><div class="hl"></div>
        <div class="comment">
        <input id="input-commentLevel2" class="input-comment" type="text" placeholder="대댓글 달기..." >
        <button type="button" class="submit-comment" onclick="commetLevel2Write0('\${index}','\${boardNo}','\${commentwriter}','\${boardwriter}');">게시</button>
      </div><div class="hl"></div></div>`;
	$("#Level2Comment"+0+index).append(message);
}
//답글-> 게시 클릭
const commetLevel2Write0=(index,boardNo,commentwriter,boardwriter)=>{
	console.log("sdfsdf",index);
	console.log("sdfsdf",boardNo);
	console.log("sdfsdf",commentwriter);
	console.log("sdfsdf",boardwriter);
	
 	let msg = $("#input-commentLevel2").val();
	console.log(msg); 
	$("#input-commentLevel2").val('');
	if(msg == ''){
		alert("메세지를 입력하세요");
		return;		
	}
	
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/insertmemberBoardcommentLevel2.do`,
		method:"GET",
		data:{
			writer : memberId,
			boardNo : boardNo,
			content : msg,
			commentLevel : 2,
			commentRef : index,
		},
		success(resp){
			console.log('댓글작성');
		    const data = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${commentwriter}@${loginMember.id}님이 대댓글을 등록했습니다.@\${boardNo}@일반@\${boardwriter}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data);
		    websocket.send(jsonData);
		},
        error:console.log
	});

	const date = moment(today).format("YYYY년 MM월 DD일");
	let comment =`<li>
	    <span class="commentLevel2"><span class="point-span userID">${loginMember.id}</span>\${msg}</span>
		  </li>
		  <li id="Level2Comment0${index}">
		    <div class="time-log">
		      <span class="commentLevel2">\${date}</span>
		    </div>
		  </li>`;
	$(".commentLevel2Message").empty();
 	$("li#Level2Comment"+0+index+":last").append(comment);
}

//그룹게시판 답글버튼 클릭
const commentLev2=(index,boardNo,commentwriter,groupId)=>{
	console.log(index);
	console.log(boardNo);
	$(".commentLevel2Message").empty();

	let message =`    		<div class="commentLevel2Message"><div class="hl"></div>
        <div class="comment">
        <input id="input-commentLevel2" class="input-comment" type="text" placeholder="대댓글 달기..." >
        <button type="button" class="submit-comment" onclick="commetLevel2Write('\${index}','\${boardNo}','\${commentwriter}','\${groupId}');">게시</button>
      </div><div class="hl"></div></div>`;
	$("#Level2Comment"+index).append(message);
}
//그룹게시판 답글-> 게시 클릭
const commetLevel2Write=(index,boardNo,commentwriter,groupId)=>{
	console.log("sdfsdf",index);
	console.log("sdfsdf",boardNo);
	console.log("sdfsdf",commentwriter);
	
 	let msg = $("#input-commentLevel2").val();
	console.log(msg); 
	$("#input-commentLevel2").val('');
	if(msg == ''){
		alert("메세지를 입력하세요");
		return;		
	}
	
	$.ajax({
		url:`${pageContext.request.contextPath}/chat/insertgroupBoardcommentLevel2.do`,
		method:"GET",
		data:{
			writer : memberId,
			boardNo : boardNo,
			content : msg,
			commentLevel : 2,
			commentRef : index,
		},
		success(resp){
			console.log('댓글작성');
		    const data = {
		            "roomNo" : 226,
		            "memberId" : `${loginMember.id}`,
		            "message"   : `\${commentwriter}@${loginMember.id}님이 대댓글을 등록했습니다.@\${boardNo}@그룹@\${groupId}`,
		            "picture" : `${loginMember.picture}`,
		            "messageRegDate" : today
		        }; 
		    let jsonData = JSON.stringify(data);
		    websocket.send(jsonData);
		},
        error:console.log
	});

	const date = moment(today).format("YYYY년 MM월 DD일");
	let comment =`<li>
	    <span class="commentLevel2"><span class="point-span userID">${loginMember.id}</span>\${msg}</span>
		  </li>
		  <li id="Level2Comment${index}">
		    <div class="time-log">
		      <span class="commentLevel2">\${date}</span>
		    </div>
		  </li>`;
	$(".commentLevel2Message").empty();
 	$("li#Level2Comment"+index+":last").append(comment);
}
const boardDetailVeiw=(boardNo, type,writer,groupId) =>{
	//그룹
	if(type === '1'){
		location.href = `${pageContext.request.contextPath}/group/groupPage/\${groupId}?\${boardNo}`;
	}
	//일반
	else{
		location.href = `${pageContext.request.contextPath}/member/memberView/\${writer}?\${boardNo}`;
	}
};
</script>
    <style>
    .commentLevel2{margin-left: 50px;}
    #commentLev2btn{margin-left: 5px;}
     @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&family=Kalam&display=swap');

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif
}

body {
    background: white
}

.container {
    overflow: auto
}

.cards {
    overflow: auto;
    min-height: 550px
}

.card {
    background: #3a3a3a;
    background: linear-gradient(to right, #474747, #222);
    min-width: 300px;
    height: 380px;
    border-radius: 10px;
    box-shadow: -5px 5px 25px #0000009d;
    padding: 20px;
    border: none;
    transition: all .3s ease-in-out
}

.card .text-grey {
    color: #ccc;
    font-weight: 500
}

.card .light-grey {
    color: #aaa;
    font-weight: 300
}

.card .fs-5 {
    font-size: 1.15rem !important
}

.card a {
    color: #fff;
    text-decoration: none
}

.card .profile img {
    width: 60px;
    height: 60px;
    box-shadow: 0 5px 15px rgba(26, 25, 25, 0.329);
    object-fit: cover;
    border-radius: 50%
}

.card:not(:first-child) {
    margin-left: -8rem
}

.cards::-webkit-scrollbar {
    height: 10px
}

.cards::-webkit-scrollbar-track {
    background: inherit
}

.cards::-webkit-scrollbar-thumb {
    background-color: #3a3a3a;
    background: linear-gradient(to right, #ff002b, #002fff);
    border-radius: 10px
}

.card:hover,
.card:focus-within {
    transform: translateY(-1rem) rotateZ(5deg)
}

.card:hover~.card,
.card:focus-within~.card {
    transform: translateX(8rem)
}

.card .designation {
    display: inline;
    border-radius: 10px;
    padding: 4px 10px;
    border: 1px solid #ddd
}
    </style>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
