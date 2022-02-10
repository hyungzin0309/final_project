<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script> 
<fmt:requestEncoding value="utf-8"/>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param value="메인화면" name="main"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupPlus.css" />

<div class="wrapper bg-white">
    <div class="h6 font-weight-bold"> 게시글 포스팅 </div>
    <form
    	name="groupBoardFrm"
        action="${pageContext.request.contextPath}/group/enrollGroupBoard?${_csrf.parameterName}=${_csrf.token}"
        method="POST"
        enctype="multipart/form-data">
	    <input type="hidden" value="<sec:authentication property='principal.username'/>" name="writer"/>
	    <input type="hidden" value="${groupId}" name="groupId"/>
    
    <div class="font-weight-bold head pb-1">작성할 글과 함께 첨부할 파일을 선택해주세요.</div> 
    	<textarea id="desc" cols="50" rows="5" placeholder="Post" name="content"></textarea> <br />
    <div id="abc">
		<div class="font-weight-bold head pb-2">
		    <label class="labels"></label>
		    <input type="file" class="form-control" placeholder=File name="file" id="file1" value="파일 선택" style="width: 93%; float: left;">
		    <button type="button" id="addFile" class="btn btn-primary" onclick="addFileBtn();" style="margin-left: 2%;">+</button>
		</div>
	</div>
	<br />
	
    <div class="group-board-form tag-member-btn" style="color:#3f51b5; font-size:1.1em; font-weight:bold;" onclick="$('#groupMemberList').modal('show');">멤버 태그</div>
	    <!-- 회원목록보기 modal -->
			<div class="modal fade" id="groupMemberList" tabindex="-1">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-body">
							<div id="groupMemberListTableContainer">
								<table id="groupMemberListTable">
									<c:forEach items="${members}" var="member" varStatus="vs">
										<tr>
						 					<td>
						 						<a href="javascript:void(0);" onclick="clickMember('tagMember${vs.index}');" >
						 						<img style="width:50px; height:50px; border-radius:50%" src="<%=request.getContextPath()%>/resources/upload/member/profile/${member.profile}" alt="" />
						 						</a> 
						 					</td>
						 					<th>
						 						<a href="javascript:void(0);" onclick="clickMember('tagMember${vs.index}');" style="color:black; text-decoration:none;">
						 							&nbsp;&nbsp;&nbsp;&nbsp;${member.memberId}
						 						</a>
						 							<c:if test="${member.memberLevelCode eq 'ld'}"><span style="color:#ff5722">&nbsp;&nbsp;[Leader]</span></c:if>
						 							<c:if test="${member.memberLevelCode eq 'mg'}"><span style="color:#ff9800">&nbsp;&nbsp;[Manager]</span></c:if>
						 					</th> 
						 					<td>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="tagMembers" value="${member.memberId}" id="tagMember${vs.index}"/></td>
						 				</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		<br />
  		<div style="margin-bottom:10px;"><span style="font-size:1.1em; font-weight:bold;">Location Tag</span></div>
		<div class="map_wrap">
		    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
		
		    <div id="menu_wrap" class="bg_white">
		        <div class="option">
		            <div>
		                <form onsubmit="searchPlaces(); return false;">
		                    키워드 : <input type="text" value="이태원 맛집" id="keyword" size="15"> 
		                    <button type="submit">검색하기</button> 
		                </form>
		            </div>
		        </div>
		        <hr>
		        <ul id="placesList"></ul>
		        <div id="pagination"></div>
		    </div>
		</div>
		<div class="row" style="margin-top:20px;">
            <div class="col-6"> 
                <div class="form-group"> <input id="placeName" class="form-control" name="placeName" type="text" value="" readonly/>
                    <div class="label" id="tel"></div>
                </div>
            </div>
            <div class="col-6">
                <div class="form-group"> <input id="placeAddress" class="form-control" name="placeAddress" type="text" value="" readonly/>
                    <div class="label" id="email"></div>
                </div>
            </div>
            <input id="locationY" name="locationY" type="hidden" value="" readonly/>
            <input id="locationX" name="locationX" type="hidden" value="" readonly/>
        </div>
        </form>
        <br />
	    <div class="d-flex justify-content-end pt-2">
	        <div class="btn btn-primary" onclick="submitBoard();">등록하기</div>
	    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fe4df2cda826ac2a53225fb7dea2a307&libraries=services"></script>
<script>
// 태그멤버 클릭시 체크박스 on/off
function clickMember(id){
	console.log(id);
	var checked = $(`#\${id}`).is(':checked');
	$(`#\${id}`).prop('checked',!checked);
}

function addFileBtn(){
	var rowItem = '<div class=font-weight-bold head pb-2>'
		rowItem += '<label class=labels></label>'
        rowItem += '<input type=file class=form-control placeholder=File name=file id=file1 value=파일 선택>'
		rowItem += '</div>';

	$('#abc').append(rowItem); 
}

// 카카오 지도 API

// 마커를 담을 배열입니다
var markers = [];
var place = [];
var placeList = [];

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places(); 

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 키워드로 장소를 검색합니다
searchPlaces();

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}
// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {
	placeList = [];
    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    for ( let i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
        console.log(places[i].y);
        console.log(places[i].x);
		place.push(places[i].y);
		place.push(places[i].x);
		placeList.push(place);
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);
        // 마커와 검색결과 항목에 mouseover 했을때
        // 해당 장소에 인포윈도우에 장소명을 표시합니다
        // mouseout 했을 때는 인포윈도우를 닫습니다
        (function(marker, title) {
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                displayInfowindow(marker, title);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            kakao.maps.event.addListener(marker, 'click', function() {
				$("#placeName").val(placeList[i][0]);
				$("#placeAddress").val(placeList[i][1]);
				$("#locationY").val(placeList[i][2]);
				$("#locationX").val(placeList[i][3]);
            });

            itemEl.onmouseover =  function () {
                displayInfowindow(marker, title);
            };

            itemEl.onclick =  function () {
				$("#placeName").val(placeList[i][0]);
				$("#placeAddress").val(placeList[i][1]);
				$("#locationY").val(placeList[i][2]);
				$("#locationX").val(placeList[i][3]);
			};
            
            itemEl.onmouseout =  function () {
                infowindow.close();
            };
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
    }

    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {
	
	place = [];
	place.push(places.place_name);
	place.push(places.address_name);

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다
    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
	console.log(placeList);

    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                    placeList = [];
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
    infowindow.setContent(content);
    infowindow.open(map, marker);
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }

} 

//이미지 미리보기
function setThumbnail(event){
	var reader = new FileReader();
	reader.onload = function(event) {
		var img = document.createElement("img");
		img.setAttribute("src", event.target.result);
		img.setAttribute("style", "width:200px;");
		document.querySelector("div#image_container").appendChild(img);
		};
	reader.readAsDataURL(event.target.files[0]);
}

function submitBoard(){
	if($("[name=locationX]").val() == ""){
		alert("장소를 태그하세요.");
	}
	else {
		$(document.groupBoardFrm).submit();
	}
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins&display=swap');

* {
    padding: 0;
    margin: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif
}

body {
    background-color: #EEE;
    font-size: 0.9rem
}

input {
    font-size: 0.85rem
}

.wrapper {
    max-width: 50%;
    height:80%;
    margin: 40px auto;
    border: 1px solid #ddd;
    border-radius: 6px;
    padding: 20px;
    padding-top:2%;
}

.form-control {
    height: 35px
}

.form-control:focus {
    box-shadow: none;
    border: 1px solid rgb(50, 147, 238);
    outline-color: rgb(50, 147, 238)
}

.head {
    font-size: 0.8rem;
    color: #555
}

textarea {
    display: block;
    width: 100%;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 2px;
    outline-color: rgb(50, 147, 238)
}

.btn {
    font-size: 0.8rem
}

.btn-cancel {
    background-color: #eee
}

.btn-cancel:hover {
    background-color: rgb(236, 59, 59);
    color: #fff
}

.btn-group .btn-primary {
    background-color: rgb(223, 238, 255);
    color: rgb(50, 147, 238);
    border: none;
    box-shadow: none
}

.btn-group .btn {
    border-radius: 12px
}

label {
    margin-bottom: 0
}

.btn-group>.btn-group:not(:last-child)>.btn,
.btn-group>.btn:not(:last-child):not(.dropdown-toggle),
.btn-group>.btn-group:not(:first-child)>.btn,
.btn-group>.btn:not(:first-child) {
    border-radius: 50px
}

input::placeholder {
    font-size: 0.8rem
}

input:focus::placeholder {
    color: transparent
}

.alert-dismissible {
    padding-right: 4rem
}

.alert {
    padding: 0.4rem 1.5rem 0.4rem 1.5rem;
    outline: none
}


.form-group {
    position: relative
}

.close {
    outline: none
}

.label::after {
    position: absolute;
    background-color: #fff;
    top: 15px;
    left: 10px;
    font-size: 0.8rem;
    padding: 0rem .1rem;
    margin: 0rem 0.4rem;
    color: rgb(50, 147, 238);
    transition: all .2s ease-in-out;
    transform: scale(0)
}

.label#name::after {
    content: 'Name'
}

.label#tel::after {
    content: 'Phone'
}

.label#email::after {
    content: 'Email'
}

input:focus~.label::after {
    top: -10px;
    left: 0;
    transform: scale(1)
}

button.close {
    outline: none
}
.tag-member-btn:hover {
cursor:pointer;}
.group-board-form .tag-member-bt {
}
</style>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include> 
