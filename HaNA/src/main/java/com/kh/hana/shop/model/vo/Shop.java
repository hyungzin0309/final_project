package com.kh.hana.shop.model.vo;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class Shop extends ShopEntity implements Serializable {
	
	private List<Reservation> manageTables;
	private List<HashTag> hashTags;
	private String picture;

	@Builder
	public Shop(String id, String shopName, String bussinessHourStart, String bussinessHourEnd, String locationX, String locationY,
			String address, String addressDetail, String shopIntroduce,String picture, List<Reservation> manageTables,List<HashTag> hashTags) {
		super(id, shopName, bussinessHourStart, bussinessHourEnd, locationX, locationY, address, addressDetail, shopIntroduce );
		this.manageTables = manageTables;
	}




	

	
}
