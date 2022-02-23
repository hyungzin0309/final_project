<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="로그인화면" name="title"/>
</jsp:include>
<style>
body {
  /* align-items: center; */
  background-color: #fff;
  /* display: flex; */
  /* justify-content: center; */
  height: 100vh;
}

.form {
  background-color: #15172b;
  border-radius: 20px;
  box-sizing: border-box;
  height: 550px;
  padding: 20px;
  width: 320px;
  margin:0;
}

.title {
  color: #eee;
  font-family: sans-serif;
  font-size: 36px;
  font-weight: 600;
  margin-top: 10px;
}

.subtitle {
  color: #eee;
  font-family: sans-serif;
  font-size: 16px;
  font-weight: 600;
  margin-top: 10px;
}

.input-container {
  height: 50px;
  position: relative;
  width: 100%;
}

.ic1 {
  margin-top: 40px;
}

.ic2 {
  margin-top: 30px;
}

.input {
  background-color: #303245;
  border-radius: 12px;
  border: 0;
  box-sizing: border-box;
  color: #eee;
  font-size: 18px;
  height: 100%;
  outline: 0;
  padding: 4px 20px 0;
  width: 100%;
}

.cut {
  background-color: #15172b;
  border-radius: 10px;
  height: 20px;
  left: 20px;
  position: absolute;
  top: -20px;
  transform: translateY(0);
  transition: transform 200ms;
  width: 76px;
}

.cut-short {
  width: 50px;
}

.input:focus ~ .cut,
.input:not(:placeholder-shown) ~ .cut {
  transform: translateY(8px);
}

.placeholder {
  color: #65657b;
  font-family: sans-serif;
  left: 20px;
  line-height: 14px;
  pointer-events: none;
  position: absolute;
  transform-origin: 0 50%;
  transition: transform 200ms, color 200ms;
  top: 20px;
}

.input:focus ~ .placeholder,
.input:not(:placeholder-shown) ~ .placeholder {
  transform: translateY(-30px) translateX(10px) scale(0.75);
}

.input:not(:placeholder-shown) ~ .placeholder {
  color: #808097;
}

.input:focus ~ .placeholder {
  color: #dc2f55;
}

.submit {
  background-color: #08d;
  border-radius: 12px;
  border: 0;
  box-sizing: border-box;
  color: #eee;
  cursor: pointer;
  font-size: 18px;
  height: 50px;
  margin-top: 38px;
  // outline: 0;
  text-align: center;
  width: 100%;
}

.button{
  background-color: #79b57d;
  border-radius: 12px;
  border: 0;
  box-sizing: border-box;
  color: #eee;
  cursor: pointer;
  font-size: 18px;
  height: 50px;
  margin-top: 38px;
  // outline: 0;
  text-align: center;
  width: 100%;
}

.submit:active {
  background-color: #06b;
}

</style>
<section>

<div class="container mt-5">
	<div class="row">
		<div class="col-sm"></div>
		<div class="col-sm d-flex" style="justify-content:center;">			
			<form:form action="${pageContext.request.contextPath }/member/login" method="POST">	
			    <div class="form" style="align-item:center;">
			      <div class="title">Welcome</div>
			      <div class="subtitle">로그인 후 이용 가능합니다.</div>
			      <div class="input-container ic1">
			        <input id="firstname" name="userId" class="input" type="text" placeholder=" " />
			        <div class="cut"></div>
			        <label for="firstname" class="placeholder">아이디를 입력해주세요.</label>
			      </div>
			      <div class="input-container ic2">
			        <input id="lastname" name="password" class="input" type="password" placeholder=" " />
			        <div class="cut"></div>
			        <label for="lastname" class="placeholder">비밀번호를 입력해주세요.</label>
			      </div>
			      <br />
			      	<input type="checkbox" class="form-check-input" name="remember-me" id="rememer-me" />
					<label for="remember-me" style="color:white;">Remember me</label>
			      <button type="submit" class="submit">Log In</button>
			      <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/member/memberEnrollMain'">회원가입</button>
			    </div>
			</form:form>
		</div>
		<div class="col-sm"></div>
		

	</div>
</div>
</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>