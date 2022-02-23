package com.kh.hana.member.model.vo;

import java.io.Serializable;
import java.util.Date;

import com.kh.hana.member.model.vo.Member;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
public class Board extends BoardEntity implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String writerProfile;
	private String shopId;
	public Board(int no, String writer, String content, Date regDate, String boardType, String[] picture,
			String writerProfile, String shopId) {
		super(no, writer, content, regDate, boardType, picture);
		this.writerProfile = writerProfile;
		this.shopId = shopId;
	}
 
	
	
	
}