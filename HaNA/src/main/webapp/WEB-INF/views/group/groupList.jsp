<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="그룹메인" name="title" />
</jsp:include>
<section class="group-list-section">
	<c:if test="${groupList.size() eq 0}">
	<div class="no-group-msg">
		가입한 소모임이 없습니다.
	</div>
	</c:if>	
	<c:forEach items="${groupList}" var="group" varStatus="vs">
	<div class="group-container row" onclick="location.href='${pageContext.request.contextPath}/group/groupPage/${group.groupId}'">
		<div class="group-container-section1 col-sm-5">
			<div class="group-profile-container">
				<c:if test="${empty group.image}">
					<img
						id="group-profile"
						src="${pageContext.request.contextPath}/resources/images/user.png"
						alt=""
						 />
				</c:if>
				<c:if test="${not empty group.image}">
					<img
						id="group-profile"
						src="${pageContext.request.contextPath}/resources/upload/group/profile/${group.image}"
						alt=""/>
				</c:if>
			</div>
		</div>
	<div class="group-container-section2 col-sm-7">
		<div class="group-list-info-container">
			<div>
				<span class="group-list-groupId">${group.groupId}</span>
			</div>
			<div>
				<span class="group-list-groupName">${group.groupName}</span>
			</div>		
		</div>
	</div>
	</div>
	<br />
	</c:forEach>
</section>

<div class="plusGroupButton-container" onclick="location.href='${pageContext.request.contextPath}/group/createGroupForm'" >
	<img class="plusGroupButton"src="${pageContext.request.contextPath}/resources/images/icons/plus.png" alt="" />
	<span class="plusButtonLabel">&nbsp;그룹생성</span>
</div>
<div class="plusHashtagButton-container" onclick="$('#hashtagListModal').modal();">
	<img class="plusHashtagButton"src="${pageContext.request.contextPath}/resources/images/icons/plus.png" alt=""/>
	<span class="plusButtonLabel">&nbsp;나의 관심 해시태그</span>
</div>
<div class="groupRankingButton-container" onclick="$('#groupRankingModal').modal();">
	<img class="groupRankingButton"src="${pageContext.request.contextPath}/resources/images/icons/crown.png" alt=""/>
	<span class="plusButtonLabel">&nbsp;소그룹 랭킹</span>
</div>
<div class="groupListModalButton-container" onclick="$('#recommendedGroupListModal').modal();">
	<img class="groupListModalButton"src="${pageContext.request.contextPath}/resources/images/icons/thumbs-up.png" alt=""/>
	<span class="plusButtonLabel">&nbsp;추천 소그룹</span>
</div>
<!-- 해시태그 목록 모달 -->
<div class="modal fade" id="hashtagListModal" tabindex="-1" role="dialog"
aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" style="max-width: 20%; width: auto;">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">해시태그를 선택하세요</h4>
			</div>
			<div class="modal-body">
				<div class="hashtag-list-container">
					<c:forEach items="${hashtagList}" var="name" varStatus="vs">
					<div class="hashtag-container">
                    	<input type="checkbox" name="hashtag" id="hashtag-${vs.index}" value="${name}" ${likeHashtagList.contains(name)?'checked':''}/>
                        <label for="hashtag-${vs.index}">&nbsp;&nbsp;${name}</label>	                    	
					</div>
                   	</c:forEach>										
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">완료</button>
			</div>
		</div>
	</div>
</div>

<script>
	$("[name=hashtag]").change((e)=>{
		if($(e.target).is(":checked")){
			addHashtag($(e.target).val());
		}else{
			deleteHashtag($(e.target).val());
        }
	})
	function addHashtag(name){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/addHashtag",
			method:"POST",
			data:{
				'name':name	
			},
			success(data){
				console.log(data);
			},
			error:console.log
		})
	}
	function deleteHashtag(name){
		$.ajax({
			url:"${pageContext.request.contextPath}/group/deleteHashtag",
			method:"POST",
			data:{
				'name':name	
			},
			success(data){
				console.log(data);
			},
			error:console.log
		})
	}

	$('#hashtagListModal').on('hidden.bs.modal', function () {
	    location.reload();
	});

</script>
 <jsp:include page="/WEB-INF/views/group/modal/groupRanking.jsp"></jsp:include>
 <jsp:include page="/WEB-INF/views/group/modal/groupRecommend.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>