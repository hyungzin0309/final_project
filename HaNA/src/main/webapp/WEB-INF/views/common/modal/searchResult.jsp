<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/search.css" />

<div class="search-box-container">
	<div class="search-box-container-row row">
		<div class="col-sm-4 select-box-container">
			<select name="search-category" id="select-box">
				<option value="member" >계정</option>
				<option value="group" >소모임</option>
				<option value="shop" >비즈니스</option>
				<option value="location" >장소</option>
			</select>
		</div>
		<div class="col-sm-8">
			<input id="search-box" type="text"  placeholder="검색어 입력.."/>
		</div>
	</div>
</div>

<div id="searchResultBox">
	<div id="content-box">
	</div>
</div>

<script>
	// 검색창 활성시 결과창 on
	$("#search-box, #content-box").focus((e)=>{
		$("#searchResultBox").css('display','inline');
	})
	
	// 검색창 비활성시 결과창 off
 	$("#search-box").blur((e)=>{
		setTimeout(function() {
			$("#searchResultBox").css('display','none');
		}, 150);
	})
	

	
	let timer;
	
	function searchKeywordLog(){
		timer = setTimeout(function(){
		    let keyword = $("#search-box").val()
			let category = $("#select-box").val();
			if(keyword != ''){
			    $.ajax({
			    	url:"${pageContext.request.contextPath}/search/searchKeywordLog",
			    	method:"POST",
			    	data:{
			    		keyword,
			    		category
			    	},
			    	success(data){
			    		console.log(data)
			    	},
			    	error:console.log
			    })				
			}
		},1000)
	}
	  
	$("#search-box").keyup((e)=>{
		
		clearInterval(timer);
		
		let category = $("#select-box").val();
		let keyword = $(e.target).val();
		console.log(category);
		console.log(keyword);
		$.ajax({
			url:`${pageContext.request.contextPath}/search/\${category}`,
			data:{
				keyword
			},
			success(data){
				console.log(data);
				if(category == 'member'){
					getMemberList(data);			
				}
				else if(category == 'group'){
					getGroupList(data);						
				}
				else if(category == 'shop'){
					getMemberList(data);						
				}
				else if(category == 'location'){
					getLocationList(data);						
				} 
			},
			error:console.log
		})
		searchKeywordLog();
	})
	
	function getMemberList(data){
		$("#content-box").empty();
		$.each(data,function(i,member){
			let row = `<div class="row row-box" onclick="location.href='${pageContext.request.contextPath}/member/memberView/\${member.id}'">
				<div class="col-sm-5">
					<img src='${pageContext.request.contextPath}/resources/upload/member/profile/\${member.picture}' alt='' />
				</div>
				<div class="col-sm-1"></div>
				<div class="col-sm-6">
					<div class="row memberId">\${member.id}</div>
					<div class="row memberName">\${member.name}</div>
				</div>
			</div>`
			$("#content-box").append(row);	
		})
	}
	function getGroupList(data){
		$("#content-box").empty();
		$.each(data,function(i,group){
			let row = `<div class="row row-box" onclick="location.href='${pageContext.request.contextPath}/group/groupPage/\${group.groupId}'">
				<div class="col-sm-5">
					<img src='${pageContext.request.contextPath}/resources/upload/group/profile/\${group.image}' alt='' />
				</div>
				<div class="col-sm-1"></div>
				<div class="col-sm-6">
					<div class="row groupId">\${group.groupId}</div>
					<div class="row groupName">\${group.groupName}</div>
				</div>
			</div>`
			$("#content-box").append(row);	
		})
	}
	function getLocationList(data){
		$("#content-box").empty();
		$.each(data,function(i,location){
			let row = `<div class="row row-box" onclick="$(document.locationFrm\${i}).submit();">
				<div class="col-sm-3">
				</div>
				<div class="col-sm-9">
					<div class="row locationName">\${location.placeName}</div>
					<div class="row locationAddress">\${location.placeAddress}</div>
				</div>
			</div>`
			let form = `<form action="${pageContext.request.contextPath}/group/searchLocation" name="locationFrm\${i}">
				<input type="hidden" value="\${location.placeName}" name="placeName"/>
				<input type="hidden" value="\${location.placeAddress}" name="placeAddress"/>
				<input type="hidden" value="\${location.locationY}" name="locationY"/>
				<input type="hidden" value="\${location.locationX}" name="locationX"/>
			</form>`
			$("#content-box").append(row);	
			$("#content-box").append(form);	
		})
	}
	
</script>