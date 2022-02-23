package com.kh.hana.chat.model.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatRoom implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int roomNo;
	private String roomName;
	private int roomType; //default 0 0은 1:1 / 1은 소모임 
	private String groupRoomId;
	private String members;
	private String groupImg;

}