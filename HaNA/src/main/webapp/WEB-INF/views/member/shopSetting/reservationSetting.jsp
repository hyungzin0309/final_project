<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:requestEncoding value="utf-8"/>
<style>
.rsTableContainer { 
    background: linear-gradient(45deg, #49a09d, #5f2c82);
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width:100%;
}

table {
    width: 100%;
    border-collapse: collapse;
    /* overflow: hidden; */
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    table-layout:fixed;
    word-break:break-all;
}

th,
td {
    padding: 10px;
    background-color: rgba(255, 255, 255, 0.2);
    color: black;
}

th {
    text-align: left;
}

thead th {
    background-color: #55608f;
}

tbody td {
    position: relative;
    border-bottom: 1px dotted gray;
}
</style>

<jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="예약 설정" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberSetting.css" />
<section>
<sec:authentication property="principal" var="loginMember"/>

<br/><br/><br/><br/>
<div class="container">
    <div class="row">
    	<!-- 메뉴 영역 -->
        <div class="col-sm-3">
        	<ul class="list-group">
        	  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/personal'">개인정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/shopInfo'">업체정보 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/password'">비밀번호 변경</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/hashtag'">해시태그 설정</li>
			  <li class="list-group-item active" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationSetting'">예약 관리</li>
			  <li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/member/shopSetting/reservationPriceSetting'">요금 관리</li>
				<li class="list-group-item" onclick="location.href='${pageContext.request.contextPath}/shop/reservationStatistics'">예약 통계</li>	
			</ul>
        </div>
        <!-- 설정 영역 -->
        <div class="col-sm-9">	        
	        <div class="rsTableContaier">
	        	<h3>예약 테이블 설정</h3>
				<table id="rsTable">
					<colgroup>
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="15%">
						<col width="17%">
						<col width="25%">
						<col width="15%">
						<col width="10%">
					</colgroup>
				
					<thead>
						<tr>
							<th>이름</th>
							<th>인원</th>
							<th>시작시간</th>
							<th>종료시간</th>
							<th>시간단위(분)<br/>/최대시간(분)</th>
							<th>특이사항</th>
							<th>사용여부</th>
							<th>저장/삭제</th>
						</tr>
					</thead>
					<tbody></tbody>
					<tfoot>
						<tr>
							<td colspan=8 style="text-align:center;">
								<input type="button" id="tableAppendBtn" value="추가" data-calnum="0" style="width:100%;height:100%;"/>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>
        </div>
    </div>
</div>


<script>
/* 등록된 table이 없는 경우 안내문구 노출 */
/* onload 시 테이블 불러옴 */
$(() => {
	if($("#rsTable tbody").text() == ''){
		$("#rsTable tbody").append("<tr data-table-no=0><td colspan=7>등록된 테이블이 없습니다. 추가를 통해 등록해주세요</td></tr>");
	};
	
	$.ajax({
		url: '${pageContext.request.contextPath}/shop/loadShopTable',
		data:{
			id: '${loginMember.id}'
		},
		success(res){
			let calnum = $("#tableAppendBtn").data('calnum');
			if(res != ''){
				if($("#rsTable tbody tr").last().data('table-no') == 0){
					$("#rsTable tbody").empty();
				};	
			}
			
			
			$.each(res, function(i, e){
				calnum += 1;
				$("#tableAppendBtn").data('calnum', calnum);
				
				let columnForm = `
					<tr id="table\${calnum}" data-table-no="\${calnum}">
						<td>
							<textarea name="tableName\${calnum}" cols="10" rows="2">\${e.tableName}</textarea>
						</td>
						<td>
							<input type="number" name="allowVisitor\${calnum}" min="1" step="1" value="\${e.allowVisitor}" style="width:50px;"/>
						</td>
						<td>
						 	<input type="time" name="allowStart\${calnum}" value="\${e.allowStart}" style="width:100%;font-size:13px;"/>
						</td>
						<td>
							<input type="time" name="allowEnd\${calnum}" value="\${e.allowEnd}" style="width:100%;font-size:13px;"/>
						</td>
						<td>
							<input type="number" name="timeDiv\${calnum}" min="10" max="60" step="10" value="\${e.timeDiv}" style="width:100px;"/>
							<input type="number" name="timeMax\${calnum}" min="10" step="10" value="\${e.timeMax}" style="width:100px;"/>
						</td>
						<td>
							<textarea name="memo\${calnum}" cols="18" rows="3" placeholder="내용을 입력하세요">\${e.memo}</textarea>
						</td>
						<td>
						  <select name="enable\${calnum}" id="select-enable">
						    <option value="" disabled selected>사용여부</option>
						    <option id="enableY" value="Y">Y</option>
						    <option id="enableN" value="N">N</option>
						  </select>
						</td>
						<td>
							<input type="submit" class="updateBtn" value="수정" onclick="updateFrm(\${calnum});"/>
							<input type="button" class="deleteBtn" value="삭제" onclick="deleteTable(\${calnum});"/>
						</td>
						<input type="hidden" name="tableId\${calnum}" value="\${e.tableId}" />
					</tr>
						`;

				$("#rsTable tbody").append(columnForm);
				
				if(e.enable == 'Y'){
					$(`[name=enable\${calnum}]`).children('#enableY').attr('selected', true);
				} else{
					$(`[name=enable\${calnum}]`).children('#enableN').attr('selected', true);
				}

			})
		},
		error: console.log
	});
});

/* table 추가 등록 */
$("#tableAppendBtn").click((e) => {
	if($("#rsTable tbody tr").last().data('table-no') == 0){
		$("#rsTable tbody").empty();
	}
	$(e.target).data('calnum', $(e.target).data('calnum')+1);
	let columnForm = `
		<tr id="table\${$(e.target).data('calnum')}" data-table-no="\${$(e.target).data('calnum')}">
			<td>
				<textarea name="tableName\${$(e.target).data('calnum')}" cols="10" rows="2" required></textarea>
			</td>
			<td>
				<input type="number" name="allowVisitor\${$(e.target).data('calnum')}" min="1" step="1" value="1" style="width:50px;"/>
			</td>
			<td>
			  	<input type="time" name="allowStart\${$(e.target).data('calnum')}" style="width:100%;font-size:13px;" min="10:00"/>
			</td>
			<td>
			  	<input type="time" name="allowEnd\${$(e.target).data('calnum')}" style="width:100%;font-size:13px;" max="18:00"/>
			</td>
			<td>
				<input type="number" name="timeDiv\${$(e.target).data('calnum')}" min="10" max="60" step="10" value="10" style="width:100px;"/>
				<input type="number" name="timeMax\${$(e.target).data('calnum')}" min="10" step="10" value="60" style="width:100px;"/>
			</td>
			<td>
				<textarea name="memo\${$(e.target).data('calnum')}" cols="18" rows="3" placeholder="내용을 입력하세요"></textarea>
			</td>
			<td>
			  <select name="enable\${$(e.target).data('calnum')}" id="select-enable">
			    <option value="" disabled>사용여부</option>
			    <option value="Y">Y</option>
			    <option value="N">N</option>
			  </select>
			</td>
			<td>
				<input type="submit" class="enrollBtn" value="등록" onclick="enrollFrm(\${$(e.target).data('calnum')});"/>
				<input type="button" class="cancleBtn" value="취소" onclick="cancleTable(\${$(e.target).data('calnum')});"/>
			</td>
		</tr>
			`;

	$("#rsTable tbody").append(columnForm);
});

/* 테이블 추가 취소 func */
function cancleTable(num){
	$(`#table\${num}`).remove();
};

/* 테이블 신규 등록 func */
function enrollFrm(num){
	const content = {
			shopId: '${loginMember.id}',
			tableName : $(`[name=tableName\${num}]`).val(),
			allowVisitor: $(`[name=allowVisitor\${num}]`).val(),
			allowStart : $(`[name=allowStart\${num}]`).val(),
			allowEnd : $(`[name=allowEnd\${num}]`).val(),
			timeDiv : $(`[name=timeDiv\${num}]`).val(),
			timeMax : $(`[name=timeMax\${num}]`).val(),
			memo : $(`[name=memo\${num}]`).val(),
			enable : $(`[name=enable\${num}]`).val()
	};
	
	const tableStr = JSON.stringify(content);

	$.ajax({
		url: '${pageContext.request.contextPath}/shop/insertShopTable?${_csrf.parameterName}=${_csrf.token}',
		method: "POST",
		data: tableStr,
		contentType: "application/json; charset=utf-8",
		success(res){
			alert(res.msg);
			$(`#table\${num}`).find("td:last").empty();
			
			let btns = `
				<input type="submit" class="updateBtn" value="수정" onclick="updateFrm(\${num});"/>
				<input type="button" class="deleteBtn" value="삭제" onclick="deleteTable(\${num});"/>
			`;
			
			$(`#table\${num}`).find("td:last").append(btns);
		},
		error:console.log
	});
	
}

/* 테이블 삭제 func */
function deleteTable(num){
	if(!confirm("삭제하시겠습니까?\n예약이 등록되어 있는 경우 삭제가 불가합니다.")){
		return;
	};
	
	let tableId_ = $(`[name=tableId\${num}]`).val();
	
	let content = {
			tableId: tableId_
	}
	
	let jsonData = JSON.stringify(content);
	
	$.ajax({
		url: `${pageContext.request.contextPath}/shop/deleteShopTable?${_csrf.parameterName}=${_csrf.token}`,
		method: 'DELETE',
		data: jsonData,
		contentType: "application/json; charset=utf-8",
		success(res, textStatus, xhr){
			alert("삭제되었습니다.");
			$(`#table\${num}`).remove();
		},
		error(xhr){
			if(xhr.status == 404){
				alert("등록된 예약이 있어 삭제할 수 없습니다.");
			} else if(xhr.status == 406){
				alert("삭제할 테이블 조회에 오류가 발생했습니다.\n관리자에게 문의하세요.");
			}
				
		}
	});
	
};

/* 테이블 수정 func */
function updateFrm(num){
	if(!confirm("수정하시겠습니까?\n예약이 등록되어 있는 경우, 특이사항과 사용여부만 변경 가능합니다.")){
		return;
	};
	
	const content = {
			shopId: '${loginMember.id}',
			tableId : $(`[name=tableId\${num}]`).val(),
			tableName : $(`[name=tableName\${num}]`).val(),
			allowVisitor: $(`[name=allowVisitor\${num}]`).val(),
			allowStart : $(`[name=allowStart\${num}]`).val(),
			allowEnd : $(`[name=allowEnd\${num}]`).val(),
			timeDiv : $(`[name=timeDiv\${num}]`).val(),
			timeMax : $(`[name=timeMax\${num}]`).val(),
			memo : $(`[name=memo\${num}]`).val(),
			enable : $(`[name=enable\${num}]`).val()
	};
	
	const tableStr = JSON.stringify(content);
	console.log(tableStr);

	$.ajax({
		url: '${pageContext.request.contextPath}/shop/updateShopTable?${_csrf.parameterName}=${_csrf.token}',
		method: "PUT",
		data: tableStr,
		contentType: "application/json; charset=utf-8",
		success(res, textStatus, xhr){
			alert("수정되었습니다.");
		},
		error(xhr){
			if(xhr.status == 404){
				alert("등록된 예약이 있습니다.\n특이사항과 사용여부만 수정 되었습니다.");
			}
		}
	});	
}


</script>

</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>>