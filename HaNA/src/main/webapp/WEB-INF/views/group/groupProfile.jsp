<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script src="https://kit.fontawesome.com/0748f32490.js" crossorigin="anonymous"></script>
<script>
	$(function () {
		$('#target-image').click(function (e) {
			e.preventDefault();
			$('#file').click();
		});
	});

	function changeImage(){
		alert('프로필 사진을 변경하시겠습니까?');
		document.getElementById('upFileForm').submit();
        return false;
	}

//ajax POST 요청 csrf
    var csrfToken = $("meta[name='_csrf']").attr("content");
    $.ajaxPrefilter(function(options, originalOptions, jqXHR){
	    if (options['type'].toLowerCase() === "post" || options['type'].toLowerCase() === "delete" || options['type'].toLowerCase() === "put") {
	        jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
	    }
	  });

const groupDM=(groupId, loginId)=>{
	console.log(groupId);
	console.log(loginId);
 	$.ajax({
		url:`${pageContext.request.contextPath}/chat/groupDM.do`,
		method:"GET",
		data:{
			groupId : groupId,
			loginId : loginId
		},
		success(resp){
			console.log("map =",resp);
 			if(resp.check === true){
				location.href = `${pageContext.request.contextPath}/chat/chat.do?\${resp.roomNo}`;
			}
			else
				alert("소모임 회원이 아닙니다.");
		},
        error:console.log
	});
	
};
</script>
<sec:authentication property="principal" var="loginMember"/>
<%
	List<Map<String,String>> memberList = (List<Map<String,String>>)request.getAttribute("groupMembers");
	List<String> memberIdList = new ArrayList<>();
	for(Map<String,String> m : memberList){
		memberIdList.add(m.get("memberId"));
	};
	pageContext.setAttribute("memberIdList",memberIdList);
%>

<!-- 프로필 -->
<div class="container mt-2">
	<div class="row" id="myInfo">
		<!-- 프로필이미지 영역 -->
		<div
			class="col-sm-6 d-flex justify-content-center align-items-center flex-column"
			id="profileImg">
			<div class="profileImg d-flex">
				<!-- 이미지를 넣으세요 -->
				<c:if test="${empty group.image}">
					<img
						src="${pageContext.request.contextPath}/resources/images/user.png"
						alt="" />
				</c:if>
				<c:if test="${not empty group.image}">
					<img
						src="${pageContext.request.contextPath}/resources/upload/group/profile/${group.image}"
						alt="" />
				</c:if>
			</div>
		<c:if test="${loginMember.id.equals(group.leaderId) }">
			<div class="profileBtn">
				<!-- (+)버튼을 이미지로 넣고, 클릭 시 변경 이벤트 걸기 -->
				<form:form action="${pageContext.request.contextPath}/group/profileImage?${_csrf.parameterName}=${_csrf.token}" id="upFileForm" accept="image/*" method="post" enctype="multipart/form-data">
					<input type="hidden" name=groupId value="${group.groupId}"/>
					<input type="hidden" name=image value="${group.image}"/>
						<label for="target-image">
							<img src="${pageContext.request.contextPath}/resources/images/icons/plusIcon.png"alt="" id="target-image" style="cursor: pointer;"/>
						</label>
					<input type="file" name="upFile" id="file" style="display:none" onchange="changeImage()"/>
				</form:form>
			</div>
		</c:if>
				
		</div>
<!-- 		<div class="col-sm-2"></div>
 -->		<!-- 프로필 세부정보 영역 -->
		<div class="col-sm-6" id="profileStatus">
		<div class="profileTableAreaContainer">
			<div class="profileTableArea">
			    <div class="row">
			        <div class="col-sm-8">
			       		<table id="profileTable">
							<tbody>
								<tr>
									<th class="tableKey">그룹명</th>
									<td class="tableValue">${group.groupName}</td>
								</tr>
								<tr>
									<th><span class="tableKey">그룹 아이디</span></th>
									<td>${group.groupId}</td>
								</tr>
								<tr>
									<th><span class="tableKey">리더</span></th>
									<td onclick="goMemberView('${group.leaderId}');" class="group-profile leader-id">${group.leaderId}</td>
								</tr>
								<tr class="memberCountTr" onclick="$('#groupMemberList').modal('show');">
									<th><span class="tableKey" style="color:#673ab7c9;">멤버</span></th>
									<td>${memberCount}명</td>
								</tr>
								<tr>
									<th><span class="tableKey">해시태그</span></th>
									<td>
										<c:forEach items="${group.hashtag}" var="name"><span class="hashtag" onclick="location.href='${pageContext.request.contextPath}/group/searchHashtag/${name}'">#${name}&nbsp;</span></c:forEach>
									</td>
								</tr>
							</tbody>
						</table>
			        </div>
			        <div class="col-sm-4 buttonArea">
			        	<c:if test="${!memberIdList.contains(loginMember.id)}">
							<div>
								<a
								href="${pageContext.request.contextPath}/group/enrollGroupForm?groupId=${group.groupId}"
								class="enroll-button">가입신청</a>
							</div>
						</c:if>
						<div>
<% 
	Member loginMember = (Member)pageContext.getAttribute("loginMember");
	if(memberIdList.contains(loginMember.getId())){%>
		<div class="plusBoardButton-container" onclick="location.href='${pageContext.request.contextPath}/group/groupBoardForm/${group.groupId}'">
			<img class="plusBoardButton"src="${pageContext.request.contextPath}/resources/images/icons/plus.png" alt=""  />
			<span class="plusButtonLabel">&nbsp;게시글 작성</span>
		</div>
		<%for(Map<String,String> m : memberList){
			if(m.get("memberId").equals(loginMember.getId())){
				if(m.get("memberLevelCode").equals("ld") || m.get("memberLevelCode").equals("mg")){	
%>
							<div>
								<a href="${pageContext.request.contextPath}/group/groupStatistic/${group.groupId}" class="enroll-button">활동통계</a>
							</div>
<%  }if(m.get("memberLevelCode").equals("ld")){	%>
							<div style="margin-top:10px;">
								<a href="${pageContext.request.contextPath}/group/groupMemberList/${group.groupId}" class="enroll-button">회원관리</a>
							</div>
							<div style="margin-top:10px;">
								<a href="javascript:void(0);" onclick="enrollList();" class="enroll-button">가입승인</a>
							</div>
							<div style="margin-top:10px;">
								<a href="javascript:void(0);" onclick="location.href='${pageContext.request.contextPath}/group/groupSetting/${group.groupId}';" class="enroll-button">정보수정</a>
							</div>
							<div style="margin-top:10px;">
							<form:form action="${pageContext.request.contextPath}/group/deleteGroup?${_csrf.parameterName}=${_csrf.token}" method="post">
							<input type="hidden" name=groupId value="${group.groupId}"/>
								<button type="submit" id="de1" onclick="return confirm('그룹을 삭제하시겠습니까?')" class="enroll-button" style="color: red;">그룹삭제</button>
							</form:form>
							</div>
							
<%  }if(m.get("memberLevelCode").equals("mb") || m.get("memberLevelCode").equals("mg")){	%>	
							<div style="margin-top:10px;">
							<form:form action="${pageContext.request.contextPath}/group/leaveGroup?${_csrf.parameterName}=${_csrf.token}" method="post">
							<input type="hidden" name=memberId value="${loginMember.id}"/>
							<input type="hidden" name=groupId value="${group.groupId}"/>
								<button type="submit" onclick="return confirm('그룹을 탈퇴하시겠습니까?')" class="enroll-button" style="color: red;">그룹탈퇴</button>
							</form:form>
							</div>
<%}}}};%>
						</div>
			        </div>
			    </div>
			</div>
		</div>	
		</div>
	</div>
</div>
<div class="iconn-container">
<div class="iconn">
	<a href="${pageContext.request.contextPath}/group/groupPage/${group.groupId}"><i class="fas fa-pencil-alt"></i></a>
	<a href="${pageContext.request.contextPath}/group/groupCalendar/${group.groupId}"><i class="fas fa-calendar-alt"></i></a>
	<a href="javascript:void(0)" onclick="groupDM('${group.groupId}','${loginMember.id}');"><i class="far fa-comments"></i></a>
</div>
</div>

<!-- 회원목록보기 modal -->
	<div class="modal fade" id="groupMemberList" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<div id="groupMemberListTableContainer">
						<table id="groupMemberListTable">
							<c:forEach items="${groupMembers}" var="member">
								<tr>
				 					<td>
				 						<a href="javascript:void(0);" onclick="goMemberView('${member.memberId}');" >
				 						<img style="width:50px; height:50px; border-radius:50%" src="<%=request.getContextPath()%>/resources/upload/member/profile/${member.profile}" alt="" />
				 						</a> 
				 					</td>
				 					<th>
				 						<a href="javascript:void(0);" onclick="goMemberView('${member.memberId}');" style="color:black; text-decoration:none;">
				 							&nbsp;&nbsp;&nbsp;&nbsp;${member.memberId}
				 						</a>
				 							<c:if test="${member.memberLevelCode eq 'ld'}"><span style="color:#ff5722">&nbsp;&nbsp;[Leader]</span></c:if>
				 							<c:if test="${member.memberLevelCode eq 'mg'}"><span style="color:#ff9800">&nbsp;&nbsp;[Manager]</span></c:if>
				 					</th> 
				 				</tr>
							</c:forEach>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>