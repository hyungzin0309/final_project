<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>

<div class="modal fade" id="userReportModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">신고하기</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<h5>신고사유를 입력해주세요.</h5>
				<br />
				<input type="text" name="" id="reportContent" />
			</div>
			<!-- footer -->
			<div class="modal-footer">
				<a class="btn" id="reportSubmitBtn" href="#">제출</a>
			</div>
		</div>
	</div>
</div>

<script>
	$("#reportBtn").click((e) => {
		$("#userReportModal").modal({backdrop:'static', keyboard:false});
	});
	
	$("#reportSubmitBtn").click((e) => {
		console.log("버튼클릭");
		
		$.ajax({
			url: '${pageContext.request.contextPath}/member/reportUser?${_csrf.parameterName}=${_csrf.token}',
			method: 'POST',
			data:{
				reportedUser: '${member.id}',
				reportUser: '${loginMember.id}',
				content: $("#reportContent").val()
			},
			success(res){
				console.log(res);
				if(res == 1){
					alert("신고되었습니다.");
				} else {
					alert("이미 신고한 계정은 제제 전 다시 신고할 수 없습니다.");
				}
			},
			error: console.log,
			complete(){
				location.reload();
			}
		});
	});
</script>