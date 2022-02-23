package com.kh.hana.shop.model.vo;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ShopEntity {

	private String id;
	private String shopName;
	private String bussinessHourStart;
	private String bussinessHourEnd;
	private String locationX;
	private String locationY;
	private String address;
	private String addressDetail;
	private String shopIntroduce;

	

	
	
	
	
}
