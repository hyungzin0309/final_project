<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/admin/common/adminHeader.jsp"/>
<style>
	table{
		border: 1px solid black;
		border-collapse: collapse;
		text-align:center;
		width:500px;
		margin:auto;
	}
	table th{
		border: 1px solid black;
	}
	table td{
		border: 1px solid black;
	}
</style>

<table>
	<thead>
		<tr>
			<td colspan="3">항소 유저 리스트</td>
		</tr>
		<tr>
			<td>no</td>
			<td>아이디</td>
			<td>석방일시</td>
			<td>석방하기</td>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list }" var="rs" varStatus="vs">
			<tr>
				<td>
					${vs.count }
				</td>
				<td>
					<a href="#" onclick="reportedListModal('${rs.ID}')">${rs.ID }</a>
				</td>
				<td>
					${rs.RESTRICTED_DATE }
				</td>
				<td>
					<input type="button" value="석방" onclick="acceptAppeal('${rs.ID}')"/>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<div class="rsPageBar">
	${pageBar }
</div>

<!-- detailModal -->
<div class="modal fade" id="reportedListModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">신고내역</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<table id="reportedHistory">
					<thead>
						<tr>
							<td>no</td>
							<td>신고자</td>
							<td>신고사유</td>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
			<!-- footer -->
		</div>
	</div>
</div>


<script>
	function reportedListModal(id){
		console.log(id);
		$("#reportedHistory tbody").empty();
		
		$.ajax({
			url: '${pageContext.request.contextPath}/admin/reportedHistory',
			data: {
				id
			},
			success(res){
				$.each(res, (i, e) => {
					let tr = `
						<tr>
							<td>\${i}</td>
							<td>\${e.REPORT_USER}</td>
							<td>\${e.CONTENT}</td>
						</tr>
					`;
					$("#reportedHistory tbody").append(tr);
				})
				
			},
			error:console.log
		});
		
		$('#reportedListModal').modal({backdrop:'static', keyboard:false});
	};
	
	function acceptAppeal(id){
		console.log(id);
		
		$.ajax({
			url: '${pageContext.request.contextPath}/admin/acceptAppeal',
			data:{
				id
			},
			success(res){
				console.log(res);
			},
			error:console.log,
			complete(){
				alert("석방되었습니다.");
				location.reload();
			}
		});
	};
</script>


<jsp:include page="/WEB-INF/views/admin/common/adminFooter.jsp"/>