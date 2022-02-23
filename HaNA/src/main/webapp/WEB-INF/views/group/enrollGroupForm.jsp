<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<fmt:requestEncoding value="utf-8" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/groupPlus.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="가입신청화면" name="title" />
</jsp:include>
<sec:authentication property="principal" var="loginMember" />

<html>
<head>
<meta charset="UTF-8">
<title>소그룹 가입 신청 폼</title>
</head>
<body>
<div class="padding">
    <div style="text-align: center"> <i class="mdi mdi-forum"></i> <br>
        <h1 style="color: #666; font-weight: bold; font-size: 50px;">${groupId}</h1><h4 style="color: #666;">소모임 신청</h4>
        <br>
        <p class="text-center" style="color:#444;">이 소모임이 마음에 드신다면?</p> 
        <button type="submit" class="btn btn-outline-dark ml-sm-2 mb-2" style="border-radius: 50px" data-toggle="modal" data-target="#contact">&emsp;&emsp;신청폼 작성하기&emsp;&emsp;</button>
    </div>
    
    <!--Contact Modal-->
    <div class="modal fade" id="contact" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content bg-dark">
                <div class="modal-header">
                    <h5 class="modal-title text-light" id="exampleModalLabel">가입 신청 폼</h5> <button type="button" class="close text-light" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
                </div>
                <div class="modal-body">
                    <form:form name="enrollGroupForm" method="post" action="${pageContext.request.contextPath}/group/enrollGroupForm">
                        <div class="form-group"> 
                        	<label for="exampleInputEmail1" style="color: #fff;">회원 아이디</label> 
                        	<input type="text" class="form-control" id="memberId" readonly value=" ${loginMember.id}" >
                        </div>
                        <div class="form-group"> 
                        	<label for="exampleFormControlTextarea1" style="color: #fff;">가입하고 싶은 이유를 자유롭게 작성해주세요.</label> 
                        	<textarea  class="form-control" id="exampleFormControlTextarea1" rows="2" name="content" ></textarea> 
                        	<input type="hidden" name="groupId" value="${groupId}" /> 
                        	<input type="hidden" name="memberId" value="<sec:authentication property='principal.username'/>" />
                        </div>
                		<div class="modal-footer"> <button type="button" id="submitBtn" class="btn btn-outline-light ml-sm-2" style="border-radius: 50px; width:100%;" data-dismiss="modal" aria-label="Close">Submit</button> </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
	$("#submitBtn").click((e) => {
		if($("[name=content]").val()==''){
			alert("내용을 작성하세요");
			return false;
		}
		else {$(document.enrollGroupForm).submit();}
	})
</script>

</body>
</html>