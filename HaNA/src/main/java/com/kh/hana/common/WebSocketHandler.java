package com.kh.hana.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.hana.chat.model.service.ChatService;
import com.kh.hana.chat.model.vo.Chat;
import com.kh.hana.chat.model.vo.ChatRoom;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class WebSocketHandler extends TextWebSocketHandler{
	
	@Autowired
	private ChatService chatService;
	
	private final ObjectMapper objectMapper = new ObjectMapper();

	 // 채팅방 목록 <방 번호, List<session> >이 들어간다.
    private Map<Integer, List<WebSocketSession>> RoomList = new HashMap<>();
    private Map<Integer, Map<WebSocketSession, String>> RoomList2 = new HashMap<>();
    // session, 방 번호가 들어간다.
    private Map<WebSocketSession, Integer> sessionList = new HashMap<>();
    
    private Map<String, WebSocketSession> userSessions = new HashMap<>();
    private Map<WebSocketSession, String> sessionsuser = new HashMap<>();
    
    int roomNo;
    
    String memberId;
    
    private static int i;
	
	//연결
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		i++;
		log.info("{} 연결 성공 => 접속 인원 : {}명", session.getId(),i);
		log.info("RoomList = {} , sessionList = {}", RoomList2, sessionList);

	}
	
	//메세지
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    // 전달받은 메세지
        String msg = message.getPayload();
        //log.info("msg = {}", msg);
        
        // Json객체 → Java객체
        // 출력값 : {"roomNo":21,"name":"jeonyeseong","message":"ENTER"}
        Chat chat = objectMapper.readValue(msg,Chat.class);
        //log.info("handleTextMessage - chat = {}", chat);
        
        List<String> loginusers = chatService.selectListReceiver(chat);
        log.info("loginusers = {}", loginusers);
        
        
        if(chat.getMessage() != null && chat.getMessage().equals("ENTER22")) {
        	
        	userSessions.put(chat.getMemberId(), session);
        	
        	sessionsuser.put(session, chat.getMemberId());
        	log.info("userSession에 id값 넣음 ={}", userSessions);
        	   	
        	
        }
        else {
        	userSessions.put(chat.getMemberId(), session);
        	
        	sessionsuser.put(session, chat.getMemberId());
        	log.info("userSession에 id값 넣음 ={}", userSessions);
        	
        	if(chat.getRoomNo() == 226 && chat.getMessage() != null) {
        		String[] messageSplit = chat.getMessage().split("@");
//        		log.info("messageSplit memberId= {}",messageSplit[0]);
//        		log.info("messageSplit = {}",messageSplit[1]);
//        		log.info("messageSplit = {}",messageSplit[2]);
//        		log.info("messageSplit = {}",messageSplit[3]);
//        		log.info("messageSplit = {}",messageSplit[4]);

    			TextMessage textMessage = new TextMessage(chat.getMemberId() + ","  + chat.getMessage()+ ","  + chat.getPicture()+ ","  +chat.getMessageRegDate()+","+chat.getRoomNo());

    				//messageSplit[0](받는 사람) id의 session이 없을때 웹소켓 전송
    				if(userSessions.get(messageSplit[0]) != null) {
    	            try {
    	            	userSessions.get(messageSplit[0]).sendMessage(textMessage);
    	            } catch( Exception ex ) {
    	                log.info("handleTextMessage roomno226일때= {}",ex );
    	                synchronized( userSessions ) {
    	                    userSessions.remove(sessionsuser.get(userSessions.get(messageSplit[0])));
    	                    sessionsuser.remove(userSessions.get(messageSplit[0]));
    	                }
    	            }
    				}
    				Map<String,Object> param = new HashMap<String, Object>();
    				param.put("memberId", chat.getMemberId());
    				param.put("ReceiverId", messageSplit[0]);
    				param.put("msg", messageSplit[1]);
    				param.put("boardNo", messageSplit[2]);
    				param.put("idORwriter", messageSplit[4]);
    				//null이 아니면 그룹게시판 null이면 일반게시판
    				if("일반".equals(messageSplit[3])) {
    					param.put("boardType", 0);
    				}
    				else if("그룹".equals(messageSplit[3])){
    					param.put("boardType", 1);
    				}
    				int result = chatService.insertNoti(param);
    				if(result>0) log.info("insertNoti 성공!");
    				else log.info("insertNoti 실패!");
    				
        	
        	}
        	else if(chat.getRoomNo() != 226 && chat.getMessage() != null) {
        		
        		// 받은 메세지에 담긴 roomId로 해당 채팅방을 찾아온다.
        		ChatRoom chatRoom = chatService.selectChatRoom(chat.getRoomNo());
        		log.info("handleTextMessage - chatRoom = {}", chatRoom);
        		
        		
        		// roomlist 생성
        		if(RoomList2.get(chatRoom.getRoomNo()) == null && chat.getMessage().equals("ENTER") && chatRoom != null) {
        			
//        			// 채팅방에 들어갈 session들
//        			List<WebSocketSession> sessionTwo = new ArrayList<>();
//        			// session 추가
//        			sessionTwo.add(session);
//        			// sessionList에 추가
//        			sessionList.put(session, chatRoom.getRoomNo());
//        			// RoomList에 추가
//        			RoomList.put(chatRoom.getRoomNo(), sessionTwo);
//        			// 확인용
//        			log.info("RoomList 생성 {}", RoomList);
//        			log.info("sessionList에 session, roomNo 저장 {}", sessionList);
        			
        			Map<WebSocketSession, String> sessionTwo = new HashMap<>();
        			sessionTwo.put(session, chat.getMemberId());
        			RoomList2.put(chatRoom.getRoomNo(), sessionTwo);
        			log.info("RoomList2 생성 {}", RoomList2);
        			log.info("sessionList에 session, roomNo 저장 {}", sessionList);
        			
        			int result = chatService.updateUnreadCount(chat);
        			//log.info(result > 0 ? "---------------unreadcount 성공" : "---------------unreadcount 실패");
        			
        			
        			//timerupdate(chat);
        		}
        		
        		else if(RoomList2.get(chatRoom.getRoomNo()) != null && chat.getMessage().equals("ENTER") && chatRoom != null) {
//        			RoomList.get(chatRoom.getRoomNo()).add(session);
//        			sessionList.put(session, chatRoom.getRoomNo());
//        			log.info("{}RoomList에 session 저장",chatRoom.getRoomNo());

        			RoomList2.get(chatRoom.getRoomNo()).put(session, chat.getMemberId());
        			sessionList.put(session, chatRoom.getRoomNo());
        			log.info("RoomList2 추가 {}", RoomList2);
        			log.info("sessionList에 session, roomNo 저장 {}", sessionList);
        			
        			int result = chatService.updateUnreadCount(chat);
        			//log.info(result > 0 ? "---------------unreadcount 성공" : "---------------unreadcount 실패");
        			//timerupdate(chat);
        		}
        		
        		else if(RoomList2.get(chatRoom.getRoomNo()) != null && !chat.getMessage().equals("ENTER") && chatRoom != null) {
        			//세션이 너무 자주 갱신돼서 roomlist도 갱신
        			RoomList2.get(chatRoom.getRoomNo()).put(session, chat.getMemberId());
        			sessionList.put(session, chatRoom.getRoomNo());
        			log.info("test ---- RoomList2 추가 {}", RoomList2);
        			log.info("test ---- sessionList에 session, roomNo 저장 {}", sessionList);
        			
        			// 메세지에 id, message, picture을 담는다.
        			TextMessage textMessage = new TextMessage(chat.getMemberId() + ","  + chat.getMessage()+ ","  + chat.getPicture()+ ","  +chat.getMessageRegDate()+","+chat.getRoomNo());
        			//log.info("메세지 보내기 testMessage = {}", textMessage);      			
        			
        			List<String> loginusers222 = new ArrayList<>(loginusers);
        			
        			log.info("로그인유저 제거 전 = {}", loginusers222);
        			log.info("chat.getMessage() = {}",chat.getMessage());
        			for(WebSocketSession sess : RoomList2.get(chat.getRoomNo()).keySet()) {
        				loginusers222.remove(RoomList2.get(chat.getRoomNo()).get(sess));
        	            try {
        	            	sess.sendMessage(textMessage);
        	            } catch( Exception ex ) {
        	                log.info("handleTextMessage = {}",ex );
        	                synchronized( RoomList2 ) {
            	    			RoomList2.get(sessionList.get(sess)).remove(sess);
            	    			sessionList.remove(sess);
        	                }
        	            }
        				
        			}
        			log.info("로그인유저 채팅 맴버 제거 후 = {}", loginusers222);
        			log.info("원래 로그인유저 = {}", loginusers);
        			
        				//같은 채팅방에 없구 로그인한 유저가 있으면 뿌려주기
        				for(String user : loginusers222) {

        					//없으면 null나옴
        					//log.info("로그인한 유저 확인 반복문 session = {}", userSessions.get(user));
        					if(userSessions.get(user) != null) {
                	            try {
                	            	userSessions.get(user).sendMessage(textMessage);
                	            } catch( Exception ex ) {
                	                log.info("handleTextMessage = {}",ex );
                	                synchronized( userSessions ) {
                	                    userSessions.remove(sessionsuser.get(userSessions.get(user)));
                	                    sessionsuser.remove(userSessions.get(user));
                	                }
                	            }
        					}
        						
        				}

        				log.info("로그인유저 채팅 맴버 제거 후 = {}", loginusers222);
        				log.info("원래 로그인유저 = {}", loginusers);
        			
        			//timerupdate(chat);
        			
        			//DB에 저장한다.
        			int a = chatService.insertMessage(chat);
        			
        			if(a == 1) {
        				//log.info("메세지 전송 및 DB 저장 성공");
//            			int result = chatService.updateUnreadCount(chat);
//            			log.info(result > 0 ? "---------------unreadcount 성공" : "---------------unreadcount 실패");
        			}else {
        				//log.info("메세지 전송 실패!!! & DB 저장 실패!!");
        			}
        			
        		}
        	}
        	else if(chat.getRoomNo() != 226 && chat.getMessage() == null && chat.getFileImg() != null) {
        		//log.info("파일보내기파일보내기파일보내기파일보내기파일보내기파일보내기파일보내기");
        		TextMessage textMessage = new TextMessage(chat.getMemberId() + ","  + chat.getMessage()+ ","  + chat.getPicture()+ ","  +chat.getMessageRegDate()+","+chat.getRoomNo()+","+chat.getFileImg());
        		//log.info("메세지 보내기 testMessage = {}", textMessage);
        		
        		//loginusers를 받아서 같이 채팅하고있는 유저 빼기
    			List<String> loginusers222 = new ArrayList<>(loginusers);
    			
    			for(WebSocketSession sess : RoomList2.get(chat.getRoomNo()).keySet()) {
    				loginusers222.remove(RoomList2.get(chat.getRoomNo()).get(sess));

    	            try {
    	            	sess.sendMessage(textMessage);
    	            } catch( Exception ex ) {
    	                log.info("handleTextMessage = {}",ex );
    	                synchronized( RoomList2 ) {
        	    			RoomList2.get(sessionList.get(sess)).remove(sess);
        	    			sessionList.remove(sess);
    	                }
    	            }    				
    			}
    			
    			//같은 채팅방에 없구 로그인한 유저가 있으면 뿌려주기
    			for(String user : loginusers222) {
    				
    				//없으면 null나옴
    				//log.info("로그인한 유저 확인 반복문 session = {}", userSessions.get(user));
    				if(userSessions.get(user) != null) {
    	            try {
    	            	userSessions.get(user).sendMessage(textMessage);
    	            } catch( Exception ex ) {
    	                log.info("handleTextMessage = {}",ex );
    	                synchronized( userSessions ) {
    	                    userSessions.remove(sessionsuser.get(userSessions.get(user)));
    	                    sessionsuser.remove(userSessions.get(user));
    	                }
    	            }
    	            
    				}
    				
    			}
    			
        		
        		//timerupdate(chat);
        		//DB에 저장한다.
        		int a = chatService.insertFileMessage(chat);
        		
        		if(a == 1) {
        			//log.info("메세지 전송 및 DB 저장 성공");
//        			int result = chatService.updateUnreadCount(chat);
//        			log.info(result > 0 ? "---------------unreadcount 성공" : "---------------unreadcount 실패");
        		}else {
        			//log.info("메세지 전송 실패!!! & DB 저장 실패!!");
        		}
        	}
        	
        	//여기까지 enter22
        }
		
	}
	
	//연결 끝
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {		
		i--;
		//log.info("{} 연결 종료 => 접속 인원 : {}명", session.getId(),i);
        // sessionList에 session이 있다면
		//log.info("sessionList.get(session) = {}", sessionList.get(session));
//        if(sessionList.get(session) != null) {
//            // 해당 session의 방 번호를 가져와서, 방을 찾고, 그 방의 List<session>에서 해당 session을 지운다.
//            RoomList.get(sessionList.get(session)).remove(session);
//            sessionList.remove(session);
//        }
		
		if(sessionList.get(session) != null) {
			RoomList2.get(sessionList.get(session)).remove(session);
			sessionList.remove(session);
		}
		
        log.info("연결 끝 RoomList2 = {} , sessionList = {}", RoomList2, sessionList);
        
        
        //session을 찾아서 지워야됨
        userSessions.remove(sessionsuser.get(session));
        sessionsuser.remove(session);
        log.info("userSession에 id값 뺌 ={}", userSessions);
        
	}
	
	//timerupdate(chat); -> 채팅방 들어가있을때 메세지 확인
//	public void timerupdate(Chat chat1) {
//        Timer scheduler = new Timer();
//        TimerTask task = new TimerTask() {
//            @Override
//            public void run() {
//                chatService.updateUnreadCount(chat1);
//            }
//        };
//        scheduler.scheduleAtFixedRate(task, 1000, 5000); // 1초 뒤 5초마다 반복실행
//	}


}