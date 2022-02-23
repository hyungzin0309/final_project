package com.kh.hana.chat.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.chat.model.service.ChatService;
import com.kh.hana.chat.model.vo.Chat;
import com.kh.hana.chat.model.vo.ChatRoom;
import com.kh.hana.chat.model.vo.Noti;
import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.group.model.service.GroupService;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.service.MemberService;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value= {"/chat","/common"})
public class ChatController {
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private ServletContext application;
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	@Autowired
	private GroupService groupService;
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping("/chat.do")
	public void chat() {}

	
    @GetMapping("/roomList.do")
    public ResponseEntity<?> roomlist(String id) {
        
    	List<ChatRoom> cList = chatService.roomList(id);
        
        log.info("cList = {}", cList);
        String members= "";
        String member = "";
        for(int i = 0; i < cList.size(); i++) {
            if(cList.get(i).getRoomType() != 1) {
            	members = cList.get(i).getMembers().replace(id, "");
            	member = members.replace(",", "");
            	cList.get(i).setMembers(member);
            	String roomImg = chatService.searchPicture(member);
            	cList.get(i).setGroupImg(roomImg);
            	
            }
        }

        return ResponseEntity.ok(cList);

    }
    
    @GetMapping("/roomchat.do")
    public ResponseEntity<?> roomchat(int no, String id){
    	log.info("no = {}",no);
    	Map<String, Object> param = new HashMap<String, Object>();
    	param.put("roomNo", no);
    	param.put("memberId", id);
    	
    	List<Map<String, Object>> chat = chatService.roomchat2(param);
    	//log.info("chat = {}", chat); 	  	
    	
    	return ResponseEntity.ok(chat);
    }
    
    //친구목록
    @GetMapping("/memberList.do")
    public ResponseEntity<?> memberList(@AuthenticationPrincipal Member Member){
    	String id = Member.getId();
    	List<Member> member = chatService.followerList(id);
    	log.info("memberList = {}", member);
    	return ResponseEntity.ok(member);
    }
    
    @GetMapping("/sendchat.do")
    public String sendchat(String memberId, String loginId, RedirectAttributes redirectAttr) {
    	log.info("member id= {}", memberId);
    	log.info("loginId = {}", loginId);
    	
    	Map<String, Object> param = new HashMap<>();
    	param.put("memberId", memberId);
    	param.put("loginId", loginId);
    	param.put("members", loginId+","+memberId);
    	

    	String msg = chatService.chatRoomCheck(param);
    	
    	redirectAttr.addFlashAttribute("msg", msg);

    	return "redirect:/chat/chat.do";
    	}

    			
    @GetMapping("/roomheader.do")
    public ResponseEntity<?> RoomHeader(String id, int no){
    	log.info("roomheader id = {}, no = {}", id ,no);
    	
    	ChatRoom chatroom = chatService.selectOneChatRoom(no);
    	log.info("roomheader chatroom = {}", chatroom);
    	
    	if(chatroom.getRoomType() != 1) {
    		String members = chatroom.getMembers().replace(id, "");
    		String member = members.replace(",", "");
    		chatroom.setMembers(member);
    		String roomImg = chatService.searchPicture(member);
    		chatroom.setGroupImg(roomImg);
    	}
    	return ResponseEntity.ok(chatroom);
    }
    		
    	
    
    @GetMapping("/searchFriend.do")
    public ResponseEntity<?> searchFriend(String value){
    	log.info("searchFriend value = {}", value);
    	List<Member> member = chatService.memberList(value);
    	
    	
    	return ResponseEntity.ok(member);
    }
    
    @GetMapping("/exitRoom.do")
    public String exitRoom(int roomNo, RedirectAttributes redirectAttr) {
    	int result = chatService.exitRoom(roomNo);
    	if(result > 0)
    		redirectAttr.addFlashAttribute("msg", "채팅방을 나갔습니다.");
    	else
    		redirectAttr.addFlashAttribute("msg", "채팅방 나가기 실패");
    	return "redirect:/chat/chat.do";
    }
    
    @PostMapping("/sendFile.do")
    public ResponseEntity<?> sendFile(MultipartHttpServletRequest filerequest){
    	
    	MultipartFile upfile = filerequest.getFile("image");
    	log.info("sendFile upfile = {}", upfile);
    	String saveDirectory = application.getRealPath("/resources/upload/chat/chat");
    	log.info("sendFile saveDirectory = {}", saveDirectory);
		
    	String originalFilename = upfile.getOriginalFilename();
		String renamedFilename = HanaUtils.rename(originalFilename);
		
		File saveImg = new File(saveDirectory, renamedFilename);
		try {
			upfile.transferTo(saveImg);
		} catch (IllegalStateException | IOException e) {
			log.error(e.getMessage(), e);
		}
		log.info("upfile originalfilename = {}",upfile.getOriginalFilename());
		log.info("upfile renamedFilename = {}",renamedFilename);
		
    	return ResponseEntity.ok(renamedFilename);
    }
    
    @GetMapping(value="/Filedownload.do",
    		produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public Resource Filedownload(String filename, HttpServletResponse response){
    	log.info("filename = {}", filename);
    	
		// 다운로드받을 파일 경로
		String saveDirectory = application.getRealPath("/resources/upload/chat/chat");
		File downFile = new File(saveDirectory, filename);
		String location = "file:" + downFile; // file객체의 toString은 절대경로로 오버라이드되어 있다.
		log.info("location = {}",location);
		Resource resource = resourceLoader.getResource(location);
		
		//헤더설정  (이거 안하면 바로보기됨!!)
		response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename);
    	
    	return resource;
    }
    
    @GetMapping("/updateunreadcount.do")
    public ResponseEntity<?> updateunreadcount(Chat chat){
    	log.info("updateunreadcount.do chat = {}", chat);
    	
    	int result = chatService.updateUnreadCount(chat);
    	log.info("이건 onmessage 메세지 수신받을때 읽음처리");
    	log.info("{}",result > 0 ? "읽음 처리 완료!" : "읽음 처리 실패!");
    	
    	return null;
    }
    
    @GetMapping("/dmalarm.do")
    public ResponseEntity<?> dmalarm(String id){

    	int unreadChat = chatService.dmalarm(id);

    	
    	return ResponseEntity.ok(unreadChat); 
    }
    
    @GetMapping("/roomUnreadChat.do")
    public ResponseEntity<?> roomUnreadChat(Chat chat){
    	int roomUnreadChat = chatService.roomUnreadChat(chat);
    	return ResponseEntity.ok(roomUnreadChat);
    }
    
    
    //태우님 예약공유
    @GetMapping("/shareReservation.do")
    public ResponseEntity<?> shareReservation(String reservationNo, String id, String targetUser){
    	log.info("shareReservation reservationNo = {}",reservationNo);
    	log.info("shareReservation id = {}",id);
    	log.info("shareReservation targetUser = {}",targetUser);
    	
    	Map<String, Object> param = new HashMap<String, Object>();
    	param.put("reservationNo", reservationNo);
    	param.put("loginId", id);
    	//targetUser
    	param.put("memberId", targetUser);
    	param.put("members", id+","+targetUser);
    	
    	//기존에 채팅방 있는지 체크 serviceImpl에서 작업
    	//채팅방 번호 가져옴
    	String roomNo = chatService.chatRoomCheck(param);
    	
    	return ResponseEntity.ok(roomNo);
    }
    
    
    
    
    
    
    
    
    
    //main페이지
    @RequestMapping(value="/main.do", method = RequestMethod.GET)
    public void main(Authentication authentication, Model model) {
    	//자기가 속한 소모임 최근게시글 3개
    	String memberId = authentication.getName();
    	
    	List<GroupBoard> groupboard = chatService.selectListGroupBoard(memberId);
    	for(int i = 0 ; i < groupboard.size(); i++) {
    		String content = groupboard.get(i).getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		groupboard.get(i).setContent(content);
    	};
    	//log.info("groupboard 몇개 나왔는지= {}", groupboard.size());
    	
    	//팔로잉한 친구 최근게시글 3개
    	List<Board> board = chatService.selectListMemberBoard(memberId);
    	for(int i = 0 ; i < board.size(); i++) {
    		String content = board.get(i).getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		board.get(i).setContent(content);
    	};
    	
    	//추천친구 (같은 그룹에 있지만 팔로잉 안된 친구 or 맞팔 안된 친구)
    	List<Member> memberList = chatService.recommendMemberList(memberId);
    	log.info("memberList = {}",memberList);
    	if(memberList.size() >0)
    		model.addAttribute(memberList);
    	else if(memberList.size() == 0) {
    		List<Map<String, Object>> popularList = chatService.mostPopularMember();
    		log.info("popularList = {}",popularList);
    		model.addAttribute("popularList",popularList);
    	}
    		
    	
    	
    	model.addAttribute("groupboard", groupboard);
    	model.addAttribute("board", board);
    }
    
    @GetMapping("/boardcommentList.do")
    public ResponseEntity<?> boardcommentList(int boardNo){
    	log.info("boardcommentList boardNo = {}", boardNo);
		List<GroupBoardComment> list = groupService.selectGroupBoardCommentList(boardNo);
    	for(int i = 0 ; i < list.size(); i++) {
    		String content = list.get(i).getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		list.get(i).setContent(content);
    	};
		log.info("list = {}",list);
    	
    	return ResponseEntity.ok(list);
    };
    
    @GetMapping("/memberboardcommentList.do")
    public ResponseEntity<?> memberboardcommentList(int boardNo){
    	log.info("boardcommentList boardNo = {}", boardNo);
    	List<BoardComment> list = memberService.selectBoardCommentList(boardNo);
    	for(int i = 0 ; i < list.size(); i++) {
    		String content = list.get(i).getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		list.get(i).setContent(content);
    	};
		log.info("list = {}",list);
    	
    	return ResponseEntity.ok(list);
    };
    

    @GetMapping("/insertgroupBoardcomment.do")
    public ResponseEntity<?> insertgroupBoardcomment(GroupBoardComment groupBoardComment){
    	log.info("insertgroupBoardcomment groupBoardComment= {}", groupBoardComment);
    	int result = groupService.insertGroupBoardComment(groupBoardComment);
    	if(result > 0) {
    		log.info("main 그룹게시판 댓글작성 성공!");
    		//selectKey 나중에 바꾸기 지금은 이상함 max(reg_date)
    		GroupBoardComment comment = chatService.selectOnegroupBoardComment();

        	String content = comment.getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		comment.setContent(content);
        	return ResponseEntity.ok(comment);
    	}
    	else
    		log.info("main 그룹게시판 댓글작성 실패!");

    	return ResponseEntity.ok(null);
    }
    
    @GetMapping("/insertgroupBoardcommentLevel2.do")
    public ResponseEntity<?> insertgroupBoardcommentLevel2(GroupBoardComment groupBoardComment){
    	log.info("insertgroupBoardcomment groupBoardComment= {}", groupBoardComment);
    	int result = groupService.insertGroupBoardComment(groupBoardComment);
    	if(result > 0)
    		log.info("main 그룹게시판 댓글작성 성공!");
    	else
    		log.info("main 그룹게시판 댓글작성 실패!");
    	
    	return ResponseEntity.ok(null);
    }
    
    
    @GetMapping("/insertmemberBoardcomment.do")
    public ResponseEntity<?> insertmemberBoardcomment(BoardComment boardComment){
    	log.info("insertgroupBoardcomment groupBoardComment= {}", boardComment);
    	int result = memberService.enrollBoardComment(boardComment);
    	if(result > 0) {
    		log.info("main 일반게시판 댓글작성 성공!");
    		//selectKey 나중에 바꾸기 지금은 이상함 max(reg_date)
    		BoardComment comment = chatService.selectOneMemberBoardComment();
        	String content = comment.getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    		comment.setContent(content);
    		return ResponseEntity.ok(comment);
    	}
    	else
    		log.info("main 일반게시판 댓글작성 실패!");

    	return ResponseEntity.ok(null);
    }
    
    @GetMapping("/insertmemberBoardcommentLevel2.do")
    public ResponseEntity<?> insertmemberBoardcommentLevel2(BoardComment boardComment){
    	log.info("insertgroupBoardcomment groupBoardComment= {}", boardComment);
    	int result = memberService.enrollBoardComment(boardComment);
    	if(result > 0)
    		log.info("main 일반게시판 댓글작성 성공!");
    	else
    		log.info("main 일반게시판 댓글작성 실패!");
    	
    	return ResponseEntity.ok(null);
    }
    
    //그룹 게시판 좋아요 불러오기
    @GetMapping("/groupboardLikeCount.do")
    public ResponseEntity<?> groupboardLikeCount(int boardNo){
		Map<String,Object> param = new HashMap<>();
		
		param.put("no",boardNo);
		int likeCount = groupService.selectLikeCount(param);
		
    	return ResponseEntity.ok(likeCount);
    }
  //그룹 게시판 좋아요 체크
    @GetMapping("/grouplikeCheck.do")
    public ResponseEntity<?> likeCheck(int boardNo, String memberId){
		Map<String,Object> param = new HashMap<>();
		param.put("memberId",memberId);
		param.put("boardNo", boardNo);
		Map<String,Object> likeLog = groupService.selectOneLikeLog(param);
		boolean isLiked = likeLog == null? false : true;
    	return ResponseEntity.ok(isLiked);
    }
  //그룹 게시판 좋아요 누르기
    @GetMapping("/insertLike.do")
    public ResponseEntity<?> insertLike(int no, String memberId){
    	int result = 0;
		
		try {

			Map<String,Object> param = new HashMap<>();
			param.put("memberId",memberId);
			param.put("boardNo",no);
			result = groupService.insertLikeLog(param);
			if(result > 0)
				return ResponseEntity.ok(result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return ResponseEntity.ok(null);

		}	
		return ResponseEntity.ok(null);
    }
  //그룹 게시판 좋아요 지우기
    @GetMapping("/deleteLike.do")
    public ResponseEntity<?> deleteLike(int no, String memberId){	
    	int result = 0;
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",memberId);
			param.put("boardNo",no);
		
			result = groupService.deleteLikeLog(param);

		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return ResponseEntity.ok(null);
		}

    	
    	return ResponseEntity.ok(result);
    }
    
  //멤버 게시판 좋아요 불러오기
	@GetMapping("/memberboardLikeCount.do")
	public ResponseEntity<?> memberboardLikeCount(int boardNo){
		Map<String,Object> param = new HashMap<>();
		
		param.put("no",boardNo);
		int likeCount2 = memberService.selectLikeCount(param);
		log.info("ssssssssssssssssssssssssssssssssssssssss");
		return ResponseEntity.ok(likeCount2);
	}    


	//멤버 게시판 좋아요 체크
	@GetMapping("/MemberlikeCheck.do")
    public ResponseEntity<?> MemberlikeCheck(int boardNo, String memberId){
		Map<String,Object> param = new HashMap<>();
		param.put("memberId",memberId);
		param.put("boardNo", boardNo);
		Map<String,Object> likeLog = memberService.selectOneLikeLog(param);
		boolean isLiked = likeLog == null? false : true;
    	return ResponseEntity.ok(isLiked);
    } 
	
	  //그룹 게시판 좋아요 누르기
    @GetMapping("/MemberBoardinsertLike.do")
    public ResponseEntity<?> MemberBoardinsertLike(int no, String memberId){
    	int result = 0;
		
		try {

			Map<String,Object> param = new HashMap<>();
			param.put("memberId",memberId);
			param.put("boardNo",no);
			result = memberService.insertLikeLog(param);
			if(result > 0)
				return ResponseEntity.ok(result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return ResponseEntity.ok(null);

		}	
		return ResponseEntity.ok(null);
    }

    //멤버 게시판 좋아요 지우기
    @GetMapping("/MemberBoarddeleteLike.do")
    public ResponseEntity<?> MemberBoarddeleteLike(int no, String memberId){	
    	int result = 0;
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",memberId);
			param.put("boardNo",no);
		
			result = memberService.deleteLikeLog(param);

		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return ResponseEntity.ok(null);
		}

    	
    	return ResponseEntity.ok(result);
    }
    
    @GetMapping("/mainPageDmSend.do")
    public ResponseEntity<?> mainPageDmSend(String memberId, String loginId){
    	log.info("mainPageDmSend memberId = {}", memberId);
    	log.info("mainPageDmSend loginId = {}", loginId);
    	Map<String, Object> param = new HashMap<String, Object>();
    	param.put("loginId", loginId);
    	param.put("memberId", memberId);
    	param.put("members", loginId+","+memberId);
    	String msg = chatService.chatRoomCheck(param);
    	String[] msgSplit = msg.split(",");
    	int roomNo = 0;
    	log.info("msg = {}",msg);
    	if(msgSplit[0].contains("성공") || msgSplit[0].contains("있습니다")) {
    		log.info("{}",msgSplit[0].contains("성공"));
    		log.info("{}",msgSplit[0].contains("있습니다"));
    		roomNo = Integer.parseInt(msgSplit[1]);
    	}
    	else
    		roomNo = 0;
    	
    	return ResponseEntity.ok(roomNo);
    }
    
    @GetMapping("/following.do")
    public ResponseEntity<?> following(String id, String loginId){
    	log.info("following id = {}",id);
    	log.info("following loginId = {}",loginId);
		Map<String, Object> map = new HashMap<>();
		//follow 테이블 member_id 랑 following_id 물어보기
		map.put("myId", loginId);
		map.put("friendId", id);
		log.info("map ={}", map);
		
		int result = memberService.addFollowing(map);   
		if(result > 0)
			result = 1;
		else
			result =0;
    	return ResponseEntity.ok(result);
    }
    
    @GetMapping("/notiAlarm.do")
    public ResponseEntity<?> notiAlarm(String id) {
    	
    	List<Noti> noti = chatService.notiAlarm(id);
    	
    	return ResponseEntity.ok(noti);
    }
    
    @GetMapping("/notiReadCheck.do")
    public ResponseEntity<?> notiReadCheck(String id){
    	int result = chatService.notiReadCheck(id);
    	if(result>0) log.info("noti readcheck");
    	return ResponseEntity.ok("readcheck");
    }
    
    @GetMapping("/groupDM.do")
    public ResponseEntity<?> groupDM(String groupId, String loginId){
    	log.info("groupId = {}", groupId);
    	log.info("loginId = {}", loginId);
    	Map<String, Object> param = new HashMap<String, Object>();
    	param.put("groupId", groupId);
    	param.put("loginId", loginId);
    	Map<String, Object> map = chatService.groupDMcheckMember(param);
    	
    	return ResponseEntity.ok(map);
    }
    		
}