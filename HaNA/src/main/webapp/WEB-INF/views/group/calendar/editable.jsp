<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    
	<div class="external-events-container-container">
			<div class="external-events-container">
				  <div id='external-events'>
					<div style="margin-bottom:20px; font-weight:bold;">drag event <br /> after create</div>
				    <div class='fc-event fc-h-event fc-daygrid-event fc-daygrid-block-event'>
				      <div class='fc-event-main title'></div>
				    </div>
				    <div>
				    	<textarea placeholder="이벤트 제목 입력.." id="eventTitleInput"></textarea>
				    	<button id="createEventButton" onclick="createEventTitle();">이벤트 생성</button>
				    </div>
				
				    <!-- <p>
				      <input type='checkbox' id='drop-remove' />
				      <label for='drop-remove'>remove after drop</label>
				    </p> -->
				  </div>
				  <div class="calendarSaveBtnContainer">
				  	<span style="font-weight:bold; color:gray;">캘린더</span>
				  	<button onclick="saveButton();" class="calendarSave">저장</button>
				</div>
			</div>
		</div>
	  <div id='calendar-container'>
	     <div id='calendar'></div>
	  </div>

<%
	String groupId = request.getParameter("groupId");
	pageContext.setAttribute("groupId",groupId);
%>
<script>


let calendar;
let currentTitle;
let allEvents;

	//ajax POST 요청 csrf
	var csrfToken = $("meta[name='_csrf']").attr("content");
	$.ajaxPrefilter(function(options, originalOptions, jqXHR){
	    if (options['type'].toLowerCase() === "post" || options['type'].toLowerCase() === "delete" || options['type'].toLowerCase() === "put") {
	        jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
	    }
	  });
	
	// 캘린더
	document.addEventListener('DOMContentLoaded', function() {
		  var Calendar = FullCalendar.Calendar;
		  var Draggable = FullCalendar.Draggable;
	
		  var containerEl = document.getElementById('external-events');
		  var calendarEl = document.getElementById('calendar');
	/* 	  var checkbox = document.getElementById('drop-remove');
	 */
		  // initialize the external events
		  // -----------------------------------------------------------------
		
	  
		  new Draggable(containerEl, {
		    itemSelector: '.fc-event',
		    eventData: function(eventEl) {
		      return {
		        title: eventEl.innerText
		      };
		    }
	
		  });
	
		  // initialize the calendar
		  // -----------------------------------------------------------------
	
		  calendar = new Calendar(calendarEl, {
			locale:'ko',
		    headerToolbar: {
		      left: 'prev,next today',
		      center: 'title',
		      right: 'dayGridMonth,timeGridWeek,timeGridDay'
		    },
		    //이벤트 불러오기
		    events:[
		    	$.ajax({
					url:"${pageContext.request.contextPath}/group/getCalendarData/${groupId}",
					dataType: 'json',
					success:function (data){
						for(i=0; i<data.length; i++){
					    	let start = new Date(data[i]['start']);
					    	let end = new Date(data[i]['end']);
					    	console.log(start);
					    	console.log(end);
					    	start.setHours(start.getHours()-9);
					    	end.setHours(end.getHours()-9);

							calendar.addEvent({
								title:data[i]['title'],
								start:start,
								end:end,
								allDay:data[i]['allDay']
							})	
						}
					},
					error:console.log
				})
		    ],
		    // 이벤트 클릭시 삭제
		    eventClick:function(info){
		    
		    	if(confirm(`\${info.event.title} - 를 삭제하시겠습니까?`)){
		    		let obj = {
							title:info.event.title,
							allDay:info.event.allDay,
							start:info.event._instance.range.start,
							end:info.event._instance.range.end
		    		};
		    		let data = JSON.stringify(obj);
		    		console.log(data);
		    		$.ajax({
						url:"${pageContext.request.contextPath}/group/deleteCalendarData/${groupId}",
						method:"POST",
						contentType:"application/json",
						data:data,
						success:function (data){
							window.location.reload();
						},
						error:console.log
					})
		    	}
		    	
		    },
		    editable: true,
		    droppable: true, // this allows things to be dropped onto the calendar
		    /* drop: function(info) {
		      // is the "remove after drop" checkbox checked?
		      if (checkbox.checked) {
		        // if so, remove the element from the "Draggable Events" list
		        info.draggedEl.parentNode.removeChild(info.draggedEl);
		      }
		    }, */
		  });
		  
		 
		  calendar.render();
	});
	
	// 저장버튼 눌렀을 때
	function saveButton(){
		allEvents = calendar.getEvents();
		console.log(allEvents);
		
		let events = new Array();
		for(let i=0; i < allEvents.length; i++){
			let obj = new Object();
			
			obj.title = allEvents[i]._def.title; // 타이틀
			obj.allDay = allEvents[i]._def.allDay; // 하루종일인지
			obj.start = allEvents[i]._instance.range.start; // 시작날짜 및 시간
			obj.end = allEvents[i]._instance.range.end; // 종료날짜 및 시간
			
		 	events.push(obj); // 이벤트 정보를 json문자열 형태로 변환
		}
		
		const jsonString = JSON.stringify(events);
		console.log(jsonString);
		
		saveCalendarData(jsonString);
	}
	// 데이터 저장 함수
	function saveCalendarData(data){
		
		$.ajax({
			url:"${pageContext.request.contextPath}/group/saveCalendarData/${groupId}",
			method:"POST",
			contentType: 'application/json',
			data:data,
			success(data){
				console.log(data);
			},
			error:console.log
		})
		
	}
	
	// 이벤트 생성
	$("#eventTitleInput").on("keyup",function(){
		currentTitle = $(this).val();
		console.log(currentTitle);
	})
	
	function createEventTitle(){
		$(".title").html(currentTitle);
	 }
		

</script>	