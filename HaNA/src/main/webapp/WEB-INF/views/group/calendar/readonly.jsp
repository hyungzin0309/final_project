<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
  <div style="width:80%;margin:auto;">
	 <div id='calendar-container' style="width:100%;">
	     <div id='calendar'></div>
	  </div>
  </div>
		
<script>
console.log('asldfjn');
      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
		locale:'ko',
          initialView: 'dayGridMonth',
          headerToolbar: {
		      left: 'prev,next today',
		      center: 'title',
		      right: 'dayGridMonth,timeGridWeek,timeGridDay'
		    },
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
		    ]
        });
        calendar.render();
        console.log('asldjf');
      });

</script>
