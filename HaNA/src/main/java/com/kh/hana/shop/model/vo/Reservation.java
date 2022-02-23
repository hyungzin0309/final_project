package com.kh.hana.shop.model.vo;

import java.io.Serializable;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Reservation implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String reservationNo;
	private String reservationTableId;
	private String reservationUser;
	private String shopId;
	private Date reservationDate;
	private String timeStart;
	private String timeEnd;
	private int visitorCount;
	private String reqOrder;
	private String reservationStatus;
	private String attendUser;
	private String reqAccept;
	private String reqDutchpay;
	private String reviewStatus;
	private int originalprice;
	private int restprice;
	private String shopName;
	private String tableName;
}
