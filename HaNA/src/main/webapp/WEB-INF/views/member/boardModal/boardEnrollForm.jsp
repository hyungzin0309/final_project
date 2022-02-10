<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.hana.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<sec:authentication property="principal" var="loginMember"/>

<!-- 글쓰기모달 -->
    <div class="modal fade" id="boardFormModal" tabindex="-1"  >
	<div class="modal-dialog modal-xl modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">게시글 작성</h4>
			</div>
			<div class="modal-body">
				<table class="table" style="text-align: center;" name="modalTable">
					<thead class="table-light">
					</thead>
					<tbody id="modalTbody">
	<form:form
        action="${pageContext.request.contextPath}/member/memberBoardEnroll?${_csrf.parameterName}=${_csrf.token}"
        method="POST"
        enctype="multipart/form-data">
	            <input type="hidden" value="<sec:authentication property='principal.username'/>" name="writer"/></td>
	            <input type="hidden" value="${id}" name="id"/></td>
		        <div class="font-weight-bold head pb-1"> </div> 
		    	<textarea id="desc" cols="120" rows="5" placeholder="작성하기" name="content"></textarea>  
		    	<br/><br/>  
				<div class="font-weight-bold head pb-1"><label class="labels"></label><input type="file" class="form-control" placeholder=File name="file" id="file1" value="파일 선택"></div>
				<div class="font-weight-bold head pb-1"><label class="labels"></label><input type="file" class="form-control" placeholder=File name="file" id="file2" value="파일 선택"></div>
				<div class="font-weight-bold head pb-1"><label class="labels"></label><input type="file" class="form-control" placeholder=File name="file" id="file3" value="파일 선택"></div> 
				<br/>
           <input type="submit" value="게시"/>
    </form:form>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
			</div>
		</div>      
    </div>
</div>
<script>
//글쓰기
$("#btn-add").click(()=> {
	console.log("ddd");
  $("#boardFormModal").modal();
});

 
 
$(document).ready(function() {
	//여기 아래 부분
	$('#summernote').summernote({
		  height: 300,                 // 에디터 높이
		  minHeight: null,             // 최소 높이
		  maxHeight: null,             // 최대 높이
		  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
		  lang: "ko-KR",					// 한글 설정
		  placeholder: '최대 2048자까지 쓸 수 있습니다'	//placeholder 설정
          
	});
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