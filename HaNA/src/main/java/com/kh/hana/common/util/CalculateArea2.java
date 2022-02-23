package com.kh.hana.common.util;

import java.math.BigDecimal;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CalculateArea2 {

	// X, Y : 기준 locationX, locationY - A, B : 비교할 locationX, locationY
	public static double calculateArea(String X, String Y, String A, String B) {
		
		String lo1X = X;
		String lo1Y = Y;
		String lo2X = A;
		String lo2Y = B;
		
		if(X == A && Y == B) {
			return 0;
		}
		
		BigDecimal aX1 = BigDecimal.valueOf(Double.parseDouble(lo1X));
		BigDecimal aY1 = BigDecimal.valueOf(Double.parseDouble(lo1Y));
		BigDecimal bX1 = BigDecimal.valueOf(Double.parseDouble(lo2X));
		BigDecimal bY1 = BigDecimal.valueOf(Double.parseDouble(lo2Y));
		
		String locationX = aX1.subtract(bX1).toString();
		String locationY = aY1.subtract(bY1).toString();
		
		log.info("locationX = {}", locationX);
		log.info("locationY = {}", locationY);
		
		double xa = Double.parseDouble(locationX.substring(0, locationX.indexOf(".")));
		double xbCal = Double.parseDouble(locationX.substring(locationX.lastIndexOf("."))) * 60;
		String xbCal2 = Double.toString(xbCal);
		double xb = Double.parseDouble(xbCal2.substring(0, xbCal2.indexOf(".")));
		
		double xcCal = (xbCal - xb) * 60;
		String xcCal2 = Double.toString(xcCal);
		double xc = Double.parseDouble(xcCal2);
		
		double ya = Double.parseDouble(locationY.substring(0, locationY.indexOf(".")));
		double ybCal = Double.parseDouble(locationY.substring(locationY.lastIndexOf("."))) * 60;
		String ybCal2 = Double.toString(ybCal);
		double yb = Double.parseDouble(ybCal2.substring(0, ybCal2.indexOf(".")));
		
		double ycCal = (ybCal - yb) * 60;
		String ycCal2 = Double.toString(ycCal);
		double yc = Double.parseDouble(ycCal2);

		double result1 = (xa * 88.9) + (xb * 1.48) + (xc * 0.025);
		double result2 = (ya * 111.3) + (yb * 1.86) + (yc * 0.031);
		
		
		double finalResult = Math.sqrt((result1 * result1) + (result2 * result2));
		
		log.info("finalResult = {}", finalResult);
		
		return finalResult;
	}
	
}
