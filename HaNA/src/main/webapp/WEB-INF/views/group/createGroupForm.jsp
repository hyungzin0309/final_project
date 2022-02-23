<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="그룹가입폼" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />
<div class="first-container">
<div class="container rounded bg-white mt-5 mb-5">
	<form
		name="createGroupFrm"
		action="${pageContext.request.contextPath}/group/createGroup?${_csrf.parameterName}=${_csrf.token}"
		method="post"
		enctype="multipart/form-data">
		<input type="hidden" name="leaderId" value="<sec:authentication property='principal.username'/>" />
	    <div class="row">
	        <div class="col-md-5 border-right">
	            <div class="p-5 py-5">
	                <div class="d-flex justify-content-between align-items-center mb-3">
	                    <h5 class="text-right">Create your Group</h5>
	                </div>
	                <div class="row mt-2">
	                    <div class="col-md-7">
	                    <label class="labels">소모임 아이디</label>
	                    <input type="text" class="form-control" placeholder="Group Id" name="groupId" value="${group.groupId}" required>
	                    </div>
	                </div>
	                <div>
	                	<span class="idDupl-msg">사용중인 아이디입니다.</span>
	                	<input type="hidden" id="flag" value="0"/>
	                </div>
	                
	                <div class="row mt-3">
	                    <div class="col-md-7">
	                    <label class="labels">소모임명</label>
	                    <input type="text" class="form-control" placeholder="Group Name" name="groupName" value="${group.groupName}" required>
	                    </div>
	                </div>
	                <div class="row mt-3">
	                    <div class="col-md-7"><label class="labels">프로필 사진</label>
	                    <input type="file" class="form-control" placeholder="country" name="profileImage" value="파일 선택" onchange="setThumbnail(event);" >
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
												<c:forEach items="${hashtag}" var="name" varStatus="vs">
												<div class="hashtag-container">
							                    	<input type="checkbox" name="hashtag" id="hashtag-${vs.index}" value="${name}"/>
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
	                <div class="mt-5 text-left">
	                <button class="btn btn-primary profile-button" type="button" onclick="submitFrm();">Create</button>
	                </div>
	            </div>
	        </div>
	        <div class="col-md-3 border-right">
	            <div id="image-container"></div>
	        </div>
	    </div>
    </form>
</div>
</div>

<script>
//아이디 중복검사
$("[name=groupId]").keyup((e)=>{
	let id = $(e.target).val();
	
	$.ajax({
		url:"${pageContext.request.contextPath}/group/checkIdDuple",
		data:{
			id
		},
		success(data){
			console.log(data);
			if(data.result!=0){
				$(".idDupl-msg").css("display","inline");
				$("#flag").val(1);
			}
			else{
				$(".idDupl-msg").css("display","none");								
				$("#flag").val(0);
			}
		},
		error:console.log
	})
	
})
//이미지 미리보기
function setThumbnail(event){
	var reader = new FileReader();
	reader.onload = function(event) {
		var img = document.createElement("img");
		img.setAttribute("src", event.target.result);
		img.setAttribute("style", "width:100%;");
		document.querySelector("div#image-container").appendChild(img);
		};
	reader.readAsDataURL(event.target.files[0]);
}

//폼제출
function submitFrm(){
    let idReg = /^[a-z]+[a-z0-9]{5,19}$/g;
    let nameReg = /^.{1,30}$/;
    if( !idReg.test( $("input[name=groupId]").val())) {
        alert("아이디는 영문자로 시작하는 6~20자 영문자 또는 숫자이어야 합니다.");
        return;
    }
    else if($("#flag").val()!=0){
		alert("다른 아이디를 사용하세요.");
	}
    else if(!nameReg.test( $("input[name=groupName]").val())) {
        alert("소모임명은 30자 이하로 작성해주세요.");
    }
	else{
		$(document.createGroupFrm).submit();
	}
}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
