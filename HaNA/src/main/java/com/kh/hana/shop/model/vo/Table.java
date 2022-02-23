package com.kh.hana.shop.model.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Table implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String shopId;
	private String tableId;
	private String tableName;
	private int allowVisitor;
	private String allowStart;
	private String allowEnd;
	private int timeDiv;
	private int timeMax;
	private String memo;
	private String enable;
	private String updatable;
	private String price;
	
}
