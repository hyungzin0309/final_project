<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<sec:authentication property="principal" var="loginMember"/>
<script src="${pageContext.request.contextPath }/resources/js/summernote/summernote-lite.js"></script>
<script src="${pageContext.request.contextPath }/resources/js/summernote/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/summernote/summernote-lite.css" />

 <div class="modal fade" id="boardFormModal" tabindex="-1"  >
	  <div class="modal-dialog modal-xl modal-dialog-centered">
		<div class="modal-content">
			<form:form name="boardEnrollFrm" action="${pageContext.request.contextPath }/member/insertBoard?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
			<!-- header -->
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">게시글 작성</h4>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
					<input type="hidden" name="writer" value="${loginMember.id }" />
					<br />
					<div class="boardAttachArea">
						 <input type="file" name="upFile" class="form-control" required/>
					</div>
					
						<input type="button" value="파일 추가"  id="appendAttachArea" class="form-control" style="background-color: gainsboro; color:black;"/>
					<br />
						<div class="font-weight-bold head pb-1"> </div> 
				    	<textarea id="desc" cols="120" rows="5" placeholder="작성하기" name="content"></textarea>  
					</div>
			<!-- footer -->
			<div class="modal-footer">
				<input type="submit" class="btn" value="등록하기" />
			</div>
			</form:form>
		</div>
	</div>
</div>

<script>
// boardModal
$("#boardModalBtn").click((e) => {
	$('#boardFormModal').modal();
});
/* 이미지업로드영역 추가 */
$("#appendAttachArea").click((e) => {
	let inputFile = `
		<input type="file" name="upFile" class="form-control" required/>
	`;
	$(".boardAttachArea").append(inputFile);
});
</script>
<style>
textarea {
    display: block;
    width: 100%;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 2px;
    outline-color: rgb(50, 147, 238);
    height: 400px;
}
</style>