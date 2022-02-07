package com.kh.hana.member.model.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AccoutPrivate implements Serializable{ 
	 
	private static final long serialVersionUID = 1L;
 
	private String memberId;
	private int accountCheck;
	
	
 
	
	
	
}