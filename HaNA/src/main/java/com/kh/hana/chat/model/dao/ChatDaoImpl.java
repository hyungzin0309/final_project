package com.kh.hana.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.hana.chat.model.vo.Chat;
import com.kh.hana.chat.model.vo.ChatRoom;
import com.kh.hana.chat.model.vo.Noti;
import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Member;

@Repository
public class ChatDaoImpl implements ChatDao {
	
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<ChatRoom> roomList(String id) {
		return session.selectList("chat.roomList",id);
	}

	@Override
	public Chat test() {
		return session.selectOne("chat.test");
	}

	@Override
	public List<Chat> roomchat(int no) {
		return session.selectList("chat.roomchat",no);
	}

	@Override
	public ChatRoom selectChatRoom(int roomNo) {
		return session.selectOne("chat.selectChatRoom", roomNo);
	}

	@Override
	public int insertMessage(Chat chat) {
		return session.insert("chat.insertMessage", chat);
	}

	@Override
	public List<Member> memberList() {
		return session.selectList("chat.memberList");
	}


	@Override
	public List<ChatRoom> chatRoomCheck(Map<String, Object> param) {
		return session.selectList("chat.chatRoomCheck",param);
	}

	@Override
	public int createChatRoom(Map<String, Object> param) {
		return session.insert("chat.createChatRoom",param);
	}

	@Override
	public int insertEnterMessage(Map<String, Object> param) {
		return session.insert("chat.insertEnterMessage",param);
	}
	
	@Override
	public int insertEnterMessage2(Map<String, Object> param) {
		return session.insert("chat.insertEnterMessage2", param);
	}

	@Override
	public int findRoomNo(Map<String, Object> param) {
		return session.selectOne("chat.findRoomNo", param);
	}

	@Override
	public ChatRoom selectOneChatRoom(int no) {
		return session.selectOne("chat.selectOneChatRoom", no);
	}

	@Override
	public int CreateGroupChat(Group group) {
		return session.insert("chat.CreateGroupChat", group);
	}

	@Override
	public List<Member> memberList(String value) {
		return session.selectList("chat.memberList2", value);
	}

	@Override
	public String searchPicture(String member) {
		return session.selectOne("chat.searchPicture",member);
	}

	@Override
	public List<Map<String, Object>> roomchat2(Map<String, Object> param) {
		return session.selectList("chat.roomchat2", param);
	}

	@Override
	public int exitRoom(int roomNo) {
		return session.delete("chat.exitRoom",roomNo);
	}

	@Override
	public int insertFileMessage(Chat chat) {
		return session.insert("chat.insertFileMessage",chat);
	}

	@Override
	public int updateUnreadCount(Chat chat) {
		return session.update("chat.updateUnreadCount",chat);
	}

	@Override
	public List<String> selectListReceiver(Chat chat) {
		return session.selectList("chat.selectListReceiver",chat);
	}

	@Override
	public int dmalarm(String id) {
		return session.selectOne("chat.dmalarm",id);
	}

	@Override
	public int roomUnreadChat(Chat chat) {
		return session.selectOne("chat.roomUnreadChat",chat);
	}

	@Override
	public int insertGroupMessage(Map<String, Object> param) {
		return session.insert("chat.insertGroupMessage",param);
	}

	@Override
	public int selectGroupRoomNo(Group group) {
		return session.selectOne("chat.selectGroupRoomNo", group);
	}

	@Override
	public int insertGroupMessage22(Map<String, Object> param) {
		return session.insert("chat.insertGroupMessage22",param);
	}

	@Override
	public List<GroupBoard> selectListGroupBoard(String memberId) {
		return session.selectList("chat.selectListGroupBoard", memberId);
	}

	@Override
	public List<Board> selectListMemberBoard(String memberId) {
		return session.selectList("chat.selectListMemberBoard",memberId);
	}

	@Override
	public List<Member> followingRecommendList(String memberId) {
		return session.selectList("chat.followingRecommendList",memberId);
	}

	@Override
	public List<Member> groupRecommendList(String memberId) {
		return session.selectList("chat.groupRecommendList",memberId);
	}

	@Override
	public int insertShareMessage(Map<String, Object> param) {
		return session.insert("chat.insertShareMessage", param);
	}

	@Override
	public GroupBoardComment selectOnegroupBoardComment() {
		return session.selectOne("chat.selectOnegroupBoardComment");
	}

	@Override
	public BoardComment selectOneMemberBoardComment() {
		return session.selectOne("chat.selectOneMemberBoardComment");
	}

	@Override
	public int GroupRoomOutMessage(Map<String, Object> param) {
		return session.insert("chat.GroupRoomOutMessage", param);
	}

	@Override
	public int insertNoti(Map<String, Object> param) {
		return session.insert("chat.insertNoti", param);
	}

	@Override
	public List<Noti> notiAlarm(String id) {
		return session.selectList("chat.notiAlarm",id);
	}

	@Override
	public int notiReadCheck(String id) {
		return session.delete("chat.notiReadCheck",id);
	}

	@Override
	public Integer checkMemberGroup(Map<String, Object> param) {
		return session.selectOne("chat.checkMemberGroup",param);
	}

	@Override
	public int updateROOMOUTmessage(Map<String, Object> map) {
		return session.update("chat.updateROOMOUTmessage",map);
	}

	@Override
	public int roomChatUpdateImage(Group group) {
		return session.update("chat.roomChatUpdateImage",group);
	}

	@Override
	public List<Member> followerList(String id) {
		return session.selectList("chat.followerList",id);
	}

	@Override
	public int roomChatUpdate(Group group) {
		return session.update("chat.roomChatUpdate",group);
	}

	@Override
	public List<Map<String, Object>> mostPopularMember() {
		return session.selectList("chat.mostPopularMember");
	}




}