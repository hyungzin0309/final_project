<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.kh.hana.group.model.vo.Group, java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="프로필수정" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />
<section>
<script src="https://kit.fontawesome.com/0748f32490.js" crossorigin="anonymous"> </script>
<sec:authentication property="principal" var="loginMember" />
<br />

<%
	List<String> list = new ArrayList<>();
	if(((Group)request.getAttribute("group")).getHashtag() != null){
		list = Arrays.asList(((Group)request.getAttribute("group")).getHashtag());	
	}
	pageContext.setAttribute("hashtag",list);
%>

<div class="container rounded bg-white mt-5 mb-5">
	<form:form name="groupUpdateFrm" action="${pageContext.request.contextPath}/group/groupUpdate?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
	    <div class="row">
	        <div class="col-md-6 border-right">
	            <div class="d-flex flex-column align-items-center text-center p-3 py-5">
		            <img src="${pageContext.request.contextPath}/resources/upload/group/profile/${group.image}" style="width: 180px; height: 180px; border-radius: 50%;"><br />
		            <span class="font-weight-bold">소모임 ${group.groupName}의 프로필</span>
		            <span class="text-black-50">${group.groupId}</span>
		            <input type="hidden" name="groudId" value="${group.groupId }" />
		            <span></span>
	            </div>
	        </div>
	        <div class="col-md-5 border-right">
	            <div class="p-3 py-5">
	                <div class="d-flex justify-content-between align-items-center mb-3">
	                    <h5 class="text-right">Edit your profile</h5>
	                </div>
	                <div class="row mt-2">
	                    <div class="col-md-7"><label class="labels">소모임 아이디</label><input type="text" class="form-control" placeholder="GroupId" name="groupId" value="${group.groupId}" required readonly></div>
	                </div>
	                <div class="row mt-3">
	                    <div class="col-md-7"><label class="labels">소모임명</label><input type="text" class="form-control" placeholder="GroupName" name="groupName" value="${group.groupName}" required></div>
	                </div>
	                <div class="row mt-3">
	                    <div class="col-md-7"><label class="labels">프로필 사진</label><input type="file" class="form-control" placeholder=File" name="upFile" value="파일 선택">
	                    <input type="hidden" name="image" value="${group.image}" />
	                    </div>
	                </div>
	                <div class="row mt-3">
	                    <div class="col-md-12" onclick="$('#hashtagListModal').modal()"><span class="hashtag-modal-label">해시태그</span><br />
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
							                    	<input type="checkbox" name="hashtag" id="hashtag-${vs.index}" value="${name}" ${hashtag.contains(name) ? 'checked' : '' }/>
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
	                    </div>
	                </div>
	                <input type="hidden" name="leaderId" value="${group.leaderId}">
	                <div class="mt-5 text-left"><button class="btn btn-primary profile-button" type="submit" onclick="return confirm('정보를 수정하시겠습니까?')">Save Profile</button></div>
	            </div>
	        </div>
	    </div>
    </form:form>
</div>

<a href="/" class="badge badge-dark">Dark</a>
</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>