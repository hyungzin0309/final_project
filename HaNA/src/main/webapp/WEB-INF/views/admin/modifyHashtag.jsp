<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
    
<jsp:include page="/WEB-INF/views/admin/common/adminHeader.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/modifyHashtag.css" />

<div class="body">
	<div class="add-hashtag-box">
		<div>
			<span>해시태그 추가하기</span>
		</div>
		<div class="add-hashtag">
			<form name="hashtagSubmitFrm" action="${pageContext.request.contextPath}/admin/addHashtag?${_csrf.parameterName}=${_csrf.token}" method="POST">
				<input type="text" placeholder="추가할 해시태그를 입력하세요" name="name"/>
				<input type="button" value="제출" id="hashtagSubmitBtn"/>
			</form>
		</div>
	</div>
	<div class="hashtag-box">
	<c:forEach items="${hashtagList}" var="hashtag">
		<div><span class="name">${hashtag}&nbsp;&nbsp;</span><span data-name="${hashtag}" class="delete-btn">X</span></div>
	</c:forEach>
	</div>
	<form name="deleteHashtagFrm" action="${pageContext.request.contextPath}/admin/deleteHashtag?${_csrf.parameterName}=${_csrf.token}" method="POST">
		<input type="hidden" value="" name="name"/>
	</form>
</div>



<script>
$(".delete-btn").click((e)=>{
	let name = $(e.target).data('name');
	if(confirm(`[\${name}] 해시태그를 삭제하시겠습니까?`)){
		$(document.deleteHashtagFrm).find("[name=name]").val(name).parent().submit();		
	}
})

$("#hashtagSubmitBtn").click((e)=>{
	let name = $("[name=name]").val();
	confirm(`[\${name}] 해시태그를 추가하시겠습니까?`);
	$(document.hashtagSubmitFrm).submit();
})
</script>
<jsp:include page="/WEB-INF/views/admin/common/adminFooter.jsp"/>
