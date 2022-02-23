<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="회원가입" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberEnroll.css" />

	

				<!-- new Start  -->
				<!-- JQUERY STEP -->
				<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-steps/1.1.0/jquery.steps.min.js"></script>
				<div class="wrapper">
				    <form:form action="${pageContext.request.contextPath }/member/memberEnroll?${_csrf.parameterName}=${_csrf.token}" method="POST" name="enrollFrm" enctype="multipart/form-data">
				        <div id="wizard">
				            <!-- SECTION 1 -->
				            <h4></h4>
				            <section>
				                <div class="product">
				                    <div class="item">
				                        <div class="left"> <a href="#" class="thumb"> <img src="${pageContext.request.contextPath }/resources/images/enrollFrm/normal.png" alt=""> </a>
				                            <div class="purchase">
				                                <h6>일반 사용자</h6>
				                            </div>
				                        </div>
				                        <span class="price">
											<input type="radio" name="accountType" value="1" />
				                        </span>
				                    </div>
				                    <div class="item">
				                        <div class="left"> <a href="#" class="thumb"> <img src="${pageContext.request.contextPath }/resources/images/enrollFrm/gap.png" alt=""> </a>
				                            <div class="purchase">
				                                <h6>업체 사용자</h6>
				                            </div>
				                        </div>
				                        <span class="price">
				                        	<input type="radio" name="accountType" value="0" />
				                        </span>
				                    </div>
				                </div>
				            </section>
				            <!-- SECTION 2 -->
				            <h4></h4>
				            <section>
				                <div class="form-row">
   									<input type="text" name="id" id="memberId" class="form-control" placeholder="아이디를 입력하세요"/>
				                </div>
				                <div class="form-row">
				                	<input type="text" name="name" class="form-control" placeholder="이름을 입력하세요"> 
			                	</div>
				                <div class="form-row">
				                	<input type="password" name="password" class="form-control" placeholder="비밀번호를 입력하세요">
				                </div>
				                <div class="form-row">
				                	<input type="password" name="passwordChk" class="form-control" placeholder="비밀번호를 입력하세요">
				                </div>
				                <div class="form-row">
				                	<input type="text" name="ssn1" class="form-control" placeholder="주민번호 앞자리를 입력하세요">
				                </div>
				                <div class="form-row">
				                	<input type="password" name="ssn2" class="form-control" placeholder="주민번호 뒷자리를 입력하세요">
  									<input type="hidden" name="personalId" />
				                </div>
				            </section>
				            <!-- SECTION 3 -->
				            <h4></h4>
				            <section>
				            	<div class="form-row">
				            		<input type="text" class="form-control" style="border:none;" placeholder="* 프로필사진을 등록하세요(미등록 시 기본이미지로 설정됩니다.)" />
				                	<input type="file" name="pictureFile" class="form-control">
				                	<input type="hidden" name="picture" value="user_pic_default.png" />
				                </div>
				                <div class="form-row">
				                	<input type="text" id="postcode" class="form-control" placeholder="우편번호" readonly>
				                	<input type="button" class="form-control" value="우편번호 찾기" onclick="execDaumPostcode();" style="background-color:#edeaea;"/>
				                </div>
				                <div class="form-row">
				                	<input type="text" class="form-control" id="roadAddress" placeholder="도로명주소" />
   									<span id="guide" style="color:#999;display:none"></span>
				                </div>
				                <div class="form-row">
				                	<input type="text" class="form-control" id="detailAddress" name="addressFull" placeholder="상세주소">
				                	<input type="hidden" name="addressAll" />
									<input type="hidden" name="locationX" />
									<input type="hidden" name="locationY" />
				                </div>
				                <div class="form-row" style="margin-bottom: 18px">
				                	<textarea name="introduce" id="introduce" class="form-control" placeholder="소개를 입력하세요" style="height: 108px"></textarea>
				                </div>
				            </section>
				            <h4></h4>
				            <section>
				        		<input type="button" value="제출" />
				            </section>
				        </div>
				    </form:form>
				</div>
								
				<!-- new End -->

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a77e005ce8027e5f3a8ae1b650cc6e09&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	/* $(document.enrollFrm).submit((e) => {
		e.preventDefault();
		console.log("주민번호");
		const ssn1 = $("[name=ssn1]").val();
		const ssn2 = $("[name=ssn2]").val();
		
		const pId = ssn1 + '-' + ssn2;
		$("[name=personalId]").val(pId);
		console.log(pId);
		$(document.enrollFrm).submit();
	}); */

function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("roadAddress").value = roadAddr;
            
            $("[name=addressAll]").val(data.roadAddress);
            
            /* kakao */
            var geocoder = new kakao.maps.services.Geocoder();

            var callback = function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    console.log(result[0].x);
                    console.log(result[0].y);
                    $('[name=locationX]').val(result[0].x);
                    $('[name=locationY]').val(result[0].y);
                } else{
                	console.log('실패');
                	$("[name=addressAll]").val('');
                	$("#roadAddress").val('');
                	$("#postcode").val('');
                	alert("유효하지 않은 주소입니다. 다시 검색해주세요.");
                }
            };

            geocoder.addressSearch(data.roadAddress, callback);
            
        	close();
        }
    }).open();
}
</script>

<!-- form script  -->
<script>
$(function(){
	$("#wizard").steps({
	headerTag: "h4",
	bodyTag: "section",
	transitionEffect: "fade",
	enableAllSteps: true,
	transitionEffectSpeed: 500,
	onStepChanging: function (event, currentIndex, newIndex) {
	if ( newIndex === 1 ) {
	$('.steps ul').addClass('step-2');
	} else {
	$('.steps ul').removeClass('step-2');
	}
	if ( newIndex === 2 ) {
		console.log("test1")
	$('.steps ul').addClass('step-3');
	} else {
		console.log("test2")
		$('.steps ul').removeClass('step-3');
	}

	if ( newIndex === 3 ) {
		console.log("test3");
		
		 if($("[name=accountType]:checked").val() == null){
			alert("계정유형이 선택되지 않았습니다.");
			return false
		} else if($("#id").val() == ''){
			alert("아이디가 입력되지 않았습니다.");
			return false;
		} else if($("[name=name]").val() == ''){
			alert("이름이 입력되지 않았습니다.");
			return false;
		} else if($("[name=password]").val() == ''){
			alert("비밀번호가 입력되지 않았습니다.");
			return false;
		} else if($("[name=passwordChk]").val() == ''){
			alert("비밀번호 확인을 해주세요.");
			return false;
		} else if($("[name=ssn1]").val() == ''){
			alert("주민번호를 입력해주세요");
			return false;
		} else if($("[name=ssn2]").val() == ''){
			alert("주민번호 뒷자리를 입력해주세요");
			return false;
		} else if($("#roadAddress").val() == ''){
			alert("도로명주소가 검색되지 않았습니다.");
			return false;
		} else if($("#postcode").val() == ''){
			alert("우편번호 찾기를 통해 우편번호를 입력해주세요");
			return false;
		} else if($("#detailAddress").val() == ''){
			alert("상세주소가 입력되지 않았습니다.");
			return false;
		} else if($("#introduce").val() == ''){
			alert("소개를 입력해주세요");
			return false;
		}
		const ssn1 = $("[name=ssn1]").val();
		const ssn2 = $("[name=ssn2]").val();
		
		const pId = ssn1 + '-' + ssn2;
		$("[name=personalId]").val(pId);

		$(document.enrollFrm).submit();
	} else {
		console.log("test4");
	$('.steps ul').removeClass('step-4');
	$('.actions ul').removeClass('step-last');
	}
	return true;
	},
	labels: {
	finish: "가입하기",
	next: "Next",
	previous: "Previous"
	}
	});
	// Custom Steps Jquery Steps
	$('.wizard > .steps li a').click(function(){
	$(this).parent().addClass('checked');
	$(this).parent().prevAll().addClass('checked');
	$(this).parent().nextAll().removeClass('checked');
	});
	// Custom Button Jquery Steps
	$('.forward').click(function(){
	$("#wizard").steps('next');
	})
	$('.backward').click(function(){
	$("#wizard").steps('previous');
	})
	// Checkbox
	$('.checkbox-circle label').click(function(){
	$('.checkbox-circle label').removeClass('active');
	$(this).addClass('active');
	})
	})
	
</script>



<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>