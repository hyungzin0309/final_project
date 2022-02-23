package com.kh.hana.member.model.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class BoardComment extends BoardCommentEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String writerProfile;
	public  BoardComment(int no, int boardNo, int commentLevel, String writer, String content,
			Date regDate, int commentRef, String writerProfile) {
		super(no, boardNo, commentLevel,writer, content, commentRef,  regDate);
		this.writerProfile = writerProfile;
	}

}
