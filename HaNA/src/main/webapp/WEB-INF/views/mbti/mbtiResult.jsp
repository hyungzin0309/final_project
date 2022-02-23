<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<section class="body-section"
	style="width: 200px; height: 100%; float: right; display: block;">
	<span style="float: right;"></span>
</section>
<section>
	<link rel="stylesheet"
		href="${pageContext.request.contextPath }/resources/css/mbti.css" />
	<div id="mbtiMain-Background">
		<img class="mbtiResultImg" src="/hana/resources/images/learn-g9ed443a84_1920.png" alt="이미지" />
		<p id="mainResultPage-p">당신의 성격 유형은 :</p>
		<div id="mainResultPage-append"></div>
		<div>
			<h4 id="mbtiResultH4">${memberMbti[0] }${memberMbti[1] }${memberMbti[2] }${memberMbti[3] }</h4>
			<input type="hidden" id="mbtiResult"
				value="${memberMbti[0] }${memberMbti[1] }${memberMbti[2] }${memberMbti[3] }" />
			<input type="hidden" id="memberId" value="${memberId}" />
		</div>
		<button id="hoomButton"
			onclick="location.href='http://localhost:9090/hana'">홈으로</button>
		<button id="mbtiInsert">프로필 반영</button>
	</div>


<script>
var mbtiResult = $("#mbtiResult").val();	
				
	$('#mbtiInsert').on('click', function() {
	 	$.ajax({
			url : "${pageContext.request.contextPath}/mbti/addMbtiProfile.do",
			method : "GET",
			data : {
				"mbti" : mbtiResult
			},
			success(map) {
				console.log(map)
				alert("프로필에 반영 되었습니다.")
				location.href='http://localhost:9090/hana'
			},
			error: console.log
			
		}); 
	
	});
	
	if(mbtiResult == 'ISTJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'청렴결백한 논리주의자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"한번 시작한 일은 끝까지 해내는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);	
	}else if(mbtiResult == 'ISFJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'용감한 수호자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"성실하고 온화하며 협조를 잘하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'INFJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'선의의 응호자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"사람과 관련된 뛰어난 통찰력을 가지고 있는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'INTJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'용의주도한 전략가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"전체적인 부분을 조합하여 비전을 제시하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ISTP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'만능 재주꾼'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"논리적이고 뛰어난 상황 적응력을 가지고 있는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ISFP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'호기심 많은 예술가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"따뜻한 감성을 가지고 있는 겸손한 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'INFP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'열정적인 중재자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"이상적인 세상을 만들어 가는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'INTP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'논리적인 사색가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"비평적인 관점을 가지고 있는 뛰어난 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ESTP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'모험을 즐기는 사업가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"친구,운동,음식 등 다양한 활동을 선호하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ESFP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'자유로운 영혼의 연예인'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"분위기를 고조시키는 우호적인 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ENFP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'재기발랄한 활동가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"열정적으로 새로운 관계를 만드는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ENTP'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'뜨거운 논쟁을 즐기는 변론가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"풍부한 상상력을 가지고 새로운 것에 도전하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ESTJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'엄격한 관리자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"사무적,실용적,현실적으로 일을 많이하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ESFJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'사교적인 외교관'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"친절과 현실감을 바탕으로 타인에게 봉사하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ENFJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'정의로운 사회운동가'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"타인의 성장을 도모하고 협동하는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}else if(mbtiResult == 'ENTJ'){
		var htmlOut='';
		htmlOut += '<h1 id="mainResultPage-h1">'+'대담한 통솔자'+'</h1>';
		htmlOut += '<h5 id = "mainResultPage-h5">'+'"비전을 가지고 사람들을 활력적으로 이끌어가는 유형"'+'</h5>';
		$('#mainResultPage-append').append(htmlOut);
	}	
	
</script>


</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>