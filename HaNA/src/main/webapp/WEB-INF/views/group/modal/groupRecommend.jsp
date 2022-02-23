<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<div class="modal fade" id="recommendedGroupListModal" tabindex="-1" role="dialog"
aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" style="max-width: 40%; width: auto;">
		<div class="modal-content">
			<div class="modal-header">
			<div style="widdth:50%; margin:auto; margin-top:30px; margin-bottom:30px;">
				<h4>추천 소모임 리스트</h4>
			</div>
			</div>
			<div class="modal-body" style="height:800px; overflow:auto;">
				<c:if test="${recommendedGroupList.size() eq 0}">
					<div class="no-recommended-msg">관심 해시태그를 등록하세요.</div>
				</c:if>
				<c:forEach items="${recommendedGroupList}" var="group" varStatus="vs">
				<div class="recommended-group-list" style="width:50%; margin:auto; margin-top:15px; margin-bottom:15px;">
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
							<div class="recommend-group-list-info-container">
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
		</div>
	</div>
</div>

