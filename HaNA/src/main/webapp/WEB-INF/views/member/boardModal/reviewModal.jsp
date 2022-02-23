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
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/reviewModal.css" />



<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form:form name="reviewEnrollFrm" action="${pageContext.request.contextPath }/member/insertReview?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
			<!-- header -->
			<div class="modal-header">
				<h3 class="modal-title">리뷰 등록</h3>
					<button class="close" type="button" data-dismiss="modal" aria-label="Close">
						닫기
					</button>
			</div>
			<!-- 내용 -->
			<div class="modal-body">
				<div class="review-body">
					<input type="hidden" name="writer" value="${loginMember.id }" />
						<br />
					<!-- 첨부영역 -->	
					<div class="boardAttachArea">
						<input type="file" id="rev-fileBtn" name="upFile" required/>
					</div>
					<!-- 추가버튼 -->
					<input type="button" id="rev-appendBtn" value="이미지 추가" class="appendAttachArea"/>
					<!-- 텍스트 영역 -->
					<div class="contentArea">
						<span id="contentTitle">리뷰 작성</span>
						<textarea name="content" id="summernote"></textarea>
					</div>					
					<!-- 별점매기기 -->
					<span class="rating-title">평점</span>
					<div id="starArea" style="display:block;float:left">
						<div class="rating">
							 <input type="radio" name="rating" id="r1" value="5">
							 <label for="r1"></label>
							
							 <input type="radio" name="rating" id="r2" value="4">
							 <label for="r2"></label>
							
							 <input type="radio" name="rating" id="r3" value="3">
							 <label for="r3"></label>
							
							 <input type="radio" name="rating" id="r4" value="2">
							 <label for="r4"></label>
							
							 <input type="radio" name="rating" id="r5" value="1">
							 <label for="r5"></label>
						</div>
						<input type="hidden" name="checkedVal" id="" />
					</div>
						<br /><br />
				</div>					
			</div>
			<!-- footer -->
			<div class="modal-footer">
				<input type="submit" class="btn" value="등록하기" />
			</div>
			<input type="hidden" name="reservationNo" id="review-rs-no"/>
			</form:form>
		</div>
	</div>
</div>

<script>
// reviewModal
function enrollReview(reservationNo){
	$("#review-rs-no").val(reservationNo);
	$('#reviewModal').modal({backdrop:'static', keyboard:false});	
};

$("[name=rating]").change((e) => {
	$("[name=checkedVal]").val($(e.target).val());
});

$(document.reviewEnrollFrm).submit((e) => {
	console.log($("[name=checkedVal]").val());
});


/* 이미지업로드영역 추가 */
$(".appendAttachArea").click((e) => {
	let inputFile = `
		<input type="file" name="upFile" required/>
	`;
	$(".boardAttachArea").append(inputFile);
});

</script>