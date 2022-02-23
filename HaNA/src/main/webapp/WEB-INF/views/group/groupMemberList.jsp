<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="소모임멤버리스트" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupBoardForm.css" />
<style>
table th, td {
	text-align: center;
	vertical-align: middle;
	border:none;
}
tr {
border-top:1px solid #8080803b;
}
</style>

<section>
<script src="https://kit.fontawesome.com/0748f32490.js" crossorigin="anonymous"></script>
<sec:authentication property="principal" var="loginMember" />

<script>
/* 전역변수 생성 */
let memberId2;
let memberLevelCode2;

/* 현재 등급 체크 함수 */
/* const grade2=(code)=>{
	console.log("asdfadf1",code);
};  */

</script>

	<div class="groupMemberListTableArea">
	<div class="page-label"> [${groupId}] 소모임 회원 관리 </div>
		<table class="table">
			<tr>
				<th>프로필</th>
				<th>멤버 아이디</th>
				<th>회원등급</th>
				<th>조정</th>
			</tr>
			<c:forEach items="${groupMembers}" var="member">
				<tr>
					<td><img
						style="width: 100px; height: 100px; border-radius: 50%;cursor: pointer;"
						src="${pageContext.request.contextPath}/resources/upload/member/profile/${member.profile}" />
					</td>
					<td>${member.memberId}</td>
					<td>
						<c:if test="${member.memberLevelCode eq 'ld'}"><span style="color:#ff5722;">리더</span></c:if> 
						<c:if test="${member.memberLevelCode eq 'mg'}"><span style="color:orange">매니저</span></c:if> 
						<c:if test="${member.memberLevelCode eq 'mb'}">멤버</c:if></td>
					<td>
						<input type="button" class="btn btn-secondary" data-toggle="modal" data-target="#moaModal"
						onclick="grade('${member.memberLevelCode}','${member.memberId}','${group.groupId}')" value="등급"/>
						<%-- grade2(${member.memberLevelCode},${member.memberId},${group.groupId}); --%>
						
						<button
						class="btn btn-danger"
						onclick="deleteMember('${member.memberId}');">탈퇴</button>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>

	<!-- 회원 조정 모달 -->
	<div class="modal fade" id="moaModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<div class="head-label">
						등급조정
					</div>
				</div>
				
				<div class="modal-body">
					<form:form name="groupGradeUpdateFrm" action="${pageContext.request.contextPath}/group/updateGroupMemberLevel?${_csrf.parameterName}=${_csrf.token}" method="POST" 
						class="customRadio customCheckbox m-0 p-0">
						<div class="row mb-0">
							<div class="row justify-content-start">
								<div class="col-12">
									<div class="row_">
										<input type="hidden" name="groupId" value="${groupId}"/>
										<input type="hidden" name="memberId" />
										<input type="hidden" name="currentLevel" />
										
										<input type="radio" name="updateLevel" id="ld" value="ld" >
										<label for="ld" class="form-check-label">리더</label>
									</div>
									<div class="row_">
										<input type="radio" name="updateLevel" id="mg" value="mg"> 
										<label for="mg" class="form-check-label">매니저</label>
									</div>
									<div class="row_">
										<input type="radio" name="updateLevel" id="mb" value="mb">
										<label for="mb" class="form-check-label">멤버</label>
									</div>
								</div>
							</div>
						</div>
							<div class="modal-footer">
								<button class="btn btn-primary" type="submit" data-dismiss="modal" onclick="updateGroupGradeFunc();">save</button>
							</div>
					</form:form>
				</div>
					<%-- <a href="${contextPath.request.pageContext}/group/gradeGroupMember/${list.MEMBER_ID}/${list.MEMBER_LEVEL_CODE}"></a> --%>
			</div>
		</div>
	</div>

<script>
function deleteMember(memberId){
	if(confirm("회원을 방출하시겠습니까?")){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/deleteGroupMember",
			method:"POST",
			data:{
				"memberId":memberId,
				"groupId":'${groupId}'
			},
			success(data){
				console.log(data);
				location.reload();
			},
			error:console.log
		})
	}
}

function grade(code,memberId,groupId){
	/* console.log("asdfadf1",code);
	console.log("asdfadf1",memberId);
	console.log("asdfadf1",groupId); */
	<!-- memberId2는 제가 header에 memberId에다가 로그인id넣어둔거 가져와서 쓴거같아요-->
	memberId2 = memberId;
	memberLevelCode2 = code;
	console.log(memberId2);
	console.log(memberLevelCode2);

 	console.log(code);
	console.log(code == 'ld');
	if(code == 'ld'){
		$("#ld").prop('checked', true);	
	}
	if(code == 'mg'){
		$("#mg").prop('checked', true);
	}
	if(code == 'mb'){
		$("#mb").prop('checked', true);
	}
}

/* 회원 등급 변경 함수 */
function updateGroupGradeFunc(){
	if(confirm("회원 등급을 변경하시겠습니까? (리더직을 위임할 경우 '나의 등급'은 일반 멤버로 전환됩니다.)")){
		<!--  -->
		console.log("updateGroupGradeFunc = ",memberId2);
		console.log("updateGroupGradeFunc = ",memberLevelCode2);
		$("[name=groupGradeUpdateFrm] input[name=memberId]").val(memberId2);
		$("[name=groupGradeUpdateFrm] input[name=currentLevel]").val(memberLevelCode2);
		$(document.groupGradeUpdateFrm).submit();
	}
}; 
</script>





<a href="/" class="badge badge-dark">Dark</a>
</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>