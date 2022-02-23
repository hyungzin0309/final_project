<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reservationShare/shareMember.css" />


<div class="modal fade" id="shareUserModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">공유인원</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<table id="acceptedFriendListTable2">
					<tbody></tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<script>
function showShareUserModal(reservationNo){
	showAcceptedFriends(reservationNo);
	$('#shareUserModal').modal({backdrop:'static', keyboard:false});
};

function showAcceptedFriends(reservationNo){
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/selectAcceptedFriends',
		data:{
			reservationNo
		},
		success(res){
			$("#acceptedFriendListTable2 tbody").empty();		
			$.each(res, (i, e) => {
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
				$("#acceptedFriendListTable2 tbody").append(tr);				
			});
		},
		error:console.log
	});	
};
</script>