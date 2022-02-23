package com.kh.hana.shop.model.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HashTag implements Serializable {
	
	private String tagId;
	private String tagName;
	private String memberId;
	

}
