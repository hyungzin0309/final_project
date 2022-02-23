package com.kh.hana.chat.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.hana.chat.model.dao.ChatDao;
import com.kh.hana.chat.model.vo.Chat;
import com.kh.hana.chat.model.vo.ChatRoom;
import com.kh.hana.chat.model.vo.Noti;
import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	private ChatDao chatDao;

	@Override
	public List<ChatRoom> roomList(String id) {
		return chatDao.roomList(id);
	}

	@Override
	public Chat test() {
		return chatDao.test();
	}

	@Override
	public List<Chat> roomchat(int no) {
		return chatDao.roomchat(no);
	}

	@Override
	public ChatRoom selectChatRoom(int roomNo) {
		return chatDao.selectChatRoom(roomNo);
	}

	@Override
	public int insertMessage(Chat chat) {
		return chatDao.insertMessage(chat);
	}

	@Override
	public List<Member> memberList() {
		return chatDao.memberList();
	}


	@Override
	public String chatRoomCheck(Map<String, Object> param) {
		String msg = "";
		int roomNo = 0;
		List<ChatRoom> chatlist = chatDao.chatRoomCheck(param);
		//공유번호가 없으면 일반 채팅방생성 후 입력메세지
		if(param.get("reservationNo") == null) {
			
			if(chatlist.size() == 0) {
				int result = chatDao.createChatRoom(param);
				log.info("createChatRoom result = {}", result);
				if(result > 0) {
					
					//나중에 selectKey로 바꾸기
					roomNo = chatDao.findRoomNo(param);
					param.put("roomNo", roomNo);
					int insert1 = chatDao.insertEnterMessage(param);
					if(insert1 > 0) {
						insert1 = chatDao.insertEnterMessage2(param);
						if(insert1 >0)
							msg = "채팅방 생성 성공";
					}
						
				}
				else
					msg = "채팅방 생성 실패,"+roomNo;
			}
			else {
				roomNo = chatDao.findRoomNo(param);
				msg = "채팅방이 있습니다,"+roomNo;
			}
		}
		
		//공유번호 있으면 채팅방에 공유메세지 뿌려주기
		else {
			//공유번호o, 채팅방 없을때
			if(chatlist.size() == 0) {
				//나중에 selectKey로 바꾸기
				int result = chatDao.createChatRoom(param);
				log.info("createChatRoom result = {}", result);
				if(result > 0) {
										
					roomNo = chatDao.findRoomNo(param);
					param.put("roomNo", roomNo);
					//입장메세지 다 보내고
					int insert1 = chatDao.insertEnterMessage(param);
					if(insert1 > 0) {
						insert1 = chatDao.insertEnterMessage2(param);
						msg = String.valueOf(roomNo);
						//공유메세지 보내기
//						if(insert1 >0) {
//							insert1 = chatDao.insertShareMessage(param);
//							msg = String.valueOf(roomNo);
//
//						}
					}
				}
				else
						msg = null;
					
			}
			//공유번호o, 채팅방 있을때
			else {
				roomNo = chatDao.findRoomNo(param);
				param.put("roomNo", roomNo);
				msg = String.valueOf(roomNo);
//				int insert1 = chatDao.insertShareMessage(param);
//				if(insert1 > 0)
//					msg = String.valueOf(roomNo);
			}
		}
		return msg;
	}

	@Override
	public int createChatRoom(Map<String, Object> param) {	
		return chatDao.createChatRoom(param);
	}

	@Override
	public int insertEnterMessage(Map<String, Object> param) {
		int result2 = 0;
		int result = chatDao.insertEnterMessage(param);
		if(result > 0)
			result2 = chatDao.insertEnterMessage2(param);
		return result2;
	}

	@Override
	public int findRoomNo(Map<String, Object> param) {
		return chatDao.findRoomNo(param);
	}

	@Override
	public ChatRoom selectOneChatRoom(int no) {
		return chatDao.selectOneChatRoom(no);
	}

	@Override
	public int CreateGroupChat(Group group) {
		Map<String, Object> param = new HashMap<String, Object>();
		int result = chatDao.CreateGroupChat(group);
		int roomNo = chatDao.selectGroupRoomNo(group);
		param.put("group", group);
		param.put("roomNo", roomNo);
		int result2 = 0;
		log.info("CreateGroupChat serviceImpl roomNo넣음= {}", param);
		if(result > 0)
			result2 = chatDao.insertGroupMessage(param);
		return result2;
	}

	@Override
	public List<Member> memberList(String value) {
		return chatDao.memberList(value);
	}

	@Override
	public String searchPicture(String member) {
		return chatDao.searchPicture(member);
	}

	@Override
	public List<Map<String, Object>> roomchat2(Map<String, Object> param) {
		return chatDao.roomchat2(param);
	}

	@Override
	public int exitRoom(int roomNo) {
		return chatDao.exitRoom(roomNo);
	}

	@Override
	public int insertFileMessage(Chat chat) {
		return chatDao.insertFileMessage(chat);
	}

	@Override
	public int updateUnreadCount(Chat chat) {
		return chatDao.updateUnreadCount(chat);
	}

	@Override
	public List<String> selectListReceiver(Chat chat) {
		return chatDao.selectListReceiver(chat);
	}

	@Override
	public int dmalarm(String id) {
		return chatDao.dmalarm(id);
	}

	@Override
	public int roomUnreadChat(Chat chat) {
		return chatDao.roomUnreadChat(chat);
	}

	@Override
	public int insertGroupMessage22(Map<String, Object> param) {
		return chatDao.insertGroupMessage22(param);
	}

	@Override
	public List<GroupBoard> selectListGroupBoard(String memberId) {
		return chatDao.selectListGroupBoard(memberId);
	}

	@Override
	public List<Board> selectListMemberBoard(String memberId) {
		return chatDao.selectListMemberBoard(memberId);
	}

	@Override
	public List<Member> recommendMemberList(String memberId) {
		List<Member> member1 = chatDao.followingRecommendList(memberId);
		List<Member> member2 = chatDao.groupRecommendList(memberId);
		List<Member> member = new ArrayList<Member>();
		if(member1.size() > 0 && member2.size() >0) {
			member.addAll(member1);
			member.addAll(member2);
		}
		else if(member1.size() == 0 && member2.size() != 0) {
			member.addAll(member2);
		}
		else if(member1.size() != 0 && member2.size() == 0) {
			member.addAll(member1);
		}
			
		return member;
	}

	@Override
	public GroupBoardComment selectOnegroupBoardComment() {
		return chatDao.selectOnegroupBoardComment();
	}

	@Override
	public BoardComment selectOneMemberBoardComment() {
		return chatDao.selectOneMemberBoardComment();
	}

	@Override
	public int insertNoti(Map<String, Object> param) {
		return chatDao.insertNoti(param);
	}

	@Override
	public List<Noti> notiAlarm(String id) {
		return chatDao.notiAlarm(id);
	}

	@Override
	public int notiReadCheck(String id) {
		return chatDao.notiReadCheck(id);
	}

	@Override
	public Map<String, Object> groupDMcheckMember(Map<String, Object> param) {
		Integer roomNo = chatDao.checkMemberGroup(param);
		Map<String, Object> resp = new HashMap<String, Object>();
		if(roomNo != null) {
			resp.put("check", true);
			resp.put("roomNo", roomNo);
		}
		else{
			resp.put("check", false);
		}
		return resp;
	}

	@Override
	public List<Member> followerList(String id) {
		return chatDao.followerList(id);
	}

	@Override
	public List<Map<String, Object>> mostPopularMember() {
		return chatDao.mostPopularMember();
	}








}