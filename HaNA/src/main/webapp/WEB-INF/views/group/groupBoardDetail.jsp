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
	<jsp:param value="그룹메인" name="title" />
</jsp:include>

<section
	style="position: relative; width: 30%; height: 120px; margin: auto;">
	<c:forEach var="group" items="${groupList}" varStatus="status">
	<div class="group-div" onclick="location.href='${pageContext.request.contextPath}/group/groupPage/${group.groupId}'">
	<div class="group-image-div"
		style="border-radius: 50%; width: 100px; height: 100px; position: relative; display:inline-block ">
		<c:if test="${empty group.image}">
			<img
				style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 50%;"
				src="${pageContext.request.contextPath}/resources/images/user.png"
				alt="" />
		</c:if>
		<c:if test="${not empty group.image}">
			<img
				style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 50%;"
				src="${pageContext.request.contextPath}/resources/upload/group/profile/${group.image}"
				alt="" />
		</c:if>
	</div>
	<div class="group-info-div"
		style="display: inline-block;">
		<table>
			<tr>
				<td>${group.groupName}</td>
			</tr>
			<tr>
				<td>${group.memberCount}</td> </tr>
		</table>
	</div>
	</div>	
	</c:forEach>
</section>
<style>
.group-div:hover {
	cursor:pointer;
}

</style>
<script>
/* $(".group-div").click((e)=>{
	console.log($(e.currentTarget).children("#group-id").val());
	location.href="<c:out value='${pageContext.request.contextPath}'/>/group/groupPage/"+$(e.target).children("#group-id").val();
})
$(".group-image-div").click((e)=>{
	$(e.target).parent(".group-div").trigger("click");
}) */
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>