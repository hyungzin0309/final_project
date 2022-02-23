package com.kh.hana.group.model.vo;

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
public class GroupBoard extends GroupBoardEntity implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String writerProfile;
	private String groupName;
	private String groupImage;
	public GroupBoard(int no, String groupId, String writer, String content, Date regDate,
			String placeName, String placeAddress, double locationY, double locationX, String[] image,
			String[] tagMembers, String writerProfile, String groupName, String groupImage) {
		super(no, groupId, writer, content, regDate, placeName, placeAddress, locationY, locationX, image,
				tagMembers);
		this.writerProfile = writerProfile;
		this.groupName = groupName;
		this.groupImage = groupImage;
	}
	
	
	
	
	
}