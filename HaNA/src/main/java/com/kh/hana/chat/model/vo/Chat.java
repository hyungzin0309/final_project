package com.kh.hana.chat.model.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.kh.hana.member.model.vo.Member;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Chat implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int roomNo;
	private String memberId;
	private String message;
	private Date messageRegDate;
	private int unReadCount;
	private String picture; // 프로필사진
	private String fileImg;
	
	
	
	
	
	
	
	
	

}