package com.kh.hana.group.model.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class GroupBoardComment extends GroupBoardCommentEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String writerProfile;
	public GroupBoardComment(int no, int boardNo, int commentLevel, int commentRef, String writer, String content,
			Date regDate, String writerProfile) {
		super(no, boardNo, commentLevel, commentRef, writer, content, regDate);
		this.writerProfile = writerProfile;
	}

}
