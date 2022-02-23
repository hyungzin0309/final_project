package com.kh.hana.group.model.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class GroupBoardEntity implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int no;
	private String groupId;
	private String writer;
	private String content;
	private Date regDate;
	private String placeName;
	private String placeAddress;
	private double locationY;
	private double locationX;
	private String[] image;
	private String[] tagMembers;
}