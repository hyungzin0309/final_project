<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<div class="modal fade" id="groupRankingModal" tabindex="-1" role="dialog"
aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" style="max-width: 40%; width: auto;">
		<div class="modal-content">
			<div class="modal-header">
			<div style="widdth:50%; margin:auto; margin-top:30px; margin-bottom:30px;">
				<h4>소모임 랭킹</h4>
			</div>
			</div>
			<div class="modal-body" style="height:730px; overflow:auto;">
				<div class="group-ranking-select-container">
					<div>
						<div class="select-category container">
							<span onclick="$('#hashtagListModal-ranking').modal('show');">해시태그 선택&nbsp;&nbsp;&nbsp;</span>
							<select name="category" id="category">
								<option value="visit">오늘 방문</option>
								<option value="member">회원 수</option>
								<option value="apply">가입신청 수&nbsp;</option>
							</select>						
						</div>
					</div>
				</div>
				<c:if test="${groupRankingList.size() eq 0}">
					<div class="no-ranking-msg">존재하는 그룹이 없습니다.</div>
				</c:if>
				<c:forEach items="${recommendedGroupList}" var="group" varStatus="vs">
				<div class="group-ranking-list" style="width:60%; margin:auto; margin-top:15px; margin-bottom:15px;">
					<div class="pointer row" onclick="location.href='${pageContext.request.contextPath}/group/groupPage/${group.groupId}'">
						<div class="group-container-section1 col-sm-5">
							<div class="group-modal-profile-container">
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
							<div class="ranking-group-list-info-container">
								<div>
									<span class="group-list-groupId">${group.groupId}</span>
								</div>
								<div>
									<span class="group-list-groupName">${group.groupName}</span>
								</div>		
								<div>
									<c:forEach items="${group.hashtag}" var="hashtag">
										<span class="group-list-hashtag">#${hashtag}&nbsp;</span>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>
				</div>
					<br />
				</c:forEach>
			</div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>

<!-- 해시태그 목록 모달 -->
<div class="modal fade" id="hashtagListModal-ranking" tabindex="-1" role="dialog"
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
                    	<input type="checkbox" name="rankingHashtag" id="rankingHashtag-${vs.index}" value="${name}"/>
                        <label for="rankingHashtag-${vs.index}">&nbsp;&nbsp;${name}</label>	                    	
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
$(document).ready(getGroupRanking(1))

//모달창 내려갔을 때 ajax요청
$("#hashtagListModal-ranking").on('hidden.bs.modal', function () {
	getGroupRanking(1);
});

//카테고리 바꼈을 떄 ajax요청
$("#category").change((e)=>{
	getGroupRanking(1);
})

//ajax요청
function getGroupRanking(cPage){
	
	let category = $("#category").val();
	let hashtag = [];
	
	$.each($("[name=rankingHashtag]").get(),(i,e)=>{
		if($(e).prop("checked")==true){
			hashtag.push($(e).val());			
		}
	})
	
	$.ajax({
		url:`${pageContext.request.contextPath}/group/getGroupRanking/\${category}`,
		taditional:true,
		data:{
			cPage,
			hashtag
		},
		success(data){
			console.log(data);
		},
		error:console.log
	})
}
</script>
