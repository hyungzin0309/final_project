package com.kh.hana.group.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class GroupMemberList {

	private String groupId;
	private String memberId;
	private String memberLevelCode;
}
